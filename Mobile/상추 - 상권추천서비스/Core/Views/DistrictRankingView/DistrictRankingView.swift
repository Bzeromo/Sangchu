import SwiftUI

struct DistrictData {
    var name: String
    var selectedValue : String
    var point : Int
}

struct CardView: View {
    
    var districtData: DistrictData
    var index: Int
    var selectedFilter: String
    @State var isHeartFilled: Bool = false
    
    func formattedSelectedValue() -> String {
            switch selectedFilter {
            case "종합순":
                return "서울시 내 \(districtData.selectedValue)점"
            case "매출순":
                return "\(districtData.selectedValue)원"
            case "유동인구순", "상주인구순":
                return "\(districtData.selectedValue)명"
            case "업종다양성순":
                return "\(districtData.selectedValue) 업종"
            case "점포밀도순":
                return "\(districtData.selectedValue)"
            default:
                return districtData.selectedValue
            }
        }

    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 배경 이미지
                Image(uiImage: UIImage(named: "AppIcon.png")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                // 나머지 UI 컴포넌트
                VStack {
                    HStack {
                        Spacer()
                        // 우측 상단에 위치한 좋아요 버튼
                        Button(action: { self.isHeartFilled.toggle() }) {
                            Image(systemName: isHeartFilled ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                .background(Circle().fill(Color.white).frame(width: 40, height: 40).opacity(0.7))
                        }
                        .padding(.trailing, 30)
                        .padding(.top, 30)
                    }
                    
                    Spacer()
                    
                    // 상권 정보 HStack
                    HStack {
                        Text("\(index + 1)위")
                            .padding(.horizontal, 10)
                        VStack {
                            Spacer()
                            Text(districtData.name).font(.system(size: 22)).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/).foregroundColor(Color.defaultfont)
                            Spacer()
                            Text(formattedSelectedValue()).font(.system(size: 16)).fontWeight(.regular).foregroundColor(Color.customgray)
                            Spacer()
                        }
                        Spacer()
                        Text("\(districtData.point)점")
                            .padding(.horizontal, 10)
                    }
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.20)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(15)
                    .padding(.bottom, 25)
                    .padding(.horizontal, 20)
                    // end of 상권 정보 HStack
                } // end of 나머지 UI 컴포넌트
            }
            .frame(width: min(geometry.size.width, geometry.size.height) , height: min(geometry.size.width, geometry.size.height) )
            .background(Color.clear)
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 3, y: 3)
            .padding(.horizontal, 30)
            // end of ZStack
        } // end of GeometryReader
    } // end of body view
} // end of CardView

struct DistrictRankingView: View {
    @State private var districtDataList = [DistrictData]()
    @State private var selectedPage = 0
    @State private var selectedFilter = "종합순"
    
    let borough : String
    let category : String
    let filters = ["종합순", "매출순", "유동인구순", "상주인구순", "업종다양성순", "점포밀도순"]
    
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 20) {
                    ForEach(0..<districtDataList.count, id: \.self) { index in
                        CardView(districtData: districtDataList[index], index: index, selectedFilter: selectedFilter)
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                            .onChange(of: index) { newIndex in
                                selectedPage = newIndex
                            }
                    }
                }
            }
            .onAppear {
                Task {
                    do {
                        let fetchedData = try await API.fetchDistrictsRanking(borough: borough, category: category)
                        self.districtDataList = fetchedData
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
    static func fetchDistrictsRanking(borough: String, category: String) async throws -> [DistrictData] {
        // 여기에 네트워크 요청을 통해 데이터를 비동기적으로 가져오는 코드를 구현합니다.
        // 이 예시에서는 실제 네트워크 요청 대신 임시 데이터로 대체합니다.
        
        // 임시 데이터 예시
        let sampleData = [
            DistrictData(name: "청운초등학교", selectedValue: "312,345,678", point: 100),
            DistrictData(name: "성곡미술관", selectedValue: "234,567,891", point: 90),
            DistrictData(name: "경복고등학교", selectedValue: "233,567,891", point: 87),
            DistrictData(name: "길음시장", selectedValue: "223,263,246", point: 76),
            DistrictData(name: "유진상가", selectedValue: "12,312,636", point: 55),
            // ...여기에 더 많은 데이터를 추가할 수 있습니다.
        ]
        
        // 실제 네트워크 요청 구현 예시:
        /*
        let urlString = "https://example.com/api/districts?borough=\(borough)&category=\(category)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let districtDataList = try JSONDecoder().decode([DistrictData].self, from: data)
        return districtDataList
        */
        
        // 여기서는 단순히 임시 데이터를 반환합니다.
        return sampleData
    }
}
