//
//  ConsumerModel.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/25/24.
// Identifiable, Hashable

import Foundation
class ConsumerModel {
    
    // About Data Structure
    struct ChartTypeAndData: Codable {
        var chartType: String // bar
        var data: ChartableData // 해당 데이터들
    }
    
    struct ChartableData: Codable {
        var categories: [String] // 데이터 분류명
        var series: [SeriesData] // 데이터 값
    }
    
    struct SeriesData: Codable {
        var name: String // 데이터 이름
        var data: [Int] // 데이터 수치
    }
    
    
    // AboutAPI
    // 유동인구 API 요청 처음 받아 왔을 때의 구조체
    struct FloatingApiResponse: Codable {
        var age: ChartTypeAndData?
        var time: ChartTypeAndData?
        var day: ChartTypeAndData?
        var quarterlyTrends: ChartTypeAndData?
    }
    
    // 상주/직장인구 API 요청 처음 받아 왔을 때의 구조체
    struct ResidentOrWorkingApiResponse: Codable {
        var genderAge: ChartTypeAndData? // 성/연령별
        var quarterlyTrends: ChartTypeAndData? // 분기별
    }
    
    // About Chart
    // 차트로 만들 수 있게해주는 구조체
    struct ChartData: Identifiable, Hashable {
        let id = UUID()
        var label: String
        var value: Double
    }
    
}
