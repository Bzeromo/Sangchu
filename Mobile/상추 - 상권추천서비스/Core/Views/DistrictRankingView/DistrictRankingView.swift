import SwiftUI

struct FilteredDistrictsData: Codable {
    var totalScoreSorted: [DistrictData]
    var salesSorted: [DistrictData]
    var footTrafficSorted: [DistrictData]
    var residentialPopulationSorted: [DistrictData]
    var businessDiversitySorted: [DistrictData]
}

struct FilteredValue : Codable {
    var value: Int // 실제 값 // ex) 매출 1억 // 단 총점순인 경우 서울시 전체에서의 점수
    var score: Int // 점수 // ex) 매출별 점수 98
}

// 상권 정보
struct DistrictData: Identifiable, Codable {
    var id: String {cdCode}
    var cdCode: String // 상권 코드
    var name: String // 상권 이름
    var totalScore: FilteredValue // 총점
    var sales: FilteredValue // 매출액 및 점수
    var footTraffic: FilteredValue // 유동인구 및 점수
    var residentialPopulation: FilteredValue // 상주인구 및 점수
    var businessDiversity: FilteredValue // 업종다양성 및 점수
}


// ScrollView 내부의 카드 하나
struct CardView: View {
    
    var districtData: DistrictData // 상권 정보
    var index: Int // 해당 카드의 인덱스
    var selectedFilter: String // 필터링 기준
    @State var isBookMarked: Bool = false // 좋아요 여부
    
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
    
    func selectedScore() -> Int {
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
                Image(uiImage: UIImage(named: "RoundRank\(index + 1)")!) // 이 부분의 각 상권의 이미지 또는 순위가 들어가야 함
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
            // end of ZStack
        } // end of GeometryReader
    } // end of body view
} // end of CardView

struct DistrictRankingView: View {
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
            
            TabView {
                ForEach(currentFilteredData.indices, id: \.self) { index in
                    CardView(districtData: currentFilteredData[index], index: index, selectedFilter: selectedFilter)
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // 원형 인디케이터를 항상 표시합니다.
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width) // TabView의 크기를 지정합니다.
            .onAppear {
                Task {
                    do {
                        // API 요청을 통해 filteredDistrictsData를 초기화
                        let fetchedData = try await API.fetchFilteredDistrictsData(borough: borough, category: category)
                        self.filteredDistrictsData = fetchedData
                    } catch {
                        print("데이터를 가져오는 데 실패했습니다.")
                    }
                }
            }
            Spacer()
        } // end of VStack
    } // end of body view
} // end of DistrictRankingView

struct API {
    static func fetchFilteredDistrictsData(borough: String, category: String) async throws -> FilteredDistrictsData {

        // 샘플용
        let sampleData: [DistrictData] = [
            DistrictData(cdCode: "3110291", name: "상권A", totalScore: FilteredValue(value: 1000, score: 80), sales: FilteredValue(value: 100, score: 70), footTraffic: FilteredValue(value: 500, score: 90), residentialPopulation: FilteredValue(value: 200, score: 60), businessDiversity: FilteredValue(value: 10, score: 50)),
            DistrictData(cdCode: "3110293", name: "상권B", totalScore: FilteredValue(value: 900, score: 85), sales: FilteredValue(value: 150, score: 75), footTraffic: FilteredValue(value: 400, score: 95), residentialPopulation: FilteredValue(value: 300, score: 55), businessDiversity: FilteredValue(value: 15, score: 45)),
            DistrictData(cdCode: "3110295", name: "상권C", totalScore: FilteredValue(value: 800, score: 78), sales: FilteredValue(value: 120, score: 82), footTraffic: FilteredValue(value: 450, score: 88), residentialPopulation: FilteredValue(value: 250, score: 65), businessDiversity: FilteredValue(value: 12, score: 48)),
            DistrictData(cdCode: "3110281", name: "상권D", totalScore: FilteredValue(value: 700, score: 75), sales: FilteredValue(value: 130, score: 80), footTraffic: FilteredValue(value: 420, score: 85), residentialPopulation: FilteredValue(value: 220, score: 70), businessDiversity: FilteredValue(value: 13, score: 55)),
            DistrictData(cdCode: "3110290", name: "상권E", totalScore: FilteredValue(value: 650, score: 72), sales: FilteredValue(value: 110, score: 78), footTraffic: FilteredValue(value: 480, score: 91), residentialPopulation: FilteredValue(value: 210, score: 75), businessDiversity: FilteredValue(value: 11, score: 50)),
            DistrictData(cdCode: "3110286", name: "상권F", totalScore: FilteredValue(value: 600, score: 70), sales: FilteredValue(value: 140, score: 77), footTraffic: FilteredValue(value: 430, score: 86), residentialPopulation: FilteredValue(value: 240, score: 68), businessDiversity: FilteredValue(value: 14, score: 53)),
            DistrictData(cdCode: "3110297", name: "상권G", totalScore: FilteredValue(value: 550, score: 65), sales: FilteredValue(value: 90, score: 65), footTraffic: FilteredValue(value: 410, score: 80), residentialPopulation: FilteredValue(value: 230, score: 62), businessDiversity: FilteredValue(value: 9, score: 47))
        ]

        return FilteredDistrictsData(
            totalScoreSorted: sampleData.sorted(by: { $0.totalScore.score > $1.totalScore.score }),
            salesSorted: sampleData.sorted(by: { $0.sales.score > $1.sales.score }),
            footTrafficSorted: sampleData.sorted(by: { $0.footTraffic.score > $1.footTraffic.score }),
            residentialPopulationSorted: sampleData.sorted(by: { $0.residentialPopulation.score > $1.residentialPopulation.score }),
            businessDiversitySorted: sampleData.sorted(by: { $0.businessDiversity.score > $1.businessDiversity.score })
        )
    } // end of fetchFilteredDistrictsData
} // end of API
