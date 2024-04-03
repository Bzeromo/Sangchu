//
//  findDirectionView.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 4/1/24.
//

import SwiftUI

struct FindDirection     {
    func naverMap(lat: Double, lng: Double) {
        // URL Scheme을 사용하여 네이버맵 앱을 열고 자동차 경로를 생성합니다.
        guard let url = URL(string: "nmap://route/car?dlat=\(lat)&dlng=\(lng)&appname=com.sangchu.app") else { return }
        // 앱 스토어 URL을 설정합니다.
        guard let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8") else { return }

        if UIApplication.shared.canOpenURL(url) {
            // 네이버맵 앱이 설치되어 있는 경우 앱 열기
            UIApplication.shared.open(url)
        } else {
            // 네이버맵 앱이 설치되어 있지 않은 경우 앱 스토어로 이동
            UIApplication.shared.open(appStoreURL)
        }
    }
}
    
