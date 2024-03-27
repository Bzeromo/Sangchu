import SwiftUI
import Alamofire

struct FilteredDistrictsData : Codable {
    var totalScoreSorted: [DistrictData] = []
    var salesSorted: [DistrictData] = []
    var footTrafficSorted: [DistrictData] = []
    var residentialPopulationSorted: [DistrictData] = []
    var businessDiversitySorted: [DistrictData] = []
}

struct FilteredValue : Codable {
    var value: Int // 실제 값 // ex) 매출 1억 // 단 총점순인 경우 서울시 전체에서의 점수
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
    var commercialDistrictCode: Int?
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

// 위도, 경도 표시
struct DistrictDetailView: View {
    var latitude: Double
    var longitude: Double
    
    var body: some View {
        VStack {
            Text("위도: \(latitude)")
            Text("경도: \(longitude)")
        }
    }
}

// ScrollView 내부의 카드 하나
struct CardView: View {
    var districtData: DistrictData // 상권 정보
    var index: Int // 해당 카드의 인덱스
    var selectedFilter: String // 필터링 기준
    @State var isBookMarked: Bool = false // 좋아요 여부
    @State private var isActive = false // 네비게이션 링크 활성화 상태
    @State private var latitude: Double? = nil
    @State private var longitude: Double? = nil
    
    // 위도 경도 받아옴
    func fetchCoordinates(for cdCode: String) async throws -> (latitude: Double, longitude: Double) {
        let urlString = "http://3.36.91.181:8084/api/commdist/commercial?commercialDistrictCode=\(cdCode)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let districtInfo = try JSONDecoder().decode(CommercialDistrictInfo.self, from: data)
        
        return (districtInfo.latitude, districtInfo.longitude)
    }
    
    func fetchAndNavigate() {
        Task {
            do {
                let coordinates = try await fetchCoordinates(for: String(districtData.cdCode))
                latitude = coordinates.longitude
                longitude = coordinates.latitude
                isActive = true // 화면 전환 트리거
                print("\\( \(String(describing: latitude)) , \(String(describing: longitude)) \\)")
            } catch {
                print(error)
            }
        }
    }
    
    // 필터링에 따라 카드에 보여질 내용 만드는 함수
    func formattedSelectedValue() -> String {
        switch selectedFilter {
        case "종합순":
                return "서울시 내 \(districtData.totalScore.value)점"
        case "매출순":
                return "\(districtData.sales.value)원"
        case "유동인구순":
            return "\(districtData.footTraffic.value)명"
        case "상주인구순":
            return "\(districtData.residentialPopulation.value)명"
        case "업종다양성순":
            return "\(districtData.businessDiversity.value) 업종"
        default:
            return "정보 없음"
        }
    }
    
    func selectedScore() -> Double {
           switch selectedFilter {
           case "종합순":
                   return districtData.totalScore.score
           case "매출순":
               return districtData.sales.score
           case "유동인구순":
               return districtData.footTraffic.score
           case "상주인구순":
               return districtData.residentialPopulation.score
           case "업종다양성순":
               return districtData.businessDiversity.score
           default:
               return 0 // 기본값 혹은 해당하는 필터링이 없을 경우
           }
       }

    var body: some View {
            GeometryReader { geometry in
                ZStack {
                    // 배경 이미지
                    Image(uiImage: UIImage(named: "RoundRank\(index + 1)") ?? UIImage(named: "RoundRank9")!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .edgesIgnoringSafeArea(.all)
                    
                    // 나머지 UI 컴포넌트
                    VStack {
                        HStack {
                            Spacer()
                            // 우측 상단에 위치한 북마크 버튼
                            Button(action: { self.isBookMarked.toggle() }) {
                                Image(systemName: isBookMarked ? "bookmark.fill" : "bookmark")
                                    .foregroundColor(.brown)
                                    .background(Circle().fill(Color.white).frame(width: 40, height: 40).opacity(0.7))
                            }
                            .padding(.trailing, 50)
                            .padding(.top, 50)
                        }
                        
                        Spacer()
                        
                        // 상권 정보 HStack
                        HStack {
                            VStack (alignment: .leading) {
                                // 상권이름
                                Text(districtData.name).font(.system(size: 22)).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).foregroundColor(Color.defaultfont)
                                    .padding(.horizontal)
                                    .padding(.top, 40)
                                Spacer()
                                // 값 - 고른 필터에 따라 달라짐
                                Text(formattedSelectedValue()).font(.system(size: 16)).fontWeight(.regular).foregroundColor(Color.customgray)
                                    .padding(.horizontal)
                                    .padding(.bottom, 40)
                            }
                            Spacer()
                            Text("\(selectedScore())점")
                                .font(.largeTitle)
                                .padding(.horizontal, 10)
                                .foregroundColor(Color.sangchu)
                        }
                        .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.20)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(15)
                        .padding(.bottom, 5)
                        .padding(.horizontal, 20)
                        // end of 상권 정보 HStack
                    } // end of 나머지 UI 컴포넌트
                }
                .frame(width: min(geometry.size.width, geometry.size.height) , height: min(geometry.size.width, geometry.size.height) )
                .background(Color.clear)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 3, y: 3)
                .onTapGesture {
                    fetchAndNavigate()
                }
                .background(
                    NavigationLink(destination: BDMapView(cameraLatitude: latitude, cameraLongitude: longitude, selectedCDCode: String(districtData.cdCode), selectedCDName: districtData.name), isActive: $isActive) {
                        EmptyView()
                    }
                    .hidden() // NavigationLink를 숨깁니다.
                )
                // end of ZStack
            } // end of GeometryReader
    } // end of body view
} // end of CardView

struct DistrictRankingView: View {
    @State private var isLoading = false
    @State private var hasFetchedData = false // 데이터를 이미 가져왔는지 여부 // 무한 렌더링 방지
    @State private var filteredDistrictsData = FilteredDistrictsData(totalScoreSorted: [], salesSorted: [], footTrafficSorted: [], residentialPopulationSorted: [], businessDiversitySorted: [])
    @State private var selectedPage = 0
    @State private var selectedFilter = "종합순"
    
    var borough : String
    var category : String
    let filters = ["종합순", "매출순", "유동인구순", "상주인구순", "업종다양성순", "점포밀도순"]
    
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
        VStack {
            Text("\(borough) 내 상권랭킹").font(.largeTitle).foregroundColor(Color.defaultfont)
            
            // 필터링 버튼 추가
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
                    Image(systemName: "chevron.down")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            }
            .padding(.vertical, 10)
            if isLoading {
                Spacer().frame(height: 120)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .sangchu))
                    .scaleEffect(5)
            }
            else {
                TabView {
                    ForEach(currentFilteredData.indices, id: \.self) { index in
                        CardView(districtData: currentFilteredData[index], index: index, selectedFilter: selectedFilter)
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // 원형 인디케이터를 항상 표시합니다.
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width) // TabView의 크기를 지정합니다.
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
    } // end of body view
} // end of DistrictRankingView

struct API {
    static func fetchFilteredDistrictsData(borough: String, category: String) async throws -> FilteredDistrictsData {
        guard let guCode = VariableMapping.boroughsToGuCode[borough],
              let serviceCode = VariableMapping.categoryToServiceCode[category] else {
            print("여기서 막힘!")
            throw URLError(.badURL)
        }

        print("guCode = \(guCode)")
        print("category = \(category)")
        
        let url = "http://3.36.91.181:8084/api/commdist/district-rank?guCode=\(guCode)&serviceCode=\(serviceCode)"
        do {
            let response: DataResponse<[DistrictData], AFError> = try await AF.request(url).serializingDecodable([DistrictData].self).response
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
