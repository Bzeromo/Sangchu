//
//  InfraModel.swift
//  상추 - 상권추천서비스
//
//  Created by 양희태 on 3/25/24.
//

import Foundation

class InfraModel {
    
    // 그래프 아님
    // 특정 상권 아파트 지표 조회
    struct InfraApt : Codable {
        var apartmentComplexes : Int
        var aptAvgArea : Int
        var aptAvgPrice : Int
        var areaGraph : String?
        var priceGraph : String? // 다 아직 널값임
    }

    // 그래프 아님
    // 특정 상권 집객시설 지표 조회
    struct InfraFacility : Codable {
        let facilities: Int
        let bus: Int
        let culTouristFacilities: Int
        let educationalFacilities: Int
        let trainSubway: Int
    }


    // 그래프 아님
    // 특정 상권 업종 다양성 지수 조회
    struct InfraIndicatorRdi : Codable {
        let indicator : String?
        let rdi : String
    }

    // 그래프 아님
    // 특정 상권 변화 지표 조회
    struct InfraIndicator : Codable {
        let indicator : String
        let rdi : String?
    }

    // 절취선
    // 특정 상권 점포 그래프 조회
    struct InfraGraphStoreCount : Codable {
        let chartType: String
        let data: StoreCountData
    }
    struct StoreCountData: Codable {
        let categories: [String]
        let series: [StoreCountSeries]
    }
    struct StoreCountSeries: Codable {
        let serviceCode: String
        let serviceName: String
        let storeCount: Int
        let franchiseStoreCount: Int

        enum CodingKeys: String, CodingKey {
            case serviceCode = "ServiceCode"
            case serviceName, storeCount, franchiseStoreCount
        }
    }
    
    // 절취선
    // 특정 상권 아파트 가격 별 세대 수 그래프 조회
    struct InfraGraphAptPrice : Codable {
        let apartmentComplexes: [String]? // null 가능성이 있으므로 옵셔널 타입으로 정의
        let aptAvgArea: Double?
        let aptAvgPrice: Double?
        let areaGraph: [String]? // 실제 타입이 무엇인지 JSON에서 명확하지 않으므로, 예시로 String 배열을 사용
        let priceGraph: InfraAptPriceGraph?
    }
    struct InfraAptPriceGraph: Codable {
        let chartType: String
        let data: InfraAptPriceeData
    }
    struct InfraAptPriceeData: Codable {
        let categories: [String]
        let series: [InfraAptPriceSeries]
    }
    struct InfraAptPriceSeries: Codable {
        let name: String
        let data: [Int]
    }
    // 절취선
    
    // 특정 상권 아파트 면적별 세대 수 그래프 조회
    struct InfraGraphAptArea : Codable {
        let apartmentComplexes: [String]?
        let aptAvgArea: Double?
        let aptAvgPrice: Double?
        let areaGraph: AptAreaGraph?
    }
    struct AptAreaGraph: Codable {
        let chartType: String
        let data: InfraGraphAptAreaData
    }
    struct InfraGraphAptAreaData: Codable {
        let categories: [String]
        let series: [InfraGraphAptAreaSeries]
    }
    struct InfraGraphAptAreaSeries: Codable {
        let name: String
        let data: [Int]
    }
    
    
    
    struct ChartData: Identifiable {
        let id = UUID()
        var label: String
        var value: Double
    }
    
}
