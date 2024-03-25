//
//  HomeModel.swift
//  상추 - 상권추천서비스
//
//  Created by 양희태 on 3/25/24.
//

import Foundation

class HomeModel {
    
    struct CommercialDistrict: Codable, Identifiable {
            var id = UUID() // SwiftUI의 List 등에서 사용하기 위해 Identifiable 프로토콜을 채택하고, 각 인스턴스에 고유한 ID를 제공합니다.
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
            let commercialDistrictCode: Int // 여기에 추가되었습니다.

            // CodingKeys를 정의하여 모든 필드들의 이름이 JSON 키와 동일하게 매핑되도록 합니다.
            enum CodingKeys: String, CodingKey {
                case commercialDistrictName, latitude, longitude, guCode, guName, dongCode, dongName, areaSize, commercialDistrictScore, salesScore, residentPopulationScore, floatingPopulationScore, rdiScore, commercialDistrictCode
            }
        }
   
}

