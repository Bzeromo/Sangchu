//
//  SalesModel.swift
//  상추 - 상권추천서비스
//
//  Created by 양희태 on 3/25/24.
//

import Foundation

class SalesModel {
    
    /*
     처음에 디코딩을 
     */
    
    //--------------------------------------------------------------------//
    //[ 직전분기 ]
    //--------------------------------------------------------------------//
    
    // /
    // 특정 상권 매출 금액 조회
    struct RecentSalesData : Codable {
        let monthlySales : Int
        let weekDaySales : Int
        let weekendSales : Int
    }
    
    //--------------------------------------------------------------------//
    //[ 업종별 ]
    //--------------------------------------------------------------------//
    
    // /graph/ratio-industry
    // 서비스 업종별 매출 비율 그래프 (23년) 조회
    struct RatioIndustry : Codable {
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
    
    //--------------------------------------------------------------------//
    //[ 분기별 ]
    //--------------------------------------------------------------------//
    
    // /graph/quarterly
    // 분기별 월평균 ( 주중, 주말) 매출 그래프 ( 22±23) 조회
    struct QuarterlyApiResponse: Codable {
        let quarterlyGraph: QuarterlyGraph
    }
    struct QuarterlyGraph: Codable {
        let chartType: String
        let year: String
        let data: QuarterlyData
    }
    struct QuarterlyData: Codable {
        let categories: [String]
        let series: [QuarterlySeries]
    }
    struct QuarterlySeries: Codable {
        let YearQuarter: String
        let WeekDaySales: String
        let WeekendSales: String
    }
    
    //--------------------------------------------------------------------//
    //[ 요일별 ]
    //--------------------------------------------------------------------//
    
    // 특정 상권 요일별 매출 조회
    struct DayApiResponse: Codable {
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
        let daySalesCount: [Double]
        let daySales: [Double]
    }
    
    //--------------------------------------------------------------------//
    //[ 시간대별 ]
    //--------------------------------------------------------------------//
    
    // /graph/time
    // 특정 상권 시간대별 매출 금액 조회
    struct TimeApiResponse: Codable {
        let graphJson: TimeGraphJson
    }
    
    struct TimeGraphJson: Codable {
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
        let timeSalesCount: [Double]
        let timeSales: [Double]
    }
        
    //--------------------------------------------------------------------//
    //[ 연령대별 ]
    //--------------------------------------------------------------------//
    
    // /graph/age
    // 특정 상권 연령대별 매출 금액 조회
    struct AgeApiResponse: Codable {
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
        let ageSalesCount: [Double]
        let ageSales: [Double]
    }
    
    // About Chart
    // 차트로 만들 수 있게해주는 구조체
    struct IndustryRatioChartData: Identifiable, Hashable {
        let id = UUID()
        var label: String
        var valueRatio: Double
    }
    
    // 분기별 스택바 그리기 위해서 value를 2개로 나눠야 함!
    struct QuarterlyChartData: Identifiable, Hashable {
        let id = UUID()
        var label: String
        var valueWeekDay: Double
        var valueWeekend: Double
    }

    // 요일/시간대/연령대
    struct CountAndAmountChartData: Identifiable, Hashable {
        let id = UUID()
        var label: String
        var count: Double  // 매출 건수
        var amount: Double  // 매출 금액
    }
}
