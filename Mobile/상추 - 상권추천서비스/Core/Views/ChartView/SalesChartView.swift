//
//  SalesChartView.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/25/24.
//

import SwiftUI
import Charts

enum SalesEndpoints: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case 직전분기월평균및주중주말매출금액 = "recent" // /
    case 업종별매출비율 = "industryRatioGraph" // /graph/ratio-industry
    case 분기별월평균및주중주말매출금액 = "quarterlyGraph" // /graph/quarterly
    case 요일별매출건수및금액 = "dayGraph" // /graph/day
    case 시간대별매출건수및금액 = "timeGraph" // /graph/time
    case 연령대별매출건수및금액 = "ageGraph" // /graph/age

    var englishEndpoint: String {
        switch self {
            case .직전분기월평균및주중주말매출금액:
                return "/"
            case .업종별매출비율:
                return "/graph/ratio-industry"
            case .분기별월평균및주중주말매출금액:
                return "/graph/quarterly"
            case .요일별매출건수및금액:
                return "/graph/day"
            case .시간대별매출건수및금액:
                return "/graph/time"
            case .연령대별매출건수및금액:
                return "/graph/age"
        }
    } // end of englishEndpoint
    
    var displayName: String {
            switch self {
                case .직전분기월평균및주중주말매출금액:
                    return "직전분기 월평균 및 주중/주말 매출 금액"
                case .업종별매출비율:
                    return "업종별 매출 비율"
                case .분기별월평균및주중주말매출금액:
                    return "분기별 월평균 및 주중/주말 매출 금액"
                case .요일별매출건수및금액:
                    return "요일별 매출 건수 및 금액"
                case .시간대별매출건수및금액:
                    return "시간대별 매출 건수 및 금액"
                case .연령대별매출건수및금액:
                    return "연령대별 매출 건수 및 금액"
            }
        } // end of displayName
}

// 분기별
//struct QuarterlyGraphView: View {
//    var data: [QuarterlySalesData]
//    
//    var body: some View {
//        VStack {
//            Text("분기별 주중/주말 매출")
//                .font(.headline)
//            Chart {
//                ForEach(data, id: \.quarter) { item in
//                    BarMark(
//                        x: .value("Quarter", item.quarter),
//                        y: .value("WeekDaySales", item.weekDaySales)
//                    )
//                    BarMark(
//                        x: .value("Quarter", item.quarter),
//                        y: .value("WeekendSales", item.weekendSales),
//                        stack: .byCategory
//                    )
//                }
//            }
//            .chartLegend(.hidden)
//            .frame(height: 300)
//        }
//    }
//}

struct industryRatioGraphView: View {
    var chartData: [SalesModel.ChartData]
    
    private var maxSalesCategory: String? {
        chartData.max(by: { $0.value < $1.value })?.label
    }

    var body: some View {
        VStack {
            Text("업종별 매출 비율")
                .font(.headline)
            Chart(chartData, id: \.label) { dataItem in
                SectorMark(
                    angle: .value("매출 비율", dataItem.value),
                    innerRadius: .ratio(0.5),
                    angularInset: 1.5
                )
                .cornerRadius(5)
                .opacity(dataItem.label == maxSalesCategory ? 1 : 0.5) // 가장 높은 매출 비율을 가진 업종을 강조
                .foregroundStyle(by: .value("업종", dataItem.label))
            }
            .frame(height: 200)
        }
    }
}

struct SalesChartView: View {
    @State private var isLoading = true
    @State private var chartDataSets: [[SalesModel.ChartData]] = Array(repeating: [], count: SalesEndpoints.allCases.count)
    @State var cdCode: String = ""
    
    
    var body: some View {
        VStack (alignment: .leading) {
            if chartDataSets.isEmpty {
                Text("해당 데이터가 없습니다.")
                    .padding()
            } else {
                VStack {
                    Text("직전분기월평균및주중주말매출금액")
                    HStack {
                        Text("년 매출")
                        Text("얼마")
                    }
                    HStack {
                        Text("주중 매출")
                        Text("얼마")
                    }
                    HStack {
                        Text("주말 매출")
                        Text("얼마")
                    }
                }
                TabView {
                    if isLoading {
                        Text("상권 데이터를 가져오는 중입니다.")
                    }
                    else {
                        Group {
                            // 분기별 유동인구 차트 표시
                            VStack {
                                
                            }
                        }
                    }
                } // end of TabView
            } // end of else
        } // end of outer VStack
        .onAppear() {
            loadSalesData()
        }
    } // end of body view
    
    func loadSalesData() {
        isLoading = true
        let group = DispatchGroup()
        
        for (index, endpoint) in ConsumerEndpoints.allCases.enumerated() {
            group.enter() // 그룹에 작업 추가 시작
            print("\(index)번째 요청 그룹에 들어옴")
        }
        
        group.notify(queue: .main) {
            // 모든 네트워크 요청 완료 후 실행될 코드
            print("데이터 다 가져왔네요!")
            self.isLoading = false
        }
        
        //
        //    func loadRecent(completion: @escaping () -> Void) {
        //        let url = "\(BASE_URL)"
        //        Alamofire.request(url, method: .get).responseDecodable(of: SalesModel.RecentSalesData.self) { response in
        //            switch response.result {
        //                case .success(let data):
        //                    // 데이터 처리
        //                    // 예: self.recentSalesData = data
        //                    print("Monthly Sales: \(data.monthlySales)")
        //                    print("Weekday Sales: \(data.weekDaySales)")
        //                    print("Weekend Sales: \(data.weekendSales)")
        //                case .failure(let error):
        //                    print(error)
        //            }
        //            completion()
        //        }
        //    }
    }
}
