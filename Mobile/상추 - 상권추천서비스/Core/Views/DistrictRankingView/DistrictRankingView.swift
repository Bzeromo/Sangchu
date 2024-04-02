import SwiftUI
import Alamofire
import Lottie

struct FilteredDistrictsData : Codable {
    var totalScoreSorted: [DistrictData] = []
    var salesSorted: [DistrictData] = []
    var footTrafficSorted: [DistrictData] = []
    var residentialPopulationSorted: [DistrictData] = []
    var businessDiversitySorted: [DistrictData] = []
}

struct FilteredValue : Codable {
    var value: Double // 실제 값 // ex) 매출 1억 // 단 총점순인 경우 서울시 전체에서의 점수
    var score: Double // 점수 // ex) 매출별 점수 98
}

// 상권 정보
struct DistrictData: Codable {
    var cdCode: Int // 상권 코드
    var name: String // 상권 이름
    var totalScore: FilteredValue // 총점
    var sales: FilteredValue // 매출액 및 점수
    var footTraffic: FilteredValue // 유동인구 및 점수
    var residentialPopulation: FilteredValue // 상주인구 및 점수
    var businessDiversity: FilteredValue // 업종다양성 및 점수
}

struct CommercialDistrictInfo: Codable {
    var commercialDistrictCode: Int
    var commercialDistrictName: String
    var latitude: Double
    var longitude: Double
    var guCode: Int
    var guName: String
    var dongCode: Int
    var dongName: String
    var areaSize: Int
    var commercialDistrictScore: Double
    var salesScore: Double
    var residentPopulationScore: Double
    var floatingPopulationScore: Double
    var rdiScore: Double
}

struct CardView: View {
    var districtData: DistrictData // 상권 정보
    var index: Int // 해당 카드의 인덱스
    @State private var districtInfo: CommercialDistrictInfo? = nil
    let MainColors: [Color] = [Color(hex: "50B792"),Color(hex: "3B7777")]
    func fetchCommercialDistrictInfo(for cdCode: Int) async throws {
        let urlString = "https://j10b206.p.ssafy.io/api/commdist/commercial?commercialDistrictCode=\(cdCode)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let info = try JSONDecoder().decode(CommercialDistrictInfo.self, from: data)
        
        DispatchQueue.main.async {
            self.districtInfo = info
        }
    }
    
    var body: some View {
            if let districtInfo = districtInfo {
                    VStack{
                        HStack{
                            LottieView(animation: .named("Export.json"))
                                                        .playbackMode(.playing(.toProgress(1,loopMode: .loop)))
                                                        .frame(width: 180,height: 180)
                            VStack{
                                HStack{
                                    
                                    Text("\(index + 1)위")
                                        .foregroundColor(Color.black)
                                        .fontWeight(.bold)
                                        .font(.largeTitle)
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("총점 ")
                                        .foregroundColor(Color.black)
                                        .font(.title2)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/) +
                                    Text("\(String(format: "%.0f", districtData.totalScore.score))점")
                                        .foregroundStyle(Color.black)
                                        .font(.title2)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    Spacer()
                                }
                                HStack{
                                    
                                    Text("서울 내 상권 중")
                                        .foregroundColor(.defaultfont)
                                        .font(.caption) +
                                    Text(" \(String(format: "%.0f", districtData.totalScore.value))등")
                                        .foregroundStyle(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                                        .font(.caption)
                                    
                                    Spacer()
                                }
                              
                               
                            }
                        }
                        .frame(maxWidth:.infinity)
                        .background(Color.yellow)
                        
                        VStack(alignment: .leading, spacing: 13) {
                            HStack{
                                Spacer()
                                Text(districtData.name)
                                    .foregroundStyle(Color.black)
                                    .fontWeight(.bold)
                                    .font(.title)
                                    .lineLimit(1)
                                Spacer()
                            }
                           
                            Divider()
                            
                            VStack{
                                HStack{
                                    Text("매출")
                                        .foregroundColor(.defaultfont)
                                        .font(.title3)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    Spacer()
                                    Text("\(String(format: "%.0f", districtData.sales.score))점")
                                        .foregroundColor(.defaultfont)
                                        .font(.title3)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                 
                                }
                                HStack{
                                    Text("\(String(format: "%.0f", districtData.sales.value))원")
                                        .foregroundColor(.customgray)
                                        .font(.body)
                                    Spacer()
                                }
                                
                            }.frame(maxWidth: .infinity).padding(.leading, 40).padding(.trailing,40).padding(.top,15)
                                      
                                        
                            VStack{
                                HStack{
                                    Text("유동인구")
                                        .foregroundColor(.defaultfont)
                                        .font(.title3)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    Spacer()
                                    Text("\(String(format: "%.0f", districtData.footTraffic.score))점")
                                        .foregroundColor(.defaultfont)
                                        .font(.title3)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                
                                }
                                HStack{
                                    Text("\(String(format: "%.0f", districtData.footTraffic.value))명")
                                        .foregroundColor(.customgray)
                                        .font(.body)
                                    Spacer()
                                }
                              
                            }.frame(maxWidth: .infinity).padding(.leading, 40).padding(.trailing,40)
                                        
                           
                                        
                            VStack{
                                HStack{
                                    Text("상주인구")
                                        .foregroundColor(.defaultfont)
                                        .font(.title3)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    Spacer()
                                    Text("\(String(format: "%.0f", districtData.residentialPopulation.score))점")
                                        .foregroundColor(.defaultfont)
                                        .font(.title3)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                  
                                }
                                HStack{
                                    Text("\(String(format: "%.0f",districtData.residentialPopulation.value))명")
                                        .foregroundColor(.customgray)
                                        .font(.body)
                                    Spacer()
                                }
                               
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.leading, 40).padding(.trailing,40)
                                        
                            VStack{
                                HStack{
                                    Text("업종다양성")
                                        .foregroundColor(.defaultfont)
                                        .font(.title3)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    Spacer()
                                    Text("\(String(format: "%.0f", districtData.businessDiversity.score))점")
                                        .foregroundColor(.defaultfont)
                                        .font(.title3)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                }
                                HStack{
                                    Text("\(String(format: "%.0f",districtData.businessDiversity.value))업종")
                                        .foregroundColor(.customgray)
                                        .font(.body)
                                    Spacer()
                                }
                              
                            }.frame(maxWidth: .infinity)
                                .padding(.leading, 40).padding(.trailing,40)
                                       
                        }.frame(maxWidth : .infinity)
                                
                        Spacer()
                        NavigationLink(destination: BDMapView(cameraLatitude: districtInfo.longitude, cameraLongitude: districtInfo.latitude, selectedCDCode: String(districtInfo.commercialDistrictCode), selectedCDName: districtInfo.commercialDistrictName))
                        {
                            Text("정보 보러가기")
                                .font(.system(size: 15))
                                .foregroundColor(Color.black)
                                .shadow(color: Color(hex:"c6c6c6"), radius: 1, x: 1, y: 1)
                        }
                        .frame(width : UIScreen.main.bounds.width * 0.35 , height : 35)
                        .background(Color.yellow)
                        .cornerRadius(20)
                        .padding(.top, 15)
                        
                        Spacer()
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 20) // 둥근 모서리를 가진 사각형 테두리를 정의
                            .stroke(Color.black, lineWidth: 1) // 테두리의 색상과 선의 두께 지정
                    )
                    .cornerRadius(20)
            }else{
                VStack{
                    Text("")
                }.onAppear {
                    Task {
                        do {
                            try await fetchCommercialDistrictInfo(for: districtData.cdCode)
                        } catch {
                            print("Error fetching district info: \(error)")
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
            }
        
    }
}



struct DistrictRankingView: View {
    @State private var isLoading = false
    @State private var hasFetchedData = false // 데이터를 이미 가져왔는지 여부 // 무한 렌더링 방지
    @State private var filteredDistrictsData = FilteredDistrictsData(totalScoreSorted: [], salesSorted: [], footTrafficSorted: [], residentialPopulationSorted: [], businessDiversitySorted: [])
    @State private var selectedPage = 0
    @State private var selectedFilter = "종합순"
    
    var borough : String
    var category : String
    let filters = ["종합순", "매출순", "유동인구순", "상주인구순", "업종다양성순"]
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    @State private var startAnimation : Bool = false
    let universalSize = UIScreen.main.bounds
    
    
    func getSinWave(interval : CGFloat, amplitude : CGFloat = 100,baseline:CGFloat = UIScreen.main.bounds.height / 2) ->
    Path{
        Path { path in
            path.move(to: CGPoint(x:0, y:baseline))
            path.addCurve(to: CGPoint(x : 1 * interval, y : baseline),
                          control1: CGPoint(x:interval * (0.3),y: amplitude + baseline),
                          control2: CGPoint(x:interval * (0.7),y: -amplitude + baseline)
            )
            path.addCurve(to: CGPoint(x : 2 * interval, y : baseline),
                          control1: CGPoint(x:interval * (1.3),y: amplitude + baseline),
                          control2: CGPoint(x:interval * (1.7),y: -amplitude + baseline)
            )
            path.addLine(to: CGPoint(x: 2 * interval, y: universalSize.height))
            path.addLine(to: CGPoint(x: 0 , y: universalSize.height))
        }
    }
    
    private var currentFilteredData: [DistrictData] {
        switch selectedFilter {
        case "종합순":
            return filteredDistrictsData.totalScoreSorted
        case "매출순":
            return filteredDistrictsData.salesSorted
        case "유동인구순":
            return filteredDistrictsData.footTrafficSorted
        case "상주인구순":
            return filteredDistrictsData.residentialPopulationSorted
        case "업종다양성순":
            return filteredDistrictsData.businessDiversitySorted
        default:
            return []
        }
    }
    
    var body: some View {
        VStack(spacing: 2) {
            Spacer().frame(height: 120)
                HStack{
                    Menu {
                        ForEach(filters, id: \.self) { filter in
                            Button(filter) {
                                selectedFilter = filter
                            }
                        }
                    }
                label: {
                    HStack {
                        Text(selectedFilter)
                            .foregroundStyle(.defaultfont)
                        Image(systemName: "chevron.down")
                            .foregroundStyle(.defaultfont)
                    }
                    .padding(.leading, 20)
                }
                    Spacer()
                }
                
                if isLoading {
                    VStack {
                        Text("분석중..").font(.title).fontWeight(.semibold).foregroundStyle(LinearGradient(gradient: Gradient(colors: MainColors), startPoint: .top, endPoint: .bottom))
                        LottieView(animation: .named("Cal.json"))
                            .playbackMode(.playing(.toProgress(1,loopMode: .loop)))
                            .padding(.bottom, UIScreen.main.bounds.height * 0.35)
                        
                    }
                }
                else {
                    ScrollView(.horizontal) {
                            LazyHStack{
                                ForEach(currentFilteredData.indices, id: \.self) { index in
                                    HStack{
                                        Spacer()
                                        CardView(districtData: currentFilteredData[index], index: index)
                                            .frame(maxWidth: .infinity)
                                        Spacer()
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.7)
                                    .scrollTransition{ content, phase in
                                        content
                                            .opacity(phase.isIdentity ? 1.0 : 0.5) // 그전의 것이 연하게됨
                                    }
                                }
                            }.scrollTargetLayout()
                            
                        
                    }
                    .contentMargins(20, for: .scrollContent)
                    .scrollTargetBehavior(.paging) // 알맞게 페이징됨,
                    .scrollIndicators(.hidden) // 밑에 바 숨겨줌
                    .onAppear {
                        if !hasFetchedData {
                            Task {
                                isLoading = true
                                do {
                                    // API 요청을 통해 filteredDistrictsData를 초기화
                                    let fetchedData = try await API.fetchFilteredDistrictsData(borough: borough, category: category)
                                    self.filteredDistrictsData = fetchedData
                                } catch {
                                    print("데이터를 가져오는 데 실패했습니다.")
                                }
                                isLoading = false
                                hasFetchedData = true
                            }
                        }
                    }
                }
                Spacer()
            } // end of VStack
            .navigationTitle("\(borough)_\(category)")
            .ignoresSafeArea(.all)
            .onAppear{
                self.startAnimation = true
            }
            .background(Color(hex: "F4F5F7"))
        
    } // end of body view
} // end of DistrictRankingView

struct API {
    static func fetchFilteredDistrictsData(borough: String, category: String) async throws -> FilteredDistrictsData {
        guard let guCode = VariableMapping.boroughsToGuCode[borough],
              let serviceCode = VariableMapping.categoryToServiceCode[category] else {
            throw URLError(.badURL)
        }

//        print("\(borough)의 guCode = \(guCode)")
//        print("category = \(category) / \(serviceCode)")
        
        let url = "https://j10b206.p.ssafy.io/api/commdist/district-rank?guCode=\(guCode)&serviceCode=\(serviceCode)"
        do {
            let response: DataResponse<[DistrictData], AFError> = await AF.request(url).serializingDecodable([DistrictData].self).response
            switch response.result {
            case .success(let districtDatas):
                var tmpFilteredData = FilteredDistrictsData()
                tmpFilteredData.totalScoreSorted = districtDatas.sorted(by: { $0.totalScore.score > $1.totalScore.score })
                tmpFilteredData.salesSorted = districtDatas.sorted(by: { $0.sales.score > $1.sales.score })
                tmpFilteredData.footTrafficSorted = districtDatas.sorted(by: { $0.footTraffic.score > $1.footTraffic.score })
                tmpFilteredData.residentialPopulationSorted = districtDatas.sorted(by: { $0.residentialPopulation.score > $1.residentialPopulation.score })
                tmpFilteredData.businessDiversitySorted = districtDatas.sorted(by: { $0.businessDiversity.score > $1.businessDiversity.score })
                return tmpFilteredData
            case .failure(let error):
                print("Request error: \(error)")
                throw error
            }

        } catch {
            throw error
        }
    }
}
