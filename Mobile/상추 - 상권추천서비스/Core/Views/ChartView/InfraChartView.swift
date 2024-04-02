//
//  InfraChartView.swift
//  상추 - 상권추천서비스
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
            return "주변 아파트 가격별 세대수"
        case .주변아파트면적별세대수:
            return "주변 아파트 면적별 세대수"
        }
    } // end of displayName
}


struct InfraChartView: View {
    @State private var countChartDataSets : [InfraModel.CountChartData] = []
    @State private var chartDataSets: [[InfraModel.ChartData]] = Array(repeating: [], count: InfraEndpoints.allCases.count)
    // 차트 데이터들이 들어가 있는 배열 상태값
    @State var cdCode: String
    @State private var othersValue: Int = 0
    @State var InfraAptSet : InfraModel.InfraApt? = nil
    @State var InfraFacility : InfraModel.InfraFacility? = nil
    @State var InfraIndicatorRdi : InfraModel.InfraIndicatorRdi? = nil
    @State var InfraIndicator : InfraModel.InfraIndicator? = nil
    
    let MainColors: [Color] = [Color(hex: "50B792"),Color(hex: "3B7777")]
    
    var body: some View {
            VStack (alignment: .leading) {
                if chartDataSets.isEmpty {
                    Text("해당 데이터가 없습니다.")
                        .padding()
                } else {
                    TabView {
                        ForEach(0..<chartDataSets.count, id: \.self) { index in
                            if (index == 0 && countChartDataSets.isEmpty) ||  (index >= 1 && chartDataSets[index].isEmpty) {
                                Text("준비중인 데이터입니다.")
                                    .font(.largeTitle)
                            }
                            else {
                                VStack {
                                    HStack {
                                        // 데이터 분류용
                                        Text(InfraEndpoints.allCases[index].displayName)
                                            .font(.title2).bold()
                                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
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
                                    if index >= 1 {
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
                                                        .padding(.top, 11)
                                                }
                                            }
                                        }
                                        .chartYAxis {
                                            AxisMarks(preset: .aligned, position: .leading)
                                        }
                                    }
                                    else {
                                        Chart(countChartDataSets) { data in
                                            // 점포 수
                                            BarMark(
                                                x: .value("Category", data.label),
                                                y: .value("Store Count", data.storeCount)
                                            )
                                            .cornerRadius(5)
                                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))

                                            // 프랜차이즈 수
                                            BarMark(
                                                x: .value("Category", data.label),
                                                y: .value("Franchise Store Count", data.franchiseStoreCount)
                                            )
                                            .cornerRadius(5)
                                            .foregroundStyle(.yellow)
                                            // annotation으로는 그 둘의 합
                                            .annotation(position: .top, alignment: .center) {
                                                Text("\(data.storeCount + data.franchiseStoreCount, specifier: "%.0f")")
                                                    .font(.caption2)
                                                    .foregroundColor(Color.black)
                                            }
                                        }
                                        .padding().padding(.bottom, 40)
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
                                                        .padding(.top, 11)
                                                }
                                            }
                                        }
                                        .chartYAxis {
                                            AxisMarks(preset: .aligned, position: .leading)
                                        }
                                        HStack {
                                                HStack {
                                                    Circle()
                                                        .fill(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                                                        .frame(width: 10, height: 5)
                                                    Text("점포 수")
                                                        .font(.caption)
                                                }
                                                HStack {
                                                    Circle()
                                                        .fill(Color.yellow)
                                                        .frame(width: 10, height: 5)
                                                    Text("프랜차이즈 수")
                                                        .font(.caption)
                                                }
                                            }
                                    }
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
                    VStack(spacing:10){
                        HStack{
                            Text("상권 변화 지수").font(.title2).fontWeight(.semibold)
                            Spacer()
                        }.frame(width: UIScreen.main.bounds.width * 0.9)
                        
                        VStack {
                            if let subtitle = InfraIndicator?.indicator {
                                HStack{
                                    Spacer()
                                    Text(subtitle).font(.title).fontWeight(.semibold).foregroundStyle(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                                    Spacer()
                                }.padding(15)
                                
                                
                            }
                            VStack(alignment:.leading){
                                Text("다이나믹 : ").font(.system(size: 12)).foregroundStyle(Color(hex: "c6c6c6")).fontWeight(.semibold) + Text("같은 업종으로 도시재생 및 신규 개발 상권으로").font(.system(size: 12)).foregroundStyle(Color(hex: "c6c6c6"))
                                Text("창업 진출입시 세심한 주의가 필요한 상권").font(.system(size: 11)).foregroundStyle(Color(hex: "c6c6c6"))
                                Text("상권 확장 : ").font(.system(size: 12)).foregroundStyle(Color(hex: "c6c6c6")).fontWeight(.semibold)  + Text("같은 업종으로 신규 업체가 경쟁력을 가지는 상권").font(.system(size: 12)).foregroundStyle(Color(hex: "c6c6c6"))
                                Text("상권 축소 : ").font(.system(size: 12)).foregroundStyle(Color(hex: "c6c6c6")).fontWeight(.semibold)  + Text("같은 업종으로 기존 업체가 경쟁력을 가지는 상권").font(.system(size: 12)).foregroundStyle(Color(hex: "c6c6c6"))
                                Text("정체 : ").font(.system(size: 12)).foregroundStyle(Color(hex: "c6c6c6")).fontWeight(.semibold)  + Text("같은 업종으로 창업 진출입시 세심한 주의가 필요한 상권").font(.system(size: 12)).foregroundStyle(Color(hex: "c6c6c6"))
                            }.padding(.leading,30).padding(.trailing,30).padding(.bottom,20)
                           
                        }.background(Color(hex: "f4f5f7")).frame(width: UIScreen.main.bounds.width * 0.9,height: UIScreen.main.bounds.width * 0.4).padding(.leading,20).padding(.bottom,20).padding(.trailing,20)
                    }
                       
                    
                    VStack(spacing:10){
                        HStack{
                            Text("업종 다양성 지수").font(.title2).fontWeight(.semibold)
                            Spacer()
                        }.frame(width: UIScreen.main.bounds.width * 0.9)
                        
                        VStack {
                            if let subtitle = InfraIndicatorRdi?.rdi{
                                HStack{
                                    Spacer()
                                    Text(subtitle).font(.title).fontWeight(.semibold).foregroundStyle(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                                    Spacer()
                                }.padding(20)
                                
                            }
                           
                        }.background(Color(hex: "f4f5f7")).frame(width: UIScreen.main.bounds.width * 0.9,height: UIScreen.main.bounds.width * 0.2).padding(.leading,20).padding(.bottom,20).padding(.trailing,20)
                    }
                    
                    VStack(spacing:10){
                        HStack{
                            Text("대중 교통").font(.title2).fontWeight(.semibold)
                            Spacer()
                        }.frame(width: UIScreen.main.bounds.width * 0.9)
                        
                        HStack {
                            HStack{
                                Spacer()
                                VStack(alignment:.center){
                                    Image(uiImage: UIImage(named: "subway.png")!)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.12)
                                    Text("지하철").font(.system(size: 16)).foregroundStyle(Color(hex: "c6c6c6"))
                                }
                                if let trainSubway = InfraFacility?.trainSubway {
                                    HStack{
                                        Text("\(trainSubway)").font(.title).fontWeight(.semibold).foregroundStyle(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                                    }.padding(20)
                                    
                                }
                                Spacer()
                                
                            }
                            Divider().frame(height:60).background(Color(hex: "b5b5b5"))
                            
                            HStack{
                                Spacer()
                                VStack(alignment:.center){
                                    Image(uiImage: UIImage(named: "bus.png")!)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.12)
                                    Text("버스").font(.system(size: 16)).foregroundStyle(Color(hex: "c6c6c6"))
                                }
                                if let bus = InfraFacility?.bus{
                                    HStack{
                                        Text("\(bus)").font(.title).fontWeight(.semibold).foregroundStyle(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                                    }.padding(20)
                                    
                                }
                                Spacer()
                                
                                
                            }
                        }.frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.3).background(Color(hex: "f4f5f7")).padding(.leading,20).padding(.bottom,20).padding(.trailing,20)
                    }
                   
                    VStack(spacing:10){
                        HStack{
                            Text("주변 시설물").font(.title2).fontWeight(.semibold)
                            Spacer()
                        }.frame(width: UIScreen.main.bounds.width * 0.9)
                        
                        HStack {
                            HStack{
                                Spacer()
                                    VStack(alignment:.center){
                                        Image(uiImage: UIImage(named: "shopping.png")!)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1)
                                        Text("집객").font(.system(size: 13)).foregroundStyle(Color(hex: "c6c6c6"))
                                    }
                                    if let facilities = InfraFacility?.facilities{
                                        HStack{
                                            Text("\(facilities)").font(.title3).fontWeight(.semibold).foregroundStyle(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                                        }
                                        
                                    }
                                Spacer()
                                
                            }
                            Divider().frame(height:60).background(Color(hex: "b5b5b5"))
                            
                            HStack{
                                Spacer()
                                VStack(alignment:.center){
                                    Image(uiImage: UIImage(named: "culture.png")!)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1)
                                    Text("문화관광").font(.system(size: 13)).foregroundStyle(Color(hex: "c6c6c6"))
                                }
                                if let culTouristFacilities = InfraFacility?.culTouristFacilities {
                                    HStack{
                                        Text("\(culTouristFacilities)").font(.title3).fontWeight(.semibold).foregroundStyle(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                                    }
                                    
                                }
                                
                                Spacer()
                            }
                            Divider().frame(height:60).background(Color(hex: "b5b5b5"))
                            
                            HStack{
                                Spacer()
                                VStack(alignment:.center){
                                    Image(uiImage: UIImage(named: "edu.png")!)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width * 0.1, height: UIScreen.main.bounds.width * 0.1)
                                    Text("교육").font(.system(size: 13)).foregroundStyle(Color(hex: "c6c6c6"))
                                }
                                if let educationalFacilities = InfraFacility?.educationalFacilities{
                                    HStack{
                                        Text("\(educationalFacilities)").font(.title3).fontWeight(.semibold).foregroundStyle(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                                    }
                                    
                                }
                                Spacer()
                                
                            }
                        }.frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.3).background(Color(hex: "f4f5f7")).padding(.leading,20).padding(.bottom,20).padding(.trailing,20)
                    }
                    
                    VStack(spacing:10){
                        HStack{
                            Text("아파트 정보").font(.title2).fontWeight(.semibold)
                            Spacer()
                        }.frame(width: UIScreen.main.bounds.width * 0.9)
                        
                        HStack {
                            VStack(spacing:2){
                               Spacer()
                                    Text("세대수").font(.system(size: 16)).foregroundStyle(Color(hex: "c6c6c6"))
                                
                                if let apartmentComplexes = InfraAptSet?.apartmentComplexes{
                                    HStack{
                                        Spacer()
                                        Text("\(apartmentComplexes)").font(.title).fontWeight(.semibold).foregroundStyle(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                                        Spacer()
                                    }
                                    
                                }
                                Spacer()
                                
                            }
                            Divider().frame(height:60).background(Color(hex: "b5b5b5"))
                            
                            VStack(spacing:2){
                               Spacer()
                                    Text("평균 면적").font(.system(size: 16)).foregroundStyle(Color(hex: "c6c6c6"))
                                
                                if let aptAvgArea = InfraAptSet?.aptAvgArea{
                                    HStack{
                                        Spacer()
                                        Text("\(aptAvgArea)").font(.title).fontWeight(.semibold).foregroundStyle(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                                        Spacer()
                                    }
                                    
                                }
                                Spacer()
                                
                            }
                            Divider().frame(height:60).background(Color(hex: "b5b5b5"))
                            
                            VStack(spacing:2){
                               Spacer()
                                    Text("가격(억)").font(.system(size: 16)).foregroundStyle(Color(hex: "c6c6c6"))
                                
                                if let faptAvgPrice = InfraAptSet?.aptAvgPrice{
                                    
                                    let originalNumber = faptAvgPrice
                                    let formattedNumber = Int(Double(originalNumber) / 10000000)
                                    let displayNumber = String(format: "%.1f", Double(formattedNumber) / 10.0)
                                    HStack{
                                        Spacer()
//                                        Text(String(format: "%.1f", formattedNumber))
                                        Text(displayNumber)
                                                .font(.title)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                                            Spacer()
                                    }
                                    
                                }
                                Spacer()
                                
                            }
                        }.frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.3).background(Color(hex: "f4f5f7")).padding(.leading,20).padding(.bottom,20).padding(.trailing,20)
                    }
                  
                    
                }
            }.frame(maxHeight: .infinity).onAppear{
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

    private func InfraDecode(endpoint: InfraEndpoints, index: Int) {
        InfraNetworkManager.shared.fetch(endpoint: endpoint.englishEndpoint , commercialDistrictCode: cdCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success (let data):
                    do {
                        if endpoint.englishEndpoint.contains("count") {
                            let decodedResponse = try JSONDecoder().decode(InfraModel.InfraStoreCountApiResponse.self, from: data)
                            let storeGraph = decodedResponse.storeGraph
                            
                            // 업종명 배열
                            let categories = storeGraph.data.categories
                            // 점포 수 배열
                            let storeSeries = storeGraph.data.series.first?.storeCount ?? []
                            // 프랜차이즈 수 배열
                            let franchiseSeries = storeGraph.data.series.first?.franchiseStoreCount ?? []

                            let validCategories = VariableMapping.categoryToServiceCode.keys.sorted(by: {
                                VariableMapping.categoryToServiceCode[$0]! < VariableMapping.categoryToServiceCode[$1]!
                            })
                            let categoryIndices = categories.enumerated()
                                .filter { validCategories.contains($0.element) }
                                .map { $0.offset }

                            let filteredCategories = categoryIndices.map { categories[$0] }
                            let filteredStoreValues = categoryIndices.map { storeSeries[$0] }
                            let filteredFranchiseValues = categoryIndices.map { franchiseSeries[$0] }

                            /* 여기에 storeSeries 중에 그 키가 filteredCategories에 포함되지 않은 것들의 수 + franchiseSeries 중에 그 키가 filteredCategories에 포함되지 않은 것들의 수*/
                            self.othersValue =
                            storeSeries
                                .enumerated()
                                .filter { !categoryIndices.contains($0.offset) }
                                .reduce(0, { $0 + $1.element }) +
                                franchiseSeries
                                .enumerated()
                                .filter { !categoryIndices.contains($0.offset) }
                                .reduce(0, { $0 + $1.element })

                            /* 여기에 filteredCategories에 포함된 것들로 스택바 차트를 그리기 위해서 필요한 데이터들 저장 */
                            let modifiedDataSet =
                                zip(filteredCategories, zip(filteredStoreValues, filteredFranchiseValues))
                                    .map { category, values in
                                        InfraModel.CountChartData(label: category, storeCount: Double(values.0), franchiseStoreCount: Double(values.1))
                                    }
                            self.countChartDataSets = modifiedDataSet
                            dump(self.countChartDataSets)
                            dump(self.othersValue)
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
