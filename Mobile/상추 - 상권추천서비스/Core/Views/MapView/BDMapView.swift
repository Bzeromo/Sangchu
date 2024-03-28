//
//  MapView.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/14/24.
//
import SwiftUI
import NMapsMap
import Foundation
import Alamofire

class MapViewModel: ObservableObject {
    @Published var selectedCDCode : String = ""
    @Published var selectedCDName : String = ""
    @Published var showBottomSheet : Bool = false
    @Published var showBoroughSheet : Bool = false
    @Published var selectedBoroughLocation: NMGLatLng? = nil
}

struct CommercialDistrict: Codable {
    let commercialDistrictName: String
    let latitude: Double
    let longitude: Double
    let guCode: Int
    let guName: String
    let dongCode: Int
    let dongName: String
    let areaSize: Int
    let commercialDistrictScore: Double
    let salesScore: Double
    let residentPopulationScore: Double
    let floatingPopulationScore: Double
    let rdiScore: Double
}

struct MapView: UIViewRepresentable {
    @Binding var showAlert: Bool
    @Binding var isSymbolTapped: Bool // 심볼이 탭 됐는지 여부
    @Binding var tappedLocation: NMGLatLng // 지도 상의 탭한 좌표
    @Binding var tappedSymbolCaption: String // 지도 상의 탭한 심볼의 이름
    @Binding var cameraLatLng: NMGLatLng?
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
                        polygonOverlay.fillColor = UIColor.sangchu.withAlphaComponent(0.005)
                        polygonOverlay.outlineColor = UIColor.sangchu.withAlphaComponent(1) // 폴리곤 외곽선 색상 설정
                        polygonOverlay.outlineWidth = 2 // 폴리곤 외곽선 두께 설정

                        polygonOverlay.minZoom = 5
                        polygonOverlay.maxZoom = 13 // 이 때 부터는 상권이 보이게 할 예정! // 상권의 minZoom을 같은 값으로 설정할 것!
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
                        polygonOverlay.fillColor = UIColor.blue.withAlphaComponent(0.05)
//                        polygonOverlay.fillColor = UIColor.clear
                        polygonOverlay.outlineColor = UIColor.blue.withAlphaComponent(0.5)
                        polygonOverlay.outlineWidth = 1
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
                                polygonOverlay.fillColor = UIColor.purple.withAlphaComponent(0.05)
//                                polygonOverlay.fillColor = UIColor.clear
                                polygonOverlay.outlineColor = UIColor.purple.withAlphaComponent(0.5)
                                polygonOverlay.outlineWidth = 1
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
                    }
                }
            default:
                // 기타 타입 처리
                print("Unsupported geometry type: \(type)")
            }
        }

    } // end of loadAndDrawCDPolygons
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }


    
    func fetchCD(mapView: NMFMapView) {
        let url = "http://3.36.91.181:8084/api/commdist/all"
        AF.request(url).responseDecodable(of: [CommercialDistrict].self) { response in
            switch response.result {
            case .success(let districts):
                print(districts.count)
                // 결과 처리
                districts.forEach { district in
                    let lng = district.latitude
                    let lat = district.longitude
                    let dName = district.commercialDistrictName
                    let dScore = String(format: "총점 %.0f", district.commercialDistrictScore)
                    // 마커 관련 설정들
                    let cdMarker = NMFMarker()
                    let resizedImage = resizeImage(image: UIImage(named: "markerIcon.png")!, targetSize: CGSize(width: 50, height: 50))

                    // 마커 터치 이벤트
                    cdMarker.touchHandler = { _ in
                        return false
                    }
                    cdMarker.globalZIndex = -250000
                    
                    // 마커 이미지
                    cdMarker.iconImage = NMFOverlayImage(image: resizedImage)
                    // 위치
                    cdMarker.position = NMGLatLng(lat: lat, lng: lng)
                    
                    // 마커 사이즈
                    cdMarker.width = 0.001
                    cdMarker.height = 0.001
                    // 캡션(점수) 보조캡션(상권이름)
                    if dName.count > 8 {
                        let index = dName.index(dName.startIndex, offsetBy: 8)
                        cdMarker.captionText = String(dName[..<index]) + "..."
                    } else {
                        cdMarker.captionText = dName
                    }
                    cdMarker.captionTextSize = 15
                    cdMarker.captionRequestedWidth = 140
//                    cdMarker.captionColor = .systemPink // 글씨색 , UIColor red green blure로 설정 가능
//                    cdMarker.captionHaloColor = .white // 테두리색
                    // captionOffset = 15 양수일수록 아래로
                    cdMarker.subCaptionText = dScore
                    cdMarker.subCaptionTextSize = 15
                    cdMarker.subCaptionRequestedWidth = 100
//                    cdMarker.subCaptionColor = Color("") // 글씨색 , UIColor red green blure로 설정 가능
//                    cdMarker.captionAligns = [.top]
                    cdMarker.captionMinZoom = 13
                    cdMarker.minZoom = 13
                    // 마커 놓기
                    cdMarker.mapView = mapView
                }
            case .failure(let error):
                print("요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    let locationService = LocationService()
    
    // NMFMapView의 터치 관련 이벤트 처리를 위임(delegate)받는 class 구현
    class Coordinator: NSObject, NMFMapViewTouchDelegate {
            // 지도 뷰를 부모로 설정
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        // 지도를 탭했을 때 호출되는 메서드 구현 (해당 위도와 경도를 alert로 띄우기)
//        func mapView(_ mapView: NMFMapView, didTapMap latLng: NMGLatLng, point: CGPoint) {
//            print("지도 좌표: \(latLng.lat), \(latLng.lng) / 화면 좌표: \(point.x), \(point.y)")
//            self.parent.tappedLocation = latLng
//            self.parent.isSymbolTapped = false // 탭한 게 심볼은 아님을 알려줘야 함
//            self.parent.showAlert = true
//        }
        
        // 지도의 심볼을 탭했을 때 호출되는 메서드 구현
//        func mapView(_ mapView: NMFMapView, didTap symbol: NMFSymbol) -> Bool {
//            // 심볼의 caption을 가져와서 parent에 저장하고, alert 띄우기
//            if let caption = symbol.caption {
//                self.parent.tappedSymbolCaption = caption
//                self.parent.isSymbolTapped = true // 탭한 게 심볼임을 알려줘야 함
//                self.parent.showAlert = true
//                return true
//            }
//            return false
//        }
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
        fetchCD(mapView: mapView)
        
        return naverMapView
    }
    
    func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
        if let cameraPosition = cameraLatLng {
            // 지정된 위치로 카메라 이동
            print("\(cameraPosition.lat) , \(cameraPosition.lng) 로 이동합니다!")
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: cameraPosition)
            cameraUpdate.animation = .easeIn
            cameraUpdate.animationDuration = 0.3
            uiView.mapView.moveCamera(cameraUpdate) {_ in 
                DispatchQueue.main.async {
                    // UI 관련 업데이트이므로 메인스레드에서 메인 스레드
                    if (self.viewModel.selectedCDCode != "" && self.viewModel.selectedCDName != "") {
                        self.viewModel.showBottomSheet = true
                    }
                }
            }
            cameraLatLng = nil // 중복 이동 방지를 위해 nil로 설정
        }
        
        if let boroughLocation = viewModel.selectedBoroughLocation {
            let cameraUpdate = NMFCameraUpdate(scrollTo: boroughLocation)
            cameraUpdate.animation = .easeIn
            uiView.mapView.moveCamera(cameraUpdate) {_ in 
                uiView.mapView.zoomLevel = 11
            }
            
            // 이동 후 상태 초기화
            viewModel.selectedBoroughLocation = nil
        }
    }
}

struct BDMapView: View {
    @State private var showAlert = false
    @State private var isSymbolTapped = false
    @State private var tappedLocation = NMGLatLng(lat: 0.0, lng: 0.0)
    @State private var tappedSymbolCaption = ""
    var cameraLatitude: Double?
    var cameraLongitude: Double?
    var selectedCDCode: String?
    var selectedCDName: String?
    @State private var cameraLatLng: NMGLatLng?
    @StateObject private var viewModel = MapViewModel()
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    MapView(showAlert: $showAlert, isSymbolTapped: $isSymbolTapped, tappedLocation: $tappedLocation, tappedSymbolCaption: $tappedSymbolCaption, cameraLatLng: $cameraLatLng, viewModel: viewModel).edgesIgnoringSafeArea(.all)
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
                                .presentationDetents([.fraction(0.55), .fraction(0.9)])
                                .edgesIgnoringSafeArea(.all)
                        }
                        .sheet(isPresented: $viewModel.showBoroughSheet) {
                            VStack(alignment: .center) {
                                MapAdditional(viewModel: viewModel)
                            }
                            .presentationDetents([.fraction(0.8)])
                            .edgesIgnoringSafeArea(.all)
                        }
                        .onAppear {
                            // 필요한 경우 여기에서 초기 카메라 위치를 설정 (일단 서울 시청으로 해둠!) // 나중에 가능하면 사용자의 현재 위치로!
                            cameraLatLng = NMGLatLng(lat: cameraLatitude ?? 37.5666102, lng: cameraLongitude ?? 126.9783881)
                            viewModel.selectedCDCode = selectedCDCode ?? ""
                            viewModel.selectedCDName = selectedCDName ?? ""
                        }
                }
                VStack {
                    VStack{
                        
                    }.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.115).background(Color.white)
                    HStack{
                        Button(action: {
                            viewModel.showBoroughSheet = true
                        }) {
                            Label("자치구", systemImage: "mappin.and.ellipse.circle.fill").foregroundColor(.black)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.24, height: UIScreen.main.bounds.height * 0.05)
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.leading , 10)
                        .padding(.top,3)
    //                    .overlay(
    //                                RoundedRectangle(cornerRadius: 20)
    //                                    .stroke(Color.black, lineWidth: 0.3)
    //                            )
                        .shadow(radius: 2, x: 1 , y: 1)
                        
                        Spacer()
                    }
                    
                    
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.showBottomSheet = true
                    }) {
                        Label("상권 정보 보기", systemImage: "info.bubble.fill").foregroundColor(.black)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.05)
                    .background(Color.white)
                    .cornerRadius(20)
//                    .overlay(
//                                RoundedRectangle(cornerRadius: 20)
//                                    .stroke(Color.black, lineWidth: 0.3)
//                            )
                    .shadow(radius: 2, x: 1 , y: 1)
                    
                    Spacer().frame(height: UIScreen.main.bounds.height * 0.1)
                    
                }
                
                
                   
            }.ignoresSafeArea() // end of ZStack
            
        } 
        .navigationBarTitle("지도", displayMode: .inline)
        // end of NavigationView
    } // end of bodyView
} // end of BDMapView
