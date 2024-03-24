//
//  MapView.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/14/24.
//
import SwiftUI
import NMapsMap
import Foundation
import Combine

class MapViewModel: ObservableObject {
    @Published var selectedCDCode : String = ""
    @Published var selectedCDName : String = ""
    @Published var showBottomSheet : Bool = false
}

struct MapView: UIViewRepresentable {
    @Binding var showAlert: Bool
    @Binding var isSymbolTapped: Bool // 심볼이 탭 됐는지 여부
    @Binding var tappedLocation: NMGLatLng // 지도 상의 탭한 좌표
    @Binding var tappedSymbolCaption: String // 지도 상의 탭한 심볼의 이름
    var viewModel: MapViewModel
    
    // GeoJson 파일을 로드해서 Polygon 그리기
    /*
             polygons는 여러 개의 polygon들의 배열이고
             polygon은 다시 여러 개의 NMGLatLng들의 배열이고
             NMGLatLng는 (위도 : Double, 경도 : Double) 형태의 객체임
     
            polygonOverlay는 매개변수로 [NMGLatLng]를 받음
     */
    func loadAndDrawSBPolygons(mapView: NMFMapView) {
        // SeoulBoroughOutline라는 이름을 가진 geojson 형태의 데이터 가져오기 by Bundle
        guard let SeoulBoroughOutlinesgeoJSON = SeoulBoroughOutlineGeoJSONLoader.loadGeoJSONFile(named: "SeoulBoroughOutline") else { return }

        
        // GeoJSON 내의 각 Feature(지역)에 대해 폴리곤을 그리는 로직 구현
        SeoulBoroughOutlinesgeoJSON.features.forEach { feature in
            // 모든 폴리곤 좌표를 NMGLatLng 객체로 변환
            for feature in SeoulBoroughOutlinesgeoJSON.features {
                for polygon in feature.geometry.coordinates {
                    let coords = polygon.map { NMGLatLng(lat: $0[1], lng: $0[0]) }
                    
                    if let polygonOverlay = NMFPolygonOverlay(coords) {
                        polygonOverlay.fillColor = UIColor.sangchu.withAlphaComponent(0.008)
                        polygonOverlay.outlineColor = UIColor.sangchu // 폴리곤 외곽선 색상 설정
                        polygonOverlay.outlineWidth = 3 // 폴리곤 외곽선 두께 설정

                        polygonOverlay.minZoom = 7
                        polygonOverlay.maxZoom = 11 // 이 때 부터는 상권이 보이게 할 예정! // 상권의 minZoom을 같은 값으로 설정할 것!
                        polygonOverlay.mapView = mapView // 지도에 폴리곤 오버레이 추가
                    }
                }
            }
        }
    }
    
    func loadAndDrawCDPolygons(mapView: NMFMapView) {
        // SeoulBoroughOutline라는 이름을 가진 geojson 형태의 데이터 가져오기 by Bundle
        guard let geoJSON = CommercialDistrictOutlineGeoJSONLoader.loadGeoJSONFile(named: "CommercialDistrictOutline") else { return }
        
        // GeoJSON 내의 각 Feature(지역)에 대해 폴리곤을 그리는 로직 구현
        geoJSON.features.forEach { feature in
            // Geometry 타입에 따른 처리
            let type = feature.geometry.type
            switch type {
            case "Polygon":
                if case let .polygon(polygonCoordinates) = feature.geometry.coordinates {
                    let coords = polygonCoordinates.first!.map { NMGLatLng(lat: $0[1], lng: $0[0]) }
                    if let polygonOverlay = NMFPolygonOverlay(coords) {
                        polygonOverlay.fillColor = UIColor.red.withAlphaComponent(0.05)
                        polygonOverlay.outlineColor = UIColor.red
                        polygonOverlay.outlineWidth = 3
                        polygonOverlay.minZoom = 9
                        
                        // 폴리곤 터치 시 해당 상권 정보 시트로 띄우기
                        polygonOverlay.touchHandler = {
                            (polygonOverlay : NMFOverlay) -> Bool in
                            let CDcode = feature.properties.TRDAR_CD
                            let CDname = feature.properties.TRDAR_CD_N
                            DispatchQueue.main.async {
                                self.viewModel.selectedCDCode = CDcode
                                self.viewModel.selectedCDName = CDname
                                self.viewModel.showBottomSheet = true
                            }
                            return true
                        }
                        polygonOverlay.mapView = mapView
                    }
                }
            case "MultiPolygon":
                if case let .multiPolygon(multiPolygonCoordinates) = feature.geometry.coordinates {
                    for polygons in multiPolygonCoordinates {
                        for polygon in polygons {
                            let coords = polygon.map { NMGLatLng(lat: $0[1], lng: $0[0]) }
                            if let polygonOverlay = NMFPolygonOverlay(coords) {
                                polygonOverlay.fillColor = UIColor.red.withAlphaComponent(0.05)
                                polygonOverlay.outlineColor = UIColor.red
                                polygonOverlay.outlineWidth = 3
                                polygonOverlay.minZoom = 11
                                
                                // 폴리곤 터치 시 해당 상권 정보 시트로 띄우기
                                polygonOverlay.touchHandler = {
                                    (polygonOverlay : NMFOverlay) -> Bool in
                                    let CDcode = feature.properties.TRDAR_CD
                                    let CDname = feature.properties.TRDAR_CD_N
                                    DispatchQueue.main.async {
                                        self.viewModel.selectedCDCode = CDcode
                                        self.viewModel.selectedCDName = CDname
                                        self.viewModel.showBottomSheet = true
                                    }
                                    return true
                                }
                                polygonOverlay.mapView = mapView
                            }
                        }
                    }
                }
            default:
                // 기타 타입 처리
                print("Unsupported geometry type: \(type)")
            }
        }

    } // end of loadAndDrawCDPolygons

    
    let locationService = LocationService()
    
    // NMFMapView의 터치 관련 이벤트 처리를 위임(delegate)받는 class 구현
    class Coordinator: NSObject, NMFMapViewTouchDelegate {
            // 지도 뷰를 부모로 설정
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        // 지도를 탭했을 때 호출되는 메서드 구현 (해당 위도와 경도를 alert로 띄우기)
        func mapView(_ mapView: NMFMapView, didTapMap latLng: NMGLatLng, point: CGPoint) {
//            print("지도 좌표: \(latLng.lat), \(latLng.lng) / 화면 좌표: \(point.x), \(point.y)")
            self.parent.tappedLocation = latLng
            self.parent.isSymbolTapped = false // 탭한 게 심볼은 아님을 알려줘야 함
            self.parent.showAlert = true
        }
        
        // 지도의 심볼을 탭했을 때 호출되는 메서드 구현
        func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
            // 심볼의 caption을 가져와서 parent에 저장하고, alert 띄우기
            if let caption = symbol.caption {
                self.parent.tappedSymbolCaption = caption
                self.parent.isSymbolTapped = true // 탭한 게 심볼임을 알려줘야 함
                self.parent.showAlert = true
                return true
            }
            return false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> NMFNaverMapView {
        
        // 지도 내 사용자 인터페이스 뷰 객체
        // 각종 요소들 조작 가능
        let naverMapView = NMFNaverMapView()
        
        // 지도 뷰 자체 객체
        // 지도 기본적인 설정 조작 가능(타입, 밝기, 심볼 크기 등)
        let mapView = naverMapView.mapView
        
        // mapView관련 설정들 //
        // 정적 지도화를 위한 코드 2줄
        mapView.isTiltGestureEnabled = false
        mapView.isRotateGestureEnabled = false
        // delegate 설정
        mapView.touchDelegate = context.coordinator
        
        // 그 외
        mapView.mapType = .basic // map 타입
        mapView.setLayerGroup(NMF_LAYER_GROUP_TRANSIT, isEnabled: true) // 대중교통 레이어 추가
//        mapView.lightness = 0 // 밝기 [-1 ~ 1]
//        mapView.symbolScale = 1 // 심볼들의 크기
//        mapView.logoInteractionEnabled = false // 로고 클릭 가능 여부 // true가 기본값인데 건들지 말 것!
        mapView.isNightModeEnabled = true // 다크 모드 활성화 가능 여부
//        mapView.logoAlign = .leftTop // 네이버 로고 위치 // 기본값은 좌측 하단
        
        // 위치 오버레이 관련 설정
        let locationOverlay = mapView.locationOverlay
        locationService.requestLocation { coordinate in
            locationOverlay.location = NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
        }
//        locationOverlay.location = NMGLatLng(lat: 37.358581, lng: 127.103564)
        locationOverlay.heading = 90
        locationOverlay.icon = NMFOverlayImage.init(name: "")
        locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        
        // naverMapView 관련 설정들 //
        naverMapView.showCompass = true // 나침반
        naverMapView.showScaleBar = false // 축척 바
        naverMapView.showLocationButton = true // 현재 위치 버튼
        
        loadAndDrawSBPolygons(mapView: mapView)
        loadAndDrawCDPolygons(mapView: mapView)
        
        return naverMapView
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
    }
}

struct BDMapView: View {
    @State private var showAlert = false
    @State private var isSymbolTapped = false
    @State private var tappedLocation = NMGLatLng(lat: 0.0, lng: 0.0)
    @State private var tappedSymbolCaption = ""
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    MapView(showAlert: $showAlert, isSymbolTapped: $isSymbolTapped, tappedLocation: $tappedLocation, tappedSymbolCaption: $tappedSymbolCaption, viewModel: viewModel).edgesIgnoringSafeArea(.all)
                        .alert(isPresented: $showAlert) {
                            if isSymbolTapped {
                                // 심볼 클릭 시
                                return Alert(
                                    title: Text("심볼 정보"),
                                    message: Text("\(tappedSymbolCaption)"),
                                    dismissButton: .default(Text("확인"))
                                )
                            } else {
                                // 지도의 특정 지점 클릭 시
                                return Alert(
                                    title: Text("위치 정보"),
                                    message: Text("위도: \(tappedLocation.lat), 경도: \(tappedLocation.lng)"),
                                    dismissButton: .default(Text("확인"))
                                )
                            }
                        }
                        .sheet(isPresented: $viewModel.showBottomSheet) {
                                VStack(alignment: .center) {
                                    if (viewModel.selectedCDCode == "") {
                                        Text("선택하신 상권이 없습니다. 원하는 상권을 탭해보세요!")
                                            .font(.headline)
                                            .padding()
                                    }
                                    else {
                                        CDInfoView(CDcode: viewModel.selectedCDCode, CDname: viewModel.selectedCDName)
                                    }
//                                    Button("닫기") {
//                                        viewModel.showBottomSheet = false
//                                    }
//                                    .padding()
                                }
                                .presentationDetents([.fraction(0.75), .fraction(0.9)])
                                .edgesIgnoringSafeArea(.all)
                        }
                }
                VStack {
                    Spacer()
                    Button("상권 정보 보기") {
                        viewModel.showBottomSheet = true
                    }
                }
            } // end of ZStack
        } // end of NavigationView
    } // end of bodyView
} // end of BDMapView
