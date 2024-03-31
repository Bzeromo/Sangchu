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
                return ""
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

//
struct IndustryRatioGraphView: View {
    var chartData: [SalesModel.IndustryRatioChartData]
    
    private var maxSalesCategory: String? {
        chartData.max(by: { $0.valueRatio < $1.valueRatio })?.label
    }

    var body: some View {
        VStack {
            Text("업종별 매출 비율")
                .font(.headline)
            Chart(chartData, id: \.label) { dataItem in
                SectorMark(
                    angle: .value("매출 비율", dataItem.valueRatio),
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
//
struct QuarterlyGraphView: View {
    var chartData: [SalesModel.QuarterlyChartData]

    var body: some View {
        VStack {
            Text("분기별 매출")
                .font(.headline)
            Chart(chartData, id: \.id) { dataItem in
                BarMark(
                    x: .value("Quarter", dataItem.label),
                    y: .value("Sales", dataItem.valueWeekDay )
                )
                .foregroundStyle(.red)
                BarMark(
                    x: .value("Quarter", dataItem.label),
                    y: .value("Sales", dataItem.valueWeekend )
                )
                .foregroundStyle(.blue)
            }
            .chartLegend(.visible)
            .frame(height: 300)
        }
    }
}
//
struct DayGraphView: View {
    var chartData: [SalesModel.CountAndAmountChartData]

    var body: some View {
        VStack {
            Text("요일별 매출")
                .font(.headline)
            Chart {
                ForEach(chartData) { dataItem in
                    BarMark(
                        x: .value("요일", dataItem.label),
                        y: .value("매출건수", dataItem.count)
                    )
                    .foregroundStyle(.blue)
                    .annotation(position: .top, alignment: .center) {
                        Text("\(Int(dataItem.count))")
                            .font(.caption)
                    }
                    
                    BarMark(
                        x: .value("요일", dataItem.label),
                        y: .value("매출금액", dataItem.amount)
                    )
                    .foregroundStyle(.red)
                    .annotation(position: .top, alignment: .center) {
                        Text(String(format: "%.0f", dataItem.amount))
                            .font(.caption)
                    }
                }
            }
            .chartLegend(.visible)
            .frame(height: 300)
        }
    }
    
}
//
struct TimeGraphView: View {
    var chartData: [SalesModel.CountAndAmountChartData]

    var body: some View {
        VStack {
            Text("요일별 매출 분석")
                .font(.headline)
            HStack {
                // 매출 건수 차트
                VStack {
                    Text("매출 건수")
                    Chart(chartData) { data in
                        BarMark(
                            x: .value("요일", data.label),
                            y: .value("매출 건수", data.count)
                        )
                        .foregroundStyle(.blue)
                    }
                    .frame(height: 200)
                }
                
                // 매출 금액 차트
                VStack {
                    Text("매출 금액")
                    Chart(chartData) { data in
                        BarMark(
                            x: .value("요일", data.label),
                            y: .value("매출 금액", data.amount / 10000) // 스케일링 적용
                        )
                        .foregroundStyle(.red)
                        .annotation(position: .top, alignment: .center) {
                            Text("\(data.amount, specifier: "%.0f")₩")
                                .font(.caption)
                        }
                    }
                    .frame(height: 200)
                }
            }
        }

    }
}
// AgeGraphView
struct AgeGraphView: View {
    var chartData: [SalesModel.CountAndAmountChartData]
    @State private var showingCount = true // 사용자가 '매출 건수'를 보고 싶은지 여부

    var body: some View {
        LazyVStack {
            Text("연령대별 매출")
                .font(.headline)
            
            // '매출 건수'와 '매출 금액' 사이를 전환할 수 있는 버튼들
            HStack {
                Button("매출 건수") {
                    withAnimation {
                        showingCount = true
                    }
                }
                .buttonStyle(.bordered)
                
                Button("매출 금액") {
                    withAnimation {
                        showingCount = false
                    }
                }
                .buttonStyle(.bordered)
            }

            // 차트 표시
            Chart(chartData) { data in
                if showingCount {
                    BarMark(
                        x: .value("연령대", data.label),
                        y: .value("매출건수", data.count)
                    )
                    .foregroundStyle(.blue)
                } else {
                    BarMark(
                        x: .value("연령대", data.label),
                        y: .value("매출금액", data.amount)
                    )
                    .foregroundStyle(.red)
                }
            }
            .chartLegend(.visible)
            .frame(height: 300)
        }
    }
}


struct SalesChartView: View {
    @State private var isLoading = true
    @State private var textDataSets : SalesModel.RecentSalesData?
    @State private var industryRatioChartDataSets : [SalesModel.IndustryRatioChartData] = []
    @State private var quarterlyChartDataSets : [SalesModel.QuarterlyChartData] = []
    @State private var dayChartDataSets: [SalesModel.CountAndAmountChartData] = []
    @State private var timeChartDataSets: [SalesModel.CountAndAmountChartData] = []
    @State private var ageChartDataSets: [SalesModel.CountAndAmountChartData] = []
    @State var cdCode: String = ""
    let recentQuarter = "2023년 3분기"
    
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 15) {
                if isLoading {
                    Text("데이터 로딩 중")
                        .padding(.top)
                } else {
                    // 직전분기 매출 관련 VStack
                    VStack (alignment: .leading, spacing: 10) {
                        Text("직전분기월평균및주중주말매출금액")
                            .font(.title)
                            .padding(.top)
                        HStack {
                            Group {
                                Text(recentQuarter + " : ")
                                if let monthlySales = textDataSets?.monthlySales {
                                    Text("\(monthlySales)원")
                                } else {
                                    Text("데이터 없음")
                                }
                            }
                        }
                        HStack {
                            Group {
                                Text("주중 매출")
                                if let weekDaySales = textDataSets?.weekDaySales {
                                    Text("\(weekDaySales)원")
                                } else {
                                    Text("데이터 없음")
                                }
                            }
                        }
                        HStack {
                            Group {
                                Text("주말 매출")
                                if let weekendSales = textDataSets?.weekendSales {
                                    Text("\(weekendSales)원")
                                } else {
                                    Text("데이터 없음")
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    // 각종 차트 데이터들
                    TabView {
                        if isLoading {
                            Text("상권 데이터를 가져오는 중입니다.")
                        }
                        else {
                            Group {
                                // 분기별 유동인구 차트 표시
                                VStack {
                                    if !industryRatioChartDataSets.isEmpty {
                                        IndustryRatioGraphView(chartData: industryRatioChartDataSets)
                                    }
                                }
                                VStack {
                                    if !quarterlyChartDataSets.isEmpty {
                                        QuarterlyGraphView(chartData: quarterlyChartDataSets)
                                    }
                                }
                                VStack {
                                    if !dayChartDataSets.isEmpty {
                                        DayGraphView(chartData: dayChartDataSets)
                                    }
                                }
                                VStack {
                                    if !timeChartDataSets.isEmpty {
                                        TimeGraphView(chartData: timeChartDataSets)
                                    }
                                }
                                VStack {
                                    if !ageChartDataSets.isEmpty {
                                        AgeGraphView(chartData: ageChartDataSets)
                                    }
                                }
                            }
                        }
                    } // end of TabView
                    .frame(height: 300) // end of VStack
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .scrollIndicatorsFlash(onAppear: true)
                    .padding(.top, 20)
                } // end of else
            } // end of outer VStack
            .onAppear() {
                loadSalesData()
            }
        } // end of ScrollView
    } // end of body view
    
    func loadSalesData() {
        isLoading = true
        let group = DispatchGroup()
        
        for (index, endpoint) in SalesEndpoints.allCases.enumerated() {
            group.enter() // 그룹에 작업 추가 시작
            print("\(index)번째 요청 그룹에 들어옴")

            let whereToGo = endpoint.id
            
            if whereToGo.contains("recent") {
                loadRecentData(endpoint: endpoint, index: index, group: group)
            }
            else if whereToGo.contains("industry") {
                loadindustryRatioData(endpoint: endpoint, index: index, group: group)
            }
            else if whereToGo.contains("quarterly") {
                 loadQuarterlyData(endpoint: endpoint, index: index, group: group)
            }
            else if whereToGo.contains("day") {
                 loadDayData(endpoint: endpoint, index: index, group: group)
            }
            else if whereToGo.contains("time") {
                 loadTimeData(endpoint: endpoint, index: index, group: group)
            }
            else if whereToGo.contains("age") {
                 loadAgeData(endpoint: endpoint, index: index, group: group)
            }
        }
        
        group.notify(queue: .main) {
            // 모든 네트워크 요청 완료 후 실행될 코드
            print("데이터 다 가져왔네요!")
            self.isLoading = false
        }
        
    } // end of loadSalesData
    
    //
    func loadRecentData(endpoint: SalesEndpoints, index: Int, group: DispatchGroup) {
        SalesNetworkManager.shared.fetch(endpoint: endpoint.englishEndpoint, commercialDistrictCode: cdCode) { result in
            DispatchQueue.main.async {
                defer { group.leave() }
                
                switch result {
                case .success(let data):
                    do {
                        let salesRecentApiResponse = try JSONDecoder().decode(SalesModel.RecentSalesData.self, from: data)
                        self.textDataSets = salesRecentApiResponse
                        print("데이터 처리 성공")
                    } catch {
                        print("디코딩 오류: \(error)")
                    }
                case .failure(let error):
                    print("네트워크 오류: \(error.localizedDescription)")
                }
            }
        }
    }
    
    //
    func loadindustryRatioData(endpoint: SalesEndpoints, index: Int, group: DispatchGroup) {
        SalesNetworkManager.shared.fetch(endpoint: endpoint.englishEndpoint, commercialDistrictCode: cdCode) { result in
            DispatchQueue.main.async {
                defer { group.leave() }
                
                switch result {
                case .success(let data):
                    do {
                        // `RatioIndustry` 모델로 데이터 디코딩
                        let industryRatioApiResponse = try JSONDecoder().decode(SalesModel.RatioIndustry.self, from: data)
                        // 디코딩된 데이터를 `ChartData` 모델로 변환
                        let chartData = zip(industryRatioApiResponse.graphJson.data.categories, industryRatioApiResponse.graphJson.data.series).map { SalesModel.IndustryRatioChartData(label: $0, valueRatio: $1) }
                        // 변환된 `ChartData` 배열을 `chartDataSets`에 저장
                        DispatchQueue.main.async {
                            self.industryRatioChartDataSets = chartData
                        }
                        print("업종별 매출 비율 데이터 처리 성공")
                    } catch {
                        print("업종별 디코딩 오류: \(error)")
                    }
                case .failure(let error):
                    print("업종별 네트워크 오류: \(error.localizedDescription)")
                }
            }
        }
    }
    
    //
    func loadQuarterlyData(endpoint: SalesEndpoints, index: Int, group: DispatchGroup) {
        SalesNetworkManager.shared.fetch(endpoint: endpoint.englishEndpoint, commercialDistrictCode: cdCode) { result in
            DispatchQueue.main.async {
                defer { group.leave() }
                
                switch result {
                case .success(let data):
                    do {
                        let quarterlyApiResponse = try JSONDecoder().decode(SalesModel.QuarterlyApiResponse.self, from: data)
                        // QuarterlyChartData를 사용하여 데이터 처리
                        let chartData = quarterlyApiResponse.quarterlyGraph.data.series.map { series -> SalesModel.QuarterlyChartData in
                            // 주중 및 주말 매출 값을 Double로 변환, 실패 시 0.0
                            let weekDaySalesValue = Double(series.WeekDaySales) ?? 0.0
                            let weekendSalesValue = Double(series.WeekendSales) ?? 0.0
                            
                            // QuarterlyChartData 객체 생성
                            return SalesModel.QuarterlyChartData(label: series.YearQuarter, valueWeekDay: weekDaySalesValue, valueWeekend: weekendSalesValue)
                        }
                        // chartDataSets에 할당
                        self.quarterlyChartDataSets = chartData
                        print("분기별 데이터 처리 성공")
                    } catch {
                        print("분기별 디코딩 오류: \(error)")
                    }
                case .failure(let error):
                    print("분기별 네트워크 오류: \(error.localizedDescription)")
                }
            }
        }
    }

    //
    func loadDayData(endpoint: SalesEndpoints, index: Int, group: DispatchGroup) {
        SalesNetworkManager.shared.fetch(endpoint: endpoint.englishEndpoint, commercialDistrictCode: cdCode) { result in
            DispatchQueue.main.async {
                defer { group.leave() }
                
                switch result {
                case .success(let data):
                    do {
                        let dayApiResponse = try JSONDecoder().decode(SalesModel.DayApiResponse.self, from: data)
                        var chartDataArray = [SalesModel.CountAndAmountChartData]()
                        for (i, category) in dayApiResponse.graphJson.data.categories.enumerated() {
                            let salesCount = dayApiResponse.graphJson.data.series.daySalesCount[i]
                            print(salesCount)
                            let salesAmount = dayApiResponse.graphJson.data.series.daySales[i]
                            print(salesAmount)
                            let chartData = SalesModel.CountAndAmountChartData(label: category, count: Double(salesCount), amount: Double(salesAmount))
                            chartDataArray.append(chartData) // 배열에 추가합니다.
                        }
                        print("여까지는 됨!")
                        self.dayChartDataSets = chartDataArray
                        print("요일별 데이터 처리 성공")
                    } catch {
                        print("요일별 디코딩 오류: \(error)")
                    }
                case .failure(let error):
                    print("요일별 네트워크 오류: \(error.localizedDescription)")
                }
            }
        }
    }

    //
    func loadTimeData(endpoint: SalesEndpoints, index: Int, group: DispatchGroup) {
        SalesNetworkManager.shared.fetch(endpoint: endpoint.englishEndpoint, commercialDistrictCode: cdCode) { result in
            DispatchQueue.main.async {
                defer { group.leave() }

                switch result {
                case .success(let data):
                    do {
                        let timeApiResponse = try JSONDecoder().decode(SalesModel.TimeApiResponse.self, from: data)
                        var chartDataArray: [SalesModel.CountAndAmountChartData] = []
                        for (i, category) in timeApiResponse.graphJson.data.categories.enumerated() {
                            let salesCount = Double(timeApiResponse.graphJson.data.series.timeSalesCount[i])
                            print(salesCount)
                            let salesAmount = Double(timeApiResponse.graphJson.data.series.timeSales[i])
                            print(salesAmount)
                            let chartData = SalesModel.CountAndAmountChartData(label: category, count: salesCount, amount: salesAmount)
                            chartDataArray.append(chartData)
                        }
                        print("여까지는 됨!")
                        self.timeChartDataSets = chartDataArray
                        print("시간대별 데이터 처리 성공")
                    } catch {
                        print("시간대별 디코딩 오류: \(error)")
                    }
                case .failure(let error):
                    print("시간대별 네트워크 오류: \(error.localizedDescription)")
                }
            }
        }
    }

    //
    func loadAgeData(endpoint: SalesEndpoints, index: Int, group: DispatchGroup) {
        SalesNetworkManager.shared.fetch(endpoint: endpoint.englishEndpoint, commercialDistrictCode: cdCode) { result in
            DispatchQueue.main.async {
                defer { group.leave() }

                switch result {
                case .success(let data):
                    do {
                        let ageApiResponse = try JSONDecoder().decode(SalesModel.AgeApiResponse.self, from: data)
                        var chartDataArray: [SalesModel.CountAndAmountChartData] = []
                        for (i, category) in ageApiResponse.graphJson.data.categories.enumerated() {
                            let salesCount = Double(ageApiResponse.graphJson.data.series.ageSalesCount[i])
                            print(salesCount)
                            let salesAmount = Double(ageApiResponse.graphJson.data.series.ageSales[i])
                            print(salesAmount)
                            let chartData = SalesModel.CountAndAmountChartData(label: category, count: salesCount, amount: salesAmount)
                            chartDataArray.append(chartData)
                        }
                        print("여까지는 됨!")
                        self.ageChartDataSets = chartDataArray
                        print("연령대별 데이터 처리 성공")
                    } catch {
                        print("연령대별 디코딩 오류: \(error)")
                    }
                case .failure(let error):
                    print("연령대별 네트워크 오류: \(error.localizedDescription)")
                }
            }
        }
    }

}
