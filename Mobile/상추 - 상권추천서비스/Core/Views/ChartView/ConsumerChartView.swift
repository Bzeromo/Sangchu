//
//  ConsumerChartView.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/25/24.
//

import SwiftUI
import Charts

// 사용자 인터페이스를 정의하는 ContentView.swift 파일입니다.
// 애플리케이션의 뷰를 구성하고 네트워크 요청을 통해 차트 데이터를 로드합니다.

enum Endpoints: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case 분기별유동인구 = "floatingDataByQuarter"
    case 요일별유동인구 = "floatingDataByDay"
    case 시간대별유동인구 = "floatingDataByTime"
    case 연령별유동인구 = "floatingDataByAge"
    case 분기별상주인구 = "residentDataByQuarter"
    case 성연령별상주인구 = "residentByGenderAndAge"
    case 분기별직장인구 = "workingDataByQuarter"
    case 성연령별직장인구 = "workingDataByGenderAndAge"

    var englishEndpoint: String {
        switch self {
            case .분기별유동인구:
                return "/consumer/graph/floating/quarterly-trends"
            case .요일별유동인구:
                return "/consumer/graph/floating/day"
            case .시간대별유동인구:
                return "/consumer/graph/floating/time"
            case .연령별유동인구:
                return "/consumer/graph/floating/age"
            case .분기별상주인구:
                return "/consumer/graph/resident/quarterly-trends"
            case .성연령별상주인구:
                return "/consumer/graph/resident/gender-age"
            case .분기별직장인구:
                return "/consumer/graph/working/quarterly-trends"
            case .성연령별직장인구:
                return "/consumer/graph/working/gender-age"
        }
    } // end of englishEndpoint
    
    var displayName: String {
            switch self {
                case .분기별유동인구:
                    return "분기별유동인구"
                case .요일별유동인구:
                    return "요일별유동인구"
                case .시간대별유동인구:
                    return "시간대별유동인구"
                case .연령별유동인구:
                    return "연령별유동인구"
                case .분기별상주인구:
                    return "분기별상주인구"
                case .성연령별상주인구:
                    return "성/연령별상주인구"
                case .분기별직장인구:
                    return "분기별직장인구"
                case .성연령별직장인구:
                    return "성/연령별직장인구"
            }
        } // end of displayName
    
}


struct ConsumerChartView: View {
    // 차트 데이터들이 들어가 있는 배열 상태값
    @State private var chartDataSets: [[ConsumerModel.ChartData]] = Array(repeating: [], count: Endpoints.allCases.count)
    @State var cdCode: String = ""
    
    var body: some View {
                VStack (alignment: .leading) {
                    if chartDataSets.isEmpty {
                        Text("해당 데이터가 없습니다.")
                            .padding()
                    } else {
                        TabView {
                            ForEach(0..<chartDataSets.count, id: \.self) { index in
//                                Text("\(index)")
                                 if (chartDataSets[index].isEmpty) {
//                                     ProgressView().progressViewStyle(CircularProgressViewStyle())
                                 }
                                 else {
                                     VStack {
                                         HStack {
                                             // 데이터 분류용
                                             Text(Endpoints.allCases[index].displayName)
                                                 .font(.title2).bold().foregroundColor(Color.sangchu)
                                             Spacer()
                                             // 단위 표시용
                                             Text("*\\(단위: 명\\)")
                                                 .font(.caption)
                                                 .padding([.leading, .trailing])
                                         }
                                         // Chart view
                                         Chart(chartDataSets[index]) { data in
                                             BarMark(
                                                x: .value("n", data.label),
                                                y: .value("v", data.value)
                                             )
                                             .cornerRadius(5)
                                             .annotation(position: .top, alignment: .center) {
                                                 Text("\(data.value, specifier: "%.0f")") // 데이터 값 라벨, 소수점 없이 표현!
                                                     .font(.caption2)
                                                     .foregroundColor(Color.black)
                                                     .lineLimit(nil) // 라벨에 대한 줄바꿈 제한을 없애 줄바꿈을 허용
                                                     .fixedSize(horizontal: false, vertical: true) // 수직 방향으로 크기 고정 해제
                                                     .frame(width: 35)
                                             }
                                         }
                                         .padding()
                                         // x축 관련 설정
                                         .chartXAxis {
                                             AxisMarks() { value in
                                                 AxisGridLine(centered: true)
                                                 AxisTick()
                                                     .foregroundStyle(Color.clear)// x축 눈금 // 있지만 안보이게! // 없애면 x축 글자들 겹쳐서 보일수도 있음!
                                                 AxisValueLabel {
                                                     Text(value.as(String.self) ?? "")
                                                         .lineLimit(nil) // 라벨에 대한 줄바꿈 제한을 없애 줄바꿈을 허용
                                                         .fixedSize(horizontal: false, vertical: true)
                                                         .alignmentGuide(.firstTextBaseline) {
                                                             d in d[.firstTextBaseline]
                                                         }
                                                 }
                                             }
                                         }
                                         .chartYAxis {
                                             AxisMarks(preset: .aligned, position: .leading)
                                         }
                                         .padding(.bottom, 40)
                                     } // end of VStack
                                 } // end of else
                             } // end of ForEach
                         }
                        .frame(height: 300)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                        .padding()
                        .onAppear {
                            loadAllData()
                         }
                    }
                }
        
    } // end of body
    
    func loadAllData() {
        for (index, endpoint) in Endpoints.allCases.enumerated() {
            print(endpoint.rawValue)
            if endpoint.rawValue.contains("floating") {
//                print("유동인구 관련 함수 호출")
                loadFloatingData(endpoint : endpoint, index: index)
            } else {
//                print("상주/직장인구 관련 함수 호출")
                loadResidentOrWorkingData(endpoint : endpoint, index: index)
            }
        }
    }

    private func loadResidentOrWorkingData(endpoint: Endpoints, index: Int) {
        ConsumerNetworkManager.shared.fetch(endpoint: endpoint.englishEndpoint , commercialDistrictCode: cdCode) { result in
            DispatchQueue.main.async {
                switch result {
                // api 통신에 성공한 경우에 JSON을 받아와서 해석
                    case .success (let data):
                        do {
                            // ApiResponse의 형태로 디코딩한 분기별 데이터
                            let residentOrWorkingApiResponse = try JSONDecoder().decode(ConsumerModel.ResidentOrWorkingApiResponse.self, from: data)
                            
                            // 분기별 - quarterlyTrends
                            if endpoint.englishEndpoint.contains("quarterly") {
                                if let seriesData = residentOrWorkingApiResponse.quarterlyTrends?.data.series.first {
                                    //
                                    self.chartDataSets[index] = zip(residentOrWorkingApiResponse.quarterlyTrends?.data.categories ?? [] , seriesData.data)
                                        .map { (category, value) in ConsumerModel.ChartData(label: category, value: Double(value)) }
                                }
                            }
                            // 성/연령별 - genderAge
                            else if endpoint.englishEndpoint.contains("age") {
                                if let seriesData = residentOrWorkingApiResponse.genderAge?.data.series.first {
                                    //
                                    self.chartDataSets[index] = zip(residentOrWorkingApiResponse.genderAge?.data.categories ?? [] , seriesData.data)
                                        .map { (category, value) in ConsumerModel.ChartData(label: category, value: Double(value)) }
                                    if self.chartDataSets[index].isEmpty {
                                        print(endpoint.displayName + "에서")
                                        print("Decoding Value Error!")
                                    }
                                }
                            }
                        } catch {
                            print(String(index) + "번째에서 오류!")
                            print("Decoding error: \(error)")
                        }
                // api 통신 실패하면
                    case .failure(let error):
                        print("API Networking Error: \(error.localizedDescription)")
                }
            }
        }
    } // end of loadData
    
    private func loadFloatingData(endpoint: Endpoints, index: Int) {
        ConsumerNetworkManager.shared.fetch(endpoint: endpoint.englishEndpoint , commercialDistrictCode: cdCode) { result in
            DispatchQueue.main.async {
                switch result {
                // api 통신에 성공한 경우에 JSON을 받아와서 해석
                    case .success (let data):
                        do {
                            // ApiResponse의 형태로 디코딩한 분기별 데이터
                            let floatingApiResponse = try JSONDecoder().decode(ConsumerModel.FloatingApiResponse.self, from: data)
                            
                            // 분기별 - quarterlyTrends
                            if endpoint.englishEndpoint.contains("quarterly") {
                                if let seriesData = floatingApiResponse.quarterlyTrends?.data.series.first {
                                    //
                                    self.chartDataSets[index] = zip(floatingApiResponse.quarterlyTrends?.data.categories ?? [] , seriesData.data)
                                        .map { (category, value) in ConsumerModel.ChartData(label: category, value: Double(value)) }
                                    if self.chartDataSets[index].isEmpty {
                                        print("Decoding Value Error!")
                                    }
                                }
                            }
                            // 요일별 - day
                            else if endpoint.englishEndpoint.contains("day") {
                                if let seriesData = floatingApiResponse.day?.data.series.first {
                                    //
                                    self.chartDataSets[index] = zip(floatingApiResponse.day?.data.categories ?? [] , seriesData.data)
                                        .map { (category, value) in ConsumerModel.ChartData(label: category, value: Double(value)) }
                                    if self.chartDataSets[index].isEmpty {
                                        print(endpoint.displayName + "에서")
                                        print("Decoding Value Error!")
                                    }
                                }
                            }
                            // 시간대별 - time
                            else if endpoint.englishEndpoint.contains("time") {
                                if let seriesData = floatingApiResponse.time?.data.series.first {
                                    //
                                    self.chartDataSets[index] = zip(floatingApiResponse.time?.data.categories ?? [] , seriesData.data)
                                        .map { (category, value) in ConsumerModel.ChartData(label: category, value: Double(value)) }
                                    if self.chartDataSets[index].isEmpty {
                                        print(endpoint.displayName + "에서")
                                        print("Decoding Value Error!")
                                    }
                                }
                            }
                            // 연령별 - age
                            else if endpoint.englishEndpoint.contains("age") {
                                if let seriesData = floatingApiResponse.age?.data.series.first {
                                    //
                                    self.chartDataSets[index] = zip(floatingApiResponse.age?.data.categories ?? [] , seriesData.data)
                                        .map { (category, value) in ConsumerModel.ChartData(label: category, value: Double(value)) }
                                    if self.chartDataSets[index].isEmpty {
                                        print(endpoint.displayName + "에서")
                                        print("Decoding Value Error!")
                                    }
                                }
                            }
                            
                        } catch {
                            print("Decoding error: \(error)")
                        }
                // api 통신 실패하면
                    case .failure(let error):
                        print("API Networking Error: \(error.localizedDescription)")
                }
            }
        }
    } //end of loadFloatingData
} // end of ContentView
