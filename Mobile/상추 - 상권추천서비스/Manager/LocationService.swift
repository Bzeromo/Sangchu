//
//  LocationService.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/18/24.
//

import Foundation
import CoreLocation
import SwiftUI


// 사용자의 현재 위치를 가져오기 위해 사용하는 클래스
// CLLocationManager를 생성하고 해당 객체의 delegate 프로토콜을 구현해 CLLocationManager의 delegate로 설정함
// 로케이션 매니저에 위치정보를 요청한 경우 locationManager(_manager:didUpdateLocations locations:) delegate 함수를 통해서 위치 정보를 가져올 수 있음

class LocationService : NSObject, CLLocationManagerDelegate {
    // 사용자의 위치를 관리하는 관리자 인스턴스 생성
    private let manager = CLLocationManager()
    
    // 위치 정보를 받아오면 실행하는 Closer 저장하는 변수의 타입을 저장
    // CLLocationCoordinate2D 타입의 위치 정보를 받고 반환 X
    var completionHandler: ((CLLocationCoordinate2D) -> (Void))?
    
    // LocationService
    override init() {
        super.init()
        // CLLocationManager의 delegate를 현재 인스턴스인 manager로 설정
        manager.delegate = self
        //위치 정보 승인 요청
        manager.requestWhenInUseAuthorization()
    }
    
    // 위치 제공 권한 상태 확인용 함수
    // 만약 결정이 안된 상태면
//    func checkAuthorizationStatus() {
//        switch manager.authorizationStatus { // 인스턴스 프로퍼티를 사용합니다.
//        case .notDetermined:
//            manager.requestWhenInUseAuthorization()
//            break
//        case .restricted, .denied:
//            manager.requestWhenInUseAuthorization()
//            break
//        case .authorizedWhenInUse, .authorizedAlways:
//            // 사용자가 위치 서비스 권한을 부여한 경우 위치 요청
//            manager.requestLocation()
//            break
//        @unknown default:
//            fatalError("새로운 권한 상태가 추가되었습니다. 처리가 필요합니다.")
//        }
//    }

    
    // 위치 정보 요청 시에 정보 요청이 성공하면 실행될 completionHandler를 등록해서 먼저 거치도록 설정
    // 이 때 @escaping 속성을 설정해두면 비동기 작업 완료시에도 메모리에서 해제되지 않고 남아있게 되어 위치 정보를 계속해서 활용 가능!
    func requestLocation(completion: @escaping ((CLLocationCoordinate2D) -> (Void))) {
        completionHandler = completion
        manager.requestLocation()
    }
    
    // 위치 정보는 주기적으로 업데이트 되므로 이를 중단하기 위한 함수
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    // 위치 정보가 업데이트 될 때 호출되는 delegate 함수
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        //requestLocation 에서 등록한 completion handler를 통해 위치 정보를 전달
        if let completion = self.completionHandler {
            completion(location.coordinate)
        }
        //위치 정보 업데이트 중단
        manager.stopUpdatingLocation()
    }
    
    // 위치 정보 업데이트 실패 시 호출되는 delegate 함수
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
