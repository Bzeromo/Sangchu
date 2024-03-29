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

// 분기별 유동인구 차트 뷰
struct QuarterlyFloatingChartView: View {
    var chartData: [ConsumerModel.ChartData]

    var body: some View {
        Chart(chartData) { item in
            BarMark(x: .value("Category", item.label), y: .value("Value", item.value))
        }
        // 추가 차트 설정
    }
}

// 요일별 유동인구 차트 뷰
struct DayFloatingChartView: View {
    var chartData: [ConsumerModel.ChartData]

    var body: some View {
        Chart(chartData) { item in
            BarMark(x: .value("Category", item.label), y: .value("Value", item.value))
        }
        // 추가 차트 설정
    }
}

// 시간대별 유동인구 차트 뷰
struct TimeFloatingChartView: View {
    var chartData: [ConsumerModel.ChartData]

    var body: some View {
        Chart(chartData) { item in
            BarMark(x: .value("Category", item.label), y: .value("Value", item.value))
        }
        // 추가 차트 설정
    }
}

// 연령별 유동인구 차트 뷰
struct AgeFloatingChartView: View {
    var chartData: [ConsumerModel.ChartData]

    var body: some View {
        Chart(chartData) { item in
            BarMark(x: .value("Category", item.label), y: .value("Value", item.value))
        }
        // 추가 차트 설정
    }
}

// 분기별 상주인구 차트 뷰
struct QuarterlyResidentChartView: View {
    var chartData: [ConsumerModel.ChartData]

    var body: some View {
        Chart(chartData) { item in
            BarMark(x: .value("Category", item.label), y: .value("Value", item.value))
        }
        // 추가 차트 설정
    }
}

// 성/연령별 상주인구 차트 뷰
struct GenderAgeResidentChartView: View {
    var chartData: [ConsumerModel.ChartData]

    var body: some View {
        Chart(chartData) { item in
            BarMark(x: .value("Category", item.label), y: .value("Value", item.value))
        }
        // 추가 차트 설정
    }
}

// 분기별 직장인구 차트 뷰
struct QuarterlyWorkingChartView: View {
    var chartData: [ConsumerModel.ChartData]

    var body: some View {
        Chart(chartData) { item in
            BarMark(x: .value("Category", item.label), y: .value("Value", item.value))
        }
        // 추가 차트 설정
    }
}

// 성/연령별 직장인구 차트 뷰
struct GenderAgeWorkingChartView: View {
    var chartData: [ConsumerModel.ChartData]

    var body: some View {
        Chart(chartData) { item in
            BarMark(x: .value("Category", item.label), y: .value("Value", item.value))
        }
        // 추가 차트 설정
    }
}

struct ConsumerChartView: View {
    @State private var isLoading = true
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
                        if isLoading {
                            Text("상권 데이터를 가져오는 중입니다.")
                        }
                        else {
                             Group {
                                // 분기별 유동인구 차트 표시
                                VStack {
                                    if !chartDataSets[0].isEmpty {
                                        Text("분기별 유동인구")
                                        QuarterlyFloatingChartView(chartData: chartDataSets[0])
                                    }
                                }
                                // 요일별 유동인구 차트 표시
                                VStack {
                                    if !chartDataSets[1].isEmpty {
                                        Text("요일별 유동인구")
                                        DayFloatingChartView(chartData: chartDataSets[1])
                                    }
                                }
                                // 시간대별 유동인구 차트 표시
                                VStack {
                                    if !chartDataSets[2].isEmpty {
                                        Text("시간대별 유동인구")
                                        TimeFloatingChartView(chartData: chartDataSets[2])
                                    }
                                }
                                // 연령별 유동인구 차트 표시
                                VStack {
                                    if !chartDataSets[3].isEmpty {
                                        Text("연령별 유동인구")
                                        AgeFloatingChartView(chartData: chartDataSets[3])
                                    }
                                }
                                // 분기별 상주인구 차트 표시
                                VStack {
                                    if !chartDataSets[4].isEmpty {
                                        Text("분기별 상주인구")
                                        QuarterlyResidentChartView(chartData: chartDataSets[4])
                                    }
                                }
                                // 성/연령별 상주인구 차트 표시
                                VStack {
                                    if !chartDataSets[5].isEmpty {
                                        Text("성/연령별 상주인구")
                                        GenderAgeResidentChartView(chartData: chartDataSets[5])
                                    }
                                }
                                // 분기별 직장인구 차트 표시
                                VStack {
                                    if !chartDataSets[6].isEmpty {
                                        Text("분기별 직장인구")
                                        QuarterlyWorkingChartView(chartData: chartDataSets[6])
                                    }
                                }
                                // 성/연령별 직장인구 차트 표시
                                VStack {
                                    if !chartDataSets[7].isEmpty {
                                        Text("성/연령별 직장인구")
                                        GenderAgeWorkingChartView(chartData: chartDataSets[7])
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 300) // end of VStack
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .scrollIndicatorsFlash(onAppear: true)
                    .padding()
                    .onAppear {
                        self.loadAllData()
                     }
                }
            }
        
    } // end of body
    
//    func loadAllData() {
//        print(cdCode + "로 요청 시작")
//        isLoading = true
//        loadFloatingData(endpoint: .분기별유동인구, index: 0)
//        loadFloatingData(endpoint: .요일별유동인구, index: 1)
//        loadFloatingData(endpoint: .시간대별유동인구, index: 2)
//        loadFloatingData(endpoint: .연령별유동인구, index: 3)
//        loadResidentOrWorkingData(endpoint: .분기별상주인구, index: 4)
//        loadResidentOrWorkingData(endpoint: .성연령별상주인구, index: 5)
//        loadResidentOrWorkingData(endpoint: .분기별직장인구, index: 6)
//        loadResidentOrWorkingData(endpoint: .성연령별직장인구, index: 7)
//        print(cdCode + "로 요청 끝!")
//    }
    
    func loadAllData() {
        isLoading = true
        let group = DispatchGroup()

        for (index, endpoint) in Endpoints.allCases.enumerated() {
            group.enter() // 그룹에 작업 추가 시작
            print("\(index)번째 요청 그룹에 들어옴")
            if endpoint.englishEndpoint.contains("floating") {
                loadFloatingData(endpoint: endpoint, index: index, group: group)
            } else {
                loadResidentOrWorkingData(endpoint: endpoint, index: index, group: group)
            }
        }

        group.notify(queue: .main) {
            // 모든 네트워크 요청 완료 후 실행될 코드
            print("데이터 다 가져왔네요!")
            self.isLoading = false
        }
    }

    private func loadResidentOrWorkingData(endpoint: Endpoints, index: Int, group: DispatchGroup) {
        ConsumerNetworkManager.shared.fetch(endpoint: endpoint.englishEndpoint , commercialDistrictCode: cdCode) { result in
            DispatchQueue.main.async {
                switch result {
                // api 통신에 성공한 경우에 JSON을 받아와서 해석
                    case .success (let data):
                        do {
                            print("\(index)번째 일단 데이터 통신은 성공함")
                            // ApiResponse의 형태로 디코딩한 분기별 데이터
                            let residentOrWorkingApiResponse = try JSONDecoder().decode(ConsumerModel.ResidentOrWorkingApiResponse.self, from: data)
                            print("\(index)번째 일단 JSON디코딩까지는 성공함")
                            
                            // 분기별 - quarterlyTrends
                            if endpoint.englishEndpoint.contains("quarterly") {
                                if let seriesData = residentOrWorkingApiResponse.quarterlyTrends?.data.series.first {
                                    print("\(index)번째 일단 seriesData 있음!")
                                    self.chartDataSets[index] = zip(residentOrWorkingApiResponse.quarterlyTrends?.data.categories ?? [] , seriesData.data)
                                        .map { (category, value) in ConsumerModel.ChartData(label: category, value: Double(value)) }
                                    print("\(index) 번째 차트 데이터")
                                    print(self.chartDataSets[index])
                                    print("\(index)번째 요청 그룹에서 나감")
                                    group.leave()
                                }
                            }
                            // 성/연령별 - genderAge
                            else if endpoint.englishEndpoint.contains("age") {
                                if let seriesData = residentOrWorkingApiResponse.genderAge?.data.series.first {
                                    print("\(index)번째 일단 seriesData 있음!")
                                    self.chartDataSets[index] = zip(residentOrWorkingApiResponse.genderAge?.data.categories ?? [] , seriesData.data)
                                        .map { (category, value) in ConsumerModel.ChartData(label: category, value: Double(value)) }
                                    print("\(index) 번째 차트 데이터")
                                    print(self.chartDataSets[index])
                                    print("\(index)번째 요청 그룹에서 나감")
                                    group.leave()
                                }
                            }
                        } catch {
                            print(String(index) + "번째에서 오류!")
                            print("Decoding error: \(error)")
                            print("\(index)번째 요청 그룹에서 나감")
                            group.leave()
                        }
                // api 통신 실패하면
                    case .failure(let error):
                        print("API Networking Error: \(error.localizedDescription)")
                        print("\(index)번째 요청 그룹에서 나감")
                        group.leave()
                }
            }
        }
    } // end of loadData
    
    private func loadFloatingData(endpoint: Endpoints, index: Int, group: DispatchGroup) {
        ConsumerNetworkManager.shared.fetch(endpoint: endpoint.englishEndpoint , commercialDistrictCode: cdCode) { result in
            DispatchQueue.main.async {
                switch result {
                // api 통신에 성공한 경우에 JSON을 받아와서 해석
                    case .success (let data):
                        do {
                            print("\(index)번째 일단 데이터 통신은 성공함")
                            // ApiResponse의 형태로 디코딩한 분기별 데이터
                            let floatingApiResponse = try JSONDecoder().decode(ConsumerModel.FloatingApiResponse.self, from: data)
                            print("\(index)번째 일단 JSON디코딩까지는 성공함")
                            // 분기별 - quarterlyTrends
                            if endpoint.englishEndpoint.contains("quarterly") {
                                if let seriesData = floatingApiResponse.quarterlyTrends?.data.series.first {
                                    print("\(index)번째 일단 seriesData 있음!")
                                    self.chartDataSets[index] = zip(floatingApiResponse.quarterlyTrends?.data.categories ?? [] , seriesData.data)
                                        .map { (category, value) in ConsumerModel.ChartData(label: category, value: Double(value)) }
                                    print("\(index) 번째 차트 데이터")
                                    print(self.chartDataSets[index])
                                    print("\(index)번째 요청 그룹에서 나감")
                                    group.leave()
                                }
                            }
                            // 요일별 - day
                            else if endpoint.englishEndpoint.contains("day") {
                                if let seriesData = floatingApiResponse.day?.data.series.first {
                                    print("\(index)번째 일단 seriesData 있음!")
                                    self.chartDataSets[index] = zip(floatingApiResponse.day?.data.categories ?? [] , seriesData.data)
                                        .map { (category, value) in ConsumerModel.ChartData(label: category, value: Double(value)) }
                                    print("\(index) 번째 차트 데이터")
                                    print(self.chartDataSets[index])
                                    print("\(index)번째 요청 그룹에서 나감")
                                    group.leave()
                                }
                            }
                            // 시간대별 - time
                            else if endpoint.englishEndpoint.contains("time") {
                                if let seriesData = floatingApiResponse.time?.data.series.first {
                                    print("\(index)번째 일단 seriesData 있음!")
                                    self.chartDataSets[index] = zip(floatingApiResponse.time?.data.categories ?? [] , seriesData.data)
                                        .map { (category, value) in ConsumerModel.ChartData(label: category, value: Double(value)) }
                                    print("\(index) 번째 차트 데이터")
                                    print(self.chartDataSets[index])
                                    print("\(index)번째 요청 그룹에서 나감")
                                    group.leave()
                                }
                            }
                            // 연령별 - age
                            else if endpoint.englishEndpoint.contains("age") {
                                if let seriesData = floatingApiResponse.age?.data.series.first {
                                    print("\(index)번째 일단 seriesData 있음!")
                                    self.chartDataSets[index] = zip(floatingApiResponse.age?.data.categories ?? [] , seriesData.data)
                                        .map { (category, value) in ConsumerModel.ChartData(label: category, value: Double(value)) }
                                    print("\(index) 번째 차트 데이터")
                                    print(self.chartDataSets[index])
                                    print("\(index)번째 요청 그룹에서 나감")
                                    group.leave()
                                }
                            }
                        } catch {
                            print("Decoding error: \(error)")
                            print("\(index)번째 요청 그룹에서 나감")
                            group.leave()
                        }
                // api 통신 실패하면
                    case .failure(let error):
                        print("API Networking Error: \(error.localizedDescription)")
                        print("\(index)번째 요청 그룹에서 나감")
                        group.leave()
                }
            }
        }
    } //end of loadFloatingData
} // end of ContentView
