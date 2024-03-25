//
//  SalesModel.swift
//  상추 - 상권추천서비스
//
//  Created by 양희태 on 3/25/24.
//

import Foundation

class SalesModel {
    
    // api/sales
    // 특정 상권 매출 금액 조회
    struct Sales : Codable {
        let weekDaySales : Int
        let weekendSales : Int
        let monthlySales : Int
    }
    
    // api/sales/graph/time
    // 특정 상권 시간대별 매출 금액 조회
    struct GraphTime: Codable {
        let graphJson: GraphTimeGraphJson
    }
    struct GraphTimeGraphJson: Codable {
        let chartType: String
        let year: Int
        let commDistrictName: String
        let data: TimeData
    }
    struct TimeData: Codable {
        let categories: [String]
        let series: TimeSeries
    }
    struct TimeSeries: Codable {
        let timeSalesCount: [Int]
        let timeSales: [Int]
    }
    
    // api/sales/graph/ratio-industry
    // 서비스 업종별 매출 비율 그래프 (23년) 조회
    struct GraphRatioIndustry : Codable {
        let graphJson: RatioIndustryGraphJson
    }
 
    struct RatioIndustryGraphJson : Codable {
        let chartType : String
        let year : Int
        let commDistrictName : String
        let data : RatioIndustryData
    }
    
    struct RatioIndustryData : Codable {
        let categories : [String]
        let series : [Double]
    }
    
    // api/sales/graph/quarterly
    // 분기별 월평균 ( 주중, 주말) 매출 그래프 ( 22±23) 조회
    struct GraphQuarterly: Codable {
        let quarterlyGraph: QuarterlyGraph
    }
    struct QuarterlyGraph: Codable {
        let chartType: String
        let year: String
        let data: QuarterlyhData
    }
    struct QuarterlyhData: Codable {
        let categories: [String]
        let series: [QuarterlySeries]
    }
    struct QuarterlySeries: Codable {
        let yearQuarter: String
        let weekDaySales: String
        let weekendSales: String

        enum CodingKeys: String, CodingKey {
            case yearQuarter = "YearQuarter"
            case weekDaySales = "WeekDaySales"
            case weekendSales = "WeekendSales"
        }
    }
    

    // 특정 상권 요일별 매출 조회
    struct GraphDay: Codable {
        let graphJson: DayGraphJson
    }
    struct DayGraphJson: Codable {
        let chartType: String
        let year: Int
        let commDistrictName: String
        let data: DayData
    }
    struct DayData: Codable {
        let categories: [String]
        let series: DaySeries
    }
    struct DaySeries: Codable {
        let daySalesCount: [Int]
        let daySales: [Int]
    }
    
    // 특정 상권 시간대별 매출 금액 조회
    struct GraphAge: Codable {
        let graphJson: AgeGraphJson
    }
    struct AgeGraphJson: Codable {
        let chartType: String
        let year: Int
        let commDistrictName: String
        let data: AgeData
    }
    struct AgeData: Codable {
        let categories: [String]
        let series: AgeSeries
    }
    struct AgeSeries: Codable {
        let ageSalesCount: [Int]
        let ageSales: [Int]
    }
    
    
}
