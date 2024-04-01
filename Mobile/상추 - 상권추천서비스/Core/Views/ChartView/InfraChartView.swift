//
//  InfraChartView.swift
//  상추 - 상권추천서비스
//
//  Created by 안상준 on 3/25/24.
//

import SwiftUI
import Charts

enum InfraEndpoints: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    
    case 주변점포 = "Around"
    case 주변아파트가격별세대수 = "AptPrice"
    case 주변아파트면적별세대수 = "AptArea"
    var englishEndpoint: String {
        switch self {
        case .주변점포:
            return "/infra/graph/store/count"
        case .주변아파트가격별세대수:
            return "/infra/graph/apt/price"
        case .주변아파트면적별세대수:
            return "/infra/graph/apt/area"
        }
    } // end of englishEndpoint
    var displayName: String {
        switch self {
            case .주변점포:
            return "업종별 주변 점포수"
        case .주변아파트가격별세대수:
            return "주변아파트가격별세대수"
        case .주변아파트면적별세대수:
            return "주변아파트면적별세대수"
        }
    } // end of displayName
}


struct InfraChartView: View {
    @State private var chartDataSets: [[InfraModel.ChartData]] = Array(repeating: [], count: InfraEndpoints.allCases.count)
    // 차트 데이터들이 들어가 있는 배열 상태값
    @State var cdCode: String
    @State private var othersValue: Int = 0
    @State var InfraAptSet : InfraModel.InfraApt? = nil
    @State var InfraFacility : InfraModel.InfraFacility? = nil
    @State var InfraIndicatorRdi : InfraModel.InfraIndicatorRdi? = nil
    @State var InfraIndicator : InfraModel.InfraIndicator? = nil
    
    
    var body: some View {
            VStack (alignment: .leading) {
                if chartDataSets.isEmpty {
                    Text("해당 데이터가 없습니다.")
                        .padding()
                } else {
                    TabView {
                        ForEach(0..<chartDataSets.count, id: \.self) { index in
                            if (chartDataSets[index].isEmpty) {
                                Text("준비중인 데이터입니다.")
                                    .font(.largeTitle)
                            }
                            else {
                                VStack {
                                    HStack {
                                        // 데이터 분류용
                                        Text(InfraEndpoints.allCases[index].displayName)
                                            .font(.title2).bold().foregroundColor(Color.sangchu)
                                        Spacer()
                                        // 단위 표시용
                                        if index >= 1 {
                                            Text("*\\(단위: 세대\\)")
                                                .font(.caption)
                                                .padding([.leading, .trailing])
                                        }
                                        else {
                                            Text("요식업 외 : \(othersValue)")
                                        }
                                    }
                                    // Chart view
                                    Chart(chartDataSets[index]) { data in
                                        BarMark(
                                            x: .value("Quarter", data.label),
                                            y: .value("Population", data.value)
                                        )
                                        .cornerRadius(5)
                                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                                        .annotation(position: .top, alignment: .center) {
                                            Text("\(data.value, specifier: "%.0f")") // 데이터 값 라벨, 소수점 없이 표현!
                                                .font(.caption2)
                                                .foregroundColor(Color.black)
                                                .lineLimit(nil) // 라벨에 대한 줄바꿈 제한을 없애 줄바꿈을 허용
                                                .fixedSize(horizontal: false, vertical: true)
                                        }
                                    }
                                    .padding()
                                    // x축 관련 설정
                                    .chartXAxis {
                                        AxisMarks(values: .automatic) { value in
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
                                                    .padding(.top, 8)
                                            }
                                        }
                                    }
                                    .chartYAxis {
                                        AxisMarks(preset: .aligned, position: .leading)
                                    }
                                    .padding(.bottom, 40)
                                }
                            } // end of else
                        } // end of ForEach
                        
                    }
                    .frame(height: 300) // end of VStack
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .scrollIndicatorsFlash(onAppear: true)
                    .padding()
                    .onAppear {
                        loadAllData()
                    }
                    Section(header: Text("상권 변화 지수").font(.title))  {
                        HStack {
                            Text("정체")
                                .fontWeight(InfraIndicator?.indicator == "정체" ? .bold : .regular)
                                .foregroundColor(InfraIndicator?.indicator == "정체" ? .green : .white)
                            Text("축소")
                                .fontWeight(InfraIndicator?.indicator == "축소" ? .bold : .regular)
                                .foregroundColor(InfraIndicator?.indicator == "축소" ? .green : .white)
                            Text("확장")
                                .fontWeight(InfraIndicator?.indicator == "확장" ? .bold : .regular)
                                .foregroundColor(InfraIndicator?.indicator == "확장" ? .green : .white)
                            Text("다이나믹")
                                .fontWeight(InfraIndicator?.indicator == "다이나믹" ? .bold : .regular)
                                .foregroundColor(InfraIndicator?.indicator == "다이나믹" ? .green : .white)
                        }
                    }
                
                Section(header: Text("업종 다양성 지수").font(.title))  {
                    HStack {
                            Text("하")
                                .fontWeight(InfraIndicatorRdi?.rdi == "하" ? .bold : .regular)
                                .foregroundColor(InfraIndicatorRdi?.rdi == "하" ? .green : .white)
                            Text("중")
                                .fontWeight(InfraIndicatorRdi?.rdi == "중" ? .bold : .regular)
                                .foregroundColor(InfraIndicatorRdi?.rdi == "중" ? .green : .white)
                            Text("상")
                                .fontWeight(InfraIndicatorRdi?.rdi == "상" ? .bold : .regular)
                                .foregroundColor(InfraIndicatorRdi?.rdi == "상" ? .green : .white)
                            Text("최상")
                                .fontWeight(InfraIndicatorRdi?.rdi == "최상" ? .bold : .regular)
                                .foregroundColor(InfraIndicatorRdi?.rdi == "최상" ? .green : .white)
                        }
  }
                    
                    Section(header: Text("대중교통").font(.title)) {
                        if let bus = InfraFacility?.bus {
                            Text("버스 \(bus)")
                        } else {
                            Text("버스 정보 없음")
                        }
                        if let trainSubway = InfraFacility?.trainSubway {
                            Text("지하철 \(trainSubway)")
                        } else {
                            Text("지하철 정보 없음")
                        }
  }
                    
                    Section(header: Text("주변 시설물").font(.title))  {
                        if let facilities = InfraFacility?.facilities {
                            Text("집객시설 \(facilities)")
                        } else {
                            Text("집객시설 정보 없음")
                        }
                        if let culTouristFacilities = InfraFacility?.culTouristFacilities {
                            Text("문화관광 시설 \(culTouristFacilities)")
                        } else {
                            Text("문화관광 정보 없음")
                        }
                        if let educationalFacilities = InfraFacility?.educationalFacilities {
                            Text("교육시설 \(educationalFacilities)")
                        } else {
                            Text("교육시설 정보 없음")
                        }
                        }
                    
                    Section(header: Text("아파트 정보").font(.title))  {
                        if let apartmentComplexes = InfraAptSet?.apartmentComplexes {
                            Text("아파트 가격 \(apartmentComplexes)")
                        } else {
                            Text("아파트 가격 정보 없음")
                        }
                        
                        if let aptAvgArea = InfraAptSet?.aptAvgArea {
                               Text("아파트 가격 \(aptAvgArea)")
                           } else {
                               Text("아파트 가격 정보 없음")
                           }
                        
                        if let aptAvgPrice = InfraAptSet?.aptAvgPrice {
                               Text("아파트 가격 \(aptAvgPrice)")
                           } else {
                               Text("아파트 가격 정보 없음")
                           }
                        }
                }
            }.frame(height: .infinity).onAppear{
                InfraIndicatorRdiDecode()
                InfraFacilityDecode()
                infraAptDecode()
                InfraIndicatorDecode()
            }
        
    } // end of body
    
    func loadAllData() {
        for (index, endpoint) in InfraEndpoints.allCases.enumerated() {
            InfraDecode(endpoint : endpoint, index: index)
        }
    }
    
    private func InfraIndicatorDecode() {
        InfraNetworkManager.shared.fetch(endpoint: "/infra/indicator", commercialDistrictCode: cdCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let InfraIndicator = try JSONDecoder().decode(InfraModel.InfraIndicator.self, from: data)
                        self.InfraIndicator = InfraIndicator
                    } catch {
                        print("Decoding error: \(error)")
                    }
                case .failure(let error):
                    print("Fetch error: \(error)")
                }
            }
        }
    }
    
    private func InfraIndicatorRdiDecode() {
        InfraNetworkManager.shared.fetch(endpoint: "/infra/indicator/rdi", commercialDistrictCode: cdCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let InfraIndicatorRdi = try JSONDecoder().decode(InfraModel.InfraIndicatorRdi.self, from: data)
                        self.InfraIndicatorRdi = InfraIndicatorRdi
                    } catch {
                        print("Decoding error: \(error)")
                    }
                case .failure(let error):
                    print("Fetch error: \(error)")
                }
            }
        }
    }
    
    
    private func infraAptDecode() {
        InfraNetworkManager.shared.fetch(endpoint: "/infra/apt", commercialDistrictCode: cdCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let infraIndicator = try JSONDecoder().decode(InfraModel.InfraApt.self, from: data)
                        self.InfraAptSet = infraIndicator
                    } catch {
                        print("Decoding error: \(error)")
                    }
                case .failure(let error):
                    print("Fetch error: \(error)")
                }
            }
        }
    }
    
    private func InfraFacilityDecode() {
        InfraNetworkManager.shared.fetch(endpoint: "/infra/facility", commercialDistrictCode: cdCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let infraFacility = try JSONDecoder().decode(InfraModel.InfraFacility.self, from: data)
                        self.InfraFacility = infraFacility
                    } catch {
                        print("Decoding error: \(error)")
                    }
                case .failure(let error):
                    print("Fetch error: \(error)")
                }
            }
        }
    }

    // 그 외 차트로 보여줄 때
//    private func InfraDecode(endpoint: InfraEndpoints, index: Int) {
//        InfraNetworkManager.shared.fetch(endpoint: endpoint.englishEndpoint , commercialDistrictCode: cdCode) { result in
//            DispatchQueue.main.async {
//                switch result {
//                    // api 통신에 성공한 경우에 JSON을 받아와서 해석
//                case .success (let data):
//                    do {
//                        if endpoint.englishEndpoint.contains("count") {
//                            let decodedResponse = try JSONDecoder().decode(InfraModel.InfraStoreCountApiResponse.self, from: data)
//                            let storeGraph = decodedResponse.storeGraph
//                            let categories = storeGraph.data.categories
//                            let series = storeGraph.data.series.first?.storeCount ?? []
//
//                            // 앞에서부터 10개 항목(요식업)
//                            let topCategories = Array(categories.prefix(10))
//                            let topValues = Array(series.prefix(10))
//
//                            let othersValue = series.dropFirst(10).reduce(0, +)
//
//                            // "그 외" 항목 추가
//                            var modifiedDataSet = zip(topCategories, topValues).map { InfraModel.ChartData(label: $0, value: Double($1)) }
//                            if series.count > 10 { // "그 외" 항목이 필요한 경우에만 추가
//                                modifiedDataSet.append(InfraModel.ChartData(label: "그 외", value: Double(othersValue)))
//                            }
//
//                            self.chartDataSets[index] = modifiedDataSet
//                        }
//
//                        
//                        else if endpoint.englishEndpoint.contains("price") {
//                            // ApiResponse의 형태로 디코딩한 데이터
//                            let InfraGraphAptPriceResponse = try JSONDecoder().decode(InfraModel.InfraGraphAptPrice.self, from: data)
//                            
//                            if let seriesData = InfraGraphAptPriceResponse.priceGraph?.data.series.first {
//                                self.chartDataSets[index] = zip(InfraGraphAptPriceResponse.priceGraph?.data.categories ?? [] , seriesData.data ).map { (category, value) in InfraModel.ChartData(label: category, value: Double(value)) }
//                            }
//                        }
//                        
//                        else if endpoint.englishEndpoint.contains("area") {
//                            // ApiResponse의 형태로 디코딩한 데이터
//                            let InfraGraphAptAreaResponse = try JSONDecoder().decode(InfraModel.InfraGraphAptArea.self, from: data)
//                            
//                            if let seriesDataa = InfraGraphAptAreaResponse.areaGraph?.data.series.first {
//                                self.chartDataSets[index] = zip(InfraGraphAptAreaResponse.areaGraph?.data.categories ?? [] , seriesDataa.data ).map { (category, value) in InfraModel.ChartData(label: category, value: Double(value)) }
//                                
//                                if self.chartDataSets[index].isEmpty {
//                                    print("Decoding Value Error!")
//                                }
//                            }
//                        }
//                    } catch {
//                        print("Decoding error: \(error)")
//                    }
//                    // api 통신 실패하면
//                case .failure(let error):
//                    print("API Networking Error: \(error.localizedDescription)")
//                }
//            }
//        }
//    } // end of loadData
    // 그 외 텍스트로 보여줄 때
    private func InfraDecode(endpoint: InfraEndpoints, index: Int) {
        InfraNetworkManager.shared.fetch(endpoint: endpoint.englishEndpoint , commercialDistrictCode: cdCode) { result in
            DispatchQueue.main.async {
                switch result {
                    // api 통신에 성공한 경우에 JSON을 받아와서 해석
                case .success (let data):
                    do {
                        if endpoint.englishEndpoint.contains("count") {
                            let decodedResponse = try JSONDecoder().decode(InfraModel.InfraStoreCountApiResponse.self, from: data)
                            let storeGraph = decodedResponse.storeGraph
                            let categories = storeGraph.data.categories
                            let series = storeGraph.data.series.first?.storeCount ?? []

                            // 앞에서부터 10개 항목을 추출합니다.
                            let topCategories = Array(categories.prefix(10))
                            let topValues = Array(series.prefix(10))

                            // "그 외" 항목의 값은 나머지 항목들의 합입니다.
                            self.othersValue = series.dropFirst(10).reduce(0, +)
                            
                            // "그 외" 항목을 추가합니다.
                            var modifiedDataSet = zip(topCategories, topValues).map { InfraModel.ChartData(label: $0, value: Double($1)) }
//                            if series.count > 10 { // "그 외" 항목이 필요한 경우에만 추가
//                                modifiedDataSet.append(InfraModel.ChartData(label: "그 외", value: Double(othersValue)))
//                            }

                            self.chartDataSets[index] = modifiedDataSet
                        }

                        
                        else if endpoint.englishEndpoint.contains("price") {
                            // ApiResponse의 형태로 디코딩한 데이터
                            let InfraGraphAptPriceResponse = try JSONDecoder().decode(InfraModel.InfraGraphAptPrice.self, from: data)
                            
                            if let seriesData = InfraGraphAptPriceResponse.priceGraph?.data.series.first {
                                self.chartDataSets[index] = zip(InfraGraphAptPriceResponse.priceGraph?.data.categories ?? [] , seriesData.data ).map { (category, value) in InfraModel.ChartData(label: category, value: Double(value)) }
                            }
                        }
                        
                        else if endpoint.englishEndpoint.contains("area") {
                            // ApiResponse의 형태로 디코딩한 데이터
                            let InfraGraphAptAreaResponse = try JSONDecoder().decode(InfraModel.InfraGraphAptArea.self, from: data)
                            
                            if let seriesDataa = InfraGraphAptAreaResponse.areaGraph?.data.series.first {
                                self.chartDataSets[index] = zip(InfraGraphAptAreaResponse.areaGraph?.data.categories ?? [] , seriesDataa.data ).map { (category, value) in InfraModel.ChartData(label: category, value: Double(value)) }
                                
                                if self.chartDataSets[index].isEmpty {
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
    } // end of loadData
}
