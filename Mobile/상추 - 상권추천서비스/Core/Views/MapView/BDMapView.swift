//
//  MapView.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/14/24.
//
import SwiftUI
import NMapsMap
struct MapView: UIViewRepresentable {
    @Binding var showAlert: Bool
    @Binding var isSymbolTapped: Bool // 심볼이 탭 됐는지 여부
    @Binding var tappedLocation: NMGLatLng // 지도 상의 탭한 좌표
    @Binding var tappedSymbolCaption: String // 지도 상의 탭한 심볼의 이름
    
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
    
    var body: some View {
        NavigationView {
            VStack {
                MapView(showAlert: $showAlert, isSymbolTapped: $isSymbolTapped, tappedLocation: $tappedLocation, tappedSymbolCaption: $tappedSymbolCaption).edgesIgnoringSafeArea(.all)
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
            }
        }
    }
}
