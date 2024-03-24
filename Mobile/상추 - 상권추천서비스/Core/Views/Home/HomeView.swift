//
//  ContentView.swift
//  상추 - 상권 분석 서비스
//
//  Created by 안상준 on 3/7/24.
//

import SwiftUI
import SwiftData
import Alamofire
import Charts

struct HomeView: View {
    
    @Environment(\.verticalSizeClass) var varticalSizeClass
    @StateObject private var viewModel: ViewModel = ViewModel()
    
    @State var gradiant = [Color(hex: "37683B"), Color(hex: "529B58")]
    
    private var scrollObservableView: some View {
            GeometryReader { proxy in
                let offsetY = proxy.frame(in: .global).origin.y
                Color.clear
                    .preference(
                        key: ScrollOffsetKey.self,
                        value: offsetY
                    )
                    .onAppear {
                        viewModel.setOriginOffset(offsetY)
                    }
            }
            .frame(height: 0)
        }
    struct ScrollOffsetKey: PreferenceKey {
        static var defaultValue: CGFloat = .zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value += nextValue()
        }
    }
    // 값 확인하는 뷰 주석처리 해두었음
    struct HeaderView: View {
            @Binding var direct: Direct
            @Binding var offset: CGFloat
            
            var body: some View {
                ZStack {
                    Color.orange
                    VStack {
                    Text("Header View")
                        Text("\(direct.title)로 스크롤중")
                        Text("현재위치: \(offset)")
                    }
                }
                .frame(height: 100)
            }
        }
    
    
    
    
    var body: some View {
            ScrollView(.vertical) {
                scrollObservableView
//                HeaderView(direct: $viewModel.direct, offset: $viewModel.offset) // offset 값 확인 코드
                VStack { // 전체 감싸진 VStack
                    VStack{
                      
                        ZStack{
                            VStack{
                                let offset = $viewModel.offset //  기본값은 47 원하는 액션은 양수
                                let scaleFactor = max(1, 1 + offset.wrappedValue / 200)
                                let offsetFactor = min(-10, -10 - offset.wrappedValue )
                                // 위로하면 양수, 아래로 하면 음수
                                Image(uiImage: UIImage(named: "AppIcon.png")!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .scaleEffect(scaleFactor) // 스크롤에 따라 크기 늘림
                                    .frame(alignment: .top)
                                    .offset(y: offsetFactor)
                                Spacer()
                            }
                            
                            VStack{
                                LinearGradient(colors: gradiant, startPoint: .top, endPoint: .bottom).frame(height : 150)
                            }
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            
                            VStack(alignment: .center){
                                HStack{
                                    Spacer()
                                    Button(action: {}) {
                                        Image(systemName: "magnifyingglass.circle")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.black) // 버튼의 크기를 지정합니다.
                                    }.padding(.top, 40).padding(.trailing,20)
                                }
                                Spacer()
                                VStack(spacing: 7){
                                    Text("상추")
                                        .font(.system(size: 17))
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    //                                    .foregroundColor(Color(hex: "767676"))
                                        .foregroundColor(Color.white)
                                    Text("맞춤형 분석 서비스를")
                                        .font(.system(size: 25))
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    //                                    .foregroundColor(Color(hex: "767676"))
                                        .foregroundColor(Color.white)
                                    Text("체험해보세요")
                                        .font(.system(size: 25))
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        .foregroundColor(Color.white)
                                    NavigationLink(destination: ChooseBorough()) {
                                        Text("무료체험")
                                            .font(.system(size: 17))
                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                            .padding()
                                            .frame(width: UIScreen.main.bounds.width * 0.78)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                }.padding(.bottom,20)
                                
                            }
                            
                            
                        }.frame(height: 500)
                        testView()
                    }
                    
                    // 상단 사진과 글귀
                    VStack{
                        HStack{
                            Button(action: {}) {
                                Image(uiImage: UIImage(named: "AppIcon.png")!)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.black) // 버튼의 크기를 지정합니다.
                            }
                            Spacer()
                            Button(action: {
                                print("공백")
                            }) {
                                Text("") // 내용이 없는 텍스트를 제공합니다.
                                    .frame(maxWidth: .infinity, maxHeight: .infinity) // 버튼의 터치 가능 영역을 지정합니다.
                                    .background(Color.clear)
                            }.frame(maxWidth: .infinity)
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: "magnifyingglass.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(hex: "93C73D")) // 버튼의 색상 지정합니다.
                            }
                        }
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.84, maxHeight : UIScreen.main.bounds.height * 0.02)
                        .padding() // 내부 여백 추가
                        .background(Color.white) // 배경색 추가
                        .cornerRadius(70) // 모서리를 둥글게 처리
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 2, y: 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 70) // 둥근 모서리 설정
                                .stroke(Color(hex: "93C73D"), lineWidth: 1) // 테두리 색상과 두께 지정
                        ) // 검색창
                        
                        HStack{
                            NavigationLink (destination: BDMapView()) {
                                HStack {
                                    VStack (alignment: .leading) {
                                        Text("상권 지도")
                                            .font(.system(size: 22))
                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                            .foregroundColor(Color(hex: "767676"))
                                            .padding(2)
                                        Text("주변 상권 보기")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color(hex: "93C73D"))
                                            .padding(3)
                                    }
                                    Spacer()
                                    VStack{
                                        Spacer()
                                        Image(systemName: "map.circle")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(Color(hex: "93C73D")) // 버튼의 크기를 지정합니다.
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.38)
                                .padding()
                                .background(Color.white) // 전체 VStack의 배경색 설정
                                .cornerRadius(20) // 모서리 둥글게
                                .shadow(color: Color.black.opacity(0.2), radius: 1, x: 1, y: 1) // 그림자 효과 추가
                            }
                            
                            NavigationLink (destination: BookMarkList()) {
                                HStack {
                                    VStack (alignment: .leading) {
                                        Text("북마크")
                                            .font(.system(size: 22))
                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                            .foregroundColor(Color(hex: "767676"))
                                            .padding(2)
                                        Text(" 개")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color(hex: "93C73D"))
                                            .padding(3)
                                    }
                                    Spacer()
                                    VStack{
                                        Spacer()
                                        Image(systemName: "bookmark.circle")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(Color(hex: "93C73D"))
                                    }
                                }.frame(width: UIScreen.main.bounds.width * 0.38)
                                    .padding()
                                    .background(Color.white) // 전체 VStack의 배경색 설정
                                    .cornerRadius(20) // 모서리 둥글게
                                    .shadow(color: Color.black.opacity(0.2), radius: 1, x: 1, y: 1) // 그림자 효과 추가
                            }
                        } // 지도탭과 북마크탭
                        ScrollView(.horizontal){
                        HStack{
                            
                                ForEach(1 ... 10, id : \.self) { number in
                                    Circle().containerRelativeFrame(.horizontal, count: varticalSizeClass == .regular ? 3: 4, spacing : 16)
                                    
                                }
                                
                            }
                        }
                    }
                    
                    
                }
                .background(Color(hex: "F4F5F7")) // Vstack
                
                
            } // 전체를 담은 ScrollView
//            .accentColor(Color("sangchu")) // 툴바 자식들 색상
//            .navigationBarTitle("홈", displayMode: .inline)
            .ignoresSafeArea(.all)
            .onPreferenceChange(ScrollOffsetKey.self) {
                viewModel.setOffset($0)
            }.background(Color(hex: "F4F5F7"))
        }
}

// 위 아래 none 배열
enum Direct {
    case none
    case up
    case down
    
    var title: String {
        switch self {
            case .none: return "ㅇㅇ"
            case .up: return "위"
            case .down: return "아래"
        }
    }
}

final class ViewModel: ObservableObject {
    @Published var offset: CGFloat = 0
    @Published var direct: Direct = .none
    private var originOffset: CGFloat = 0
    private var isCheckedOriginOffset: Bool = false
    
    func setOriginOffset(_ offset: CGFloat) {
        guard !isCheckedOriginOffset else { return }
        self.originOffset = offset
        self.offset = offset
        isCheckedOriginOffset = true
    }
    
    func setOffset(_ offset: CGFloat) {
        guard isCheckedOriginOffset else { return }
        if self.offset < offset {
            direct = .down
        } else if self.offset > offset {
            direct = .up
        } else {
            direct = .none
        }
        self.offset = offset
    }
}



//struct CDMIconOrLoadingView: View {
//    let commercialDistrictMapIcon = UIImage(named: "상권지도아이콘.png")
//
//    var body: some View {
//        if let icon = commercialDistrictMapIcon {
//            Image(uiImage: icon)
//                .resizable()
//                .scaledToFit()
//                .frame(width: UIScreen.main.bounds.width / 4)
//        } else {
//            Image(systemName: "arrow.triangle.2.circlepath.circle")
//                .resizable()
//                .scaledToFit()
//                .frame(width: UIScreen.main.bounds.width / 4)
//        }
//    }
//}
//
//struct CRIconOrLoadingView: View {
//    let customizedRecommendationIcon = UIImage(named: "맞춤추천받기아이콘.png")
//
//    var body: some View {
//        if let icon = customizedRecommendationIcon {
//            Image(uiImage: icon)
//                .resizable()
//                .scaledToFit()
//                .frame(width: UIScreen.main.bounds.width / 4)
//        } else {
//            Image(systemName: "arrow.triangle.2.circlepath.circle")
//                .resizable()
//                .scaledToFit()
//                .frame(width: UIScreen.main.bounds.width / 4)
//        }
//    }
//}
//
//
//struct TopView : View {
//    var colorScheme: ColorScheme // ColorScheme 타입의 변수 추가
//
//    var body: some View {
//        HStack {
//            Image(uiImage: UIImage(named: "AppIcon.png")!).resizable().scaledToFit().frame(width: 30, height: 30).padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 5))
//            Text("상추").font(.SingleDay).foregroundColor(Color.sangchu)
//            Spacer()
//        }
//        // 간단 소개
//        Spacer().frame(height: 11)
//        HStack {
//            Text("골목상권 찾기").font(.title).foregroundColor(colorScheme == .dark ? .white : .black)
//                .padding([.leading, .trailing], 20)
//                .font(.largeTitle)
//                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//            Spacer()
//        }
//        // 간단 소개
//        HStack {
//            Text("상추와 함께 하세요!").font(.title3).foregroundColor(Color(hex: "767676"))
//                .padding([.leading, .trailing], 20)
//            Spacer()
//        }
//    }
//}
//
//struct SearchBar : View {
//    @Binding var searchText: String // searchText를 @Binding으로 선언
//    var body: some View {
//        
//        VStack{
//            
//            HStack {
//                // 검색창과 아이콘을 포함하는 HStack
//                TextField("상권 이름으로 검색해보세요", text: $searchText)
//                    .padding(7)
//                    .padding(.leading, 20) // 아이콘 이미지 공간을 위한 패딩
//                    .padding(.trailing, 30) // 돋보기 버튼 공간을 위한 패딩
//                    .cornerRadius(15)
//                    .frame(height: 40)
//                    .overlay(
//                        HStack {
//                            // 앱 아이콘
//                            Image(uiImage: UIImage(named: "AppIcon.png")!)
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 20, height: 20)
//                                .clipShape(Circle())
//                            
//                            Spacer()
//                            
//                            // 돋보기 버튼
//                            if !searchText.isEmpty {
//                                Button(action: {
//                                    self.searchText = ""
//                                }) {
//                                    Image(systemName: "multiply.circle.fill")
//                                        .foregroundColor(.gray)
//                                }
//                            }
//                            
//                            Image(systemName: "magnifyingglass")
//                                .foregroundColor(Color(hex: "93C73D"))
//                                .padding(.trailing, 8)
//                        }
//                    )
//                    .padding(.horizontal, 10)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 15)
//                            .stroke(Color.sangchu, lineWidth: 1) // 테두리 색상과 두께 조정
//                            .shadow(color: .gray, radius: 3, x: 0, y: 2) // 그림자 효과 추가
//                    )
//            } // HStack
//            .padding(.bottom, 5)
//            .padding(.horizontal) // 이 부분에 주는 padding에 따라서 검색창 가로 너비 조절!
//            
//            HStack{
//                Text("일 검색횟수 125회, 누적 검색횟수 1520회")
//                    .font(.system(size: 11))
//                Spacer()
//            }.padding(.horizontal).padding(.leading, 5)
//           
//
//        }// Top Vstack
//        
//    }
//} // SearchBar
//
//struct MidView : View {
//    var body: some View {
//        GeometryReader { geometry in
//            
//            VStack(){
//                Spacer()
//                // 상권지도 컴포넌트
//                NavigationLink (destination: BDMapView()) {
//                    HStack {
//                        Spacer()
//                        VStack (alignment: .leading) {
//                            Text("상권 지도")
//                                .font(.system(size: 22))
//                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                                .foregroundColor(Color(hex: "767676"))
//                                .padding(2)
//                            Text("주변 상권을 한 눈에!")
//                                .font(.system(size: 12))
//                                .foregroundColor(Color(hex: "93C73D"))
//                                .padding(3)
//                        }
//                        Spacer()
//                        
//                        Spacer()
//                        Spacer()
//                        Spacer()
//                        CDMIconOrLoadingView()
//                        
//                        Spacer()
//                    }
//                    .padding(20)
//                    .frame(width: geometry.size.width * 0.93 , height: geometry.size.height / 5 * 2)
//                    .background(Color.white) // 전체 VStack의 배경색 설정
//                        .cornerRadius(5) // 모서리 둥글게
//                        .shadow(color: Color.black.opacity(0.2), radius: 1, x: 1, y: 1) // 그림자 효과 추가
//                }
//                
//                
//                // 맞춤 추천 받기
//                NavigationLink (destination: ChooseBorough()) {
//                    HStack {
//                        
//                        Spacer()
//                        VStack (alignment: .leading) {
//                            Text("맞춤 추천 받기")
//                                .font(.system(size: 22))
//                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                                .foregroundColor(Color(hex: "767676"))
//                                .padding(2)
//                            Text("개인별 맞춤 추천 서비스!")
//                                .font(.system(size: 12))
//                                .foregroundColor(Color(hex: "93C73D"))
//                                .padding(3)
//                        }
//                        Spacer()
//                        Spacer()
//                        CRIconOrLoadingView()
//                        Spacer()
//                    }
//                    .padding(20)
//                    .frame(width: geometry.size.width * 0.93 , height: geometry.size.height / 5 * 2)
//                    .background(Color.white) // 전체 VStack의 배경색 설정
//                        .cornerRadius(5) // 모서리 둥글게
//                        .shadow(color: Color.black.opacity(0.2), radius: 1, x: 1, y: 1) // 그림자 효과 추가
//                } // 맞춤추천 컴포넌트 끝
//                
//                Spacer()
//                
//            } // VStack
//        } // geometry
//        
//    }
//}
//
//struct BottomView : View {
//    var colorScheme: ColorScheme // ColorScheme 타입의 변수 추가
//    
//    var body: some View {
//        
//        GeometryReader { geometry in
//            VStack {
//                HStack{
//                    Text("TOP 10").font(.title).foregroundColor(Color.red)
//                    Text("상권").font(.title).foregroundColor(colorScheme == .dark ? .white : .black)
//                    Text("(월 단위)").font(.caption2).foregroundColor(Color(hex: "767676"))
//                    Spacer()
//    //                        NavigationLink (destination: GraphTestView()) {
//    //                            Text("더보기 >").font(.caption)
//    //                                .foregroundColor(Color(hex: "767676"))
//    //                                .padding(3)
//    //                        }
//                }.padding(.horizontal) // HSTACK
//                
//                ScrollView(.horizontal) {
//                    HStack(alignment: .center, spacing: 10) {
//                        ForEach(1 ... 10, id : \.self) { number in
//                            VStack(spacing: 0){
////                                Text("\(number) 등")
////                                    .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
////                                    .background(.mint)
////                                    .cornerRadius(5)
//                                RecommendBoroughCard().frame(width: geometry.size.width / 3, height: geometry.size.height / 2 * 3)
//                            }
//                        }
//                    }
//                }.padding(.horizontal) // SCROLL
//            } // TOP 10 VSTAC
//        }
//        
//    }
//}
//
//
//struct HomeView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Environment(\.colorScheme) var colorScheme // 다크모드 or 라이트모드
//    @Query private var items: [Item]
//    @State private var searchText : String = ""
//private var showNavigationBar = false
//    var body: some View {
//        
//            
//            GeometryReader{ geometry in
//                VStack(alignment: .center){ // 세로축
//                    HStack{
//                        
//                    }.frame(height: geometry.size.height / 90)
//                    HStack { // VStack을 중앙에 위치시키기 위해 HStack 사용
//                        Spacer() // 왼쪽에 Spacer 추가
//                        VStack {
//                            // 상단 소개페이지
//                            TopView(colorScheme: colorScheme).frame(width: geometry.size.width / 100 * 97) // colorScheme 정보를 TopView에 전달
//                            // 검색창
//                            SearchBar(searchText: $searchText).frame(width: geometry.size.width / 100 * 97).padding(.top , geometry.size.height / 50)
//                            // 상권 지도
//                            HStack{
//                                Spacer()
//                                Spacer()
//                                Spacer()
//                                MidView().frame(width: geometry.size.width / 100 * 96)
//                                Spacer()
//                            }
//                        }
//                        .frame(width: geometry.size.width * 0.98) // Vstack 너비 조정
//                        Spacer() // 오른쪽에 Spacer 추가
//                        Spacer() // 오른쪽에 Spacer 추가
//                    } // HStack
//                    .frame(height: geometry.size.height / 5 * 3 )
//                    
//                    HStack{
//                        Spacer()
//                        VStack{
//                            // Top10
//                            BottomView(colorScheme: colorScheme)
//                        }.frame(width: geometry.size.width * 0.99)
//                    }.frame(width: geometry.size.width / 100 * 98, height: geometry.size.height / 20 * 5)
//                    Spacer()
//                    
//                }
//                .background(Color(hex: "F4F5F7")) // Vstack
//                    
//                
//                
//            } // Geometry
//    }// body
//} // HomeView


//struct ResponseData: Codable {
//    let apartmentComplexes: [ApartmentComplex]?
//    let aptAvgArea: Double?
//    let aptAvgPrice: Double?
//    let areaGraph: [AreaGraph]?
//    let priceGraph: PriceGraph?
//}
//
//// apartmentComplexes 배열에 해당하는 모델
//struct ApartmentComplex: Codable {
//    // 여기에 ApartmentComplex에 해당하는 프로퍼티를 정의합니다.
//    // 예시: let name: String
//}
//
//// areaGraph 배열에 해당하는 모델
//struct AreaGraph: Codable {
//    // 여기에 AreaGraph에 해당하는 프로퍼티를 정의합니다.
//    // 예시: let area: String
//}
//
//// priceGraph에 해당하는 모델
//struct PriceGraph: Codable {
//    let chartType: String
//    let data: GraphData
//}
//
//// priceGraph 내의 data에 해당하는 모델
//struct GraphData: Codable {
//    let categories: [String]
//    let series: [Series]
//}
//
//// series 배열에 해당하는 모델
//struct Series: Codable {
//    let name: String
//    let data: [Int]
//}
struct ResponseData: Codable {
    var priceGraph: PriceGraph?
}

struct PriceGraph: Codable {
    var chartType: String?
    var data: GraphData?
}

struct GraphData: Codable {
    var categories: [String]?
    var series: [Series]?
}

struct Series: Codable {
    var name: String?
    var data: [Int]?
}


struct testView : View{
    @State private var responseData: ResponseData? = nil

        var body: some View {
            
  if let responseData = responseData,
                          let categories = responseData.priceGraph?.data?.categories,
                          let seriesData = responseData.priceGraph?.data?.series?.first?.data {
      HStack{
          Text("아파트 가격별 세대수").font(.title).fontWeight(.bold).padding(.leading,15)
          Spacer()
      }
                           Chart {
                               ForEach(categories.indices, id: \.self) { index in
                                   if index < seriesData.count { // 카테고리와 시리즈 데이터의 인덱스를 맞춥니다.
                                       BarMark(
                                           x: .value("Category", categories[index]),
                                           y: .value("Count", seriesData[index])
                                       )
                                   }
                               }
                           } // 차트 제목을 추가합니다.
                           .frame(height: 300)
                           .padding()
                       } else {
                           Text("데이터를 불러오는 중...")
                       }
            
            
            Button(action: {
            }) {
                Text("보툰")
            }.onAppear{
                guard let url = URL(string: "http://192.168.31.199:8084/api/infra/graph/apt/price?commercialDistrictCode=3110981") else { return }
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        // 요청 실패 시 수행할 작업
                        print("Error: \(error)")
                        return
                    }
                    
                    guard let data = data else {
                        print("No data received")
                        return
                    }
                    
                    // 요청 성공 시 수행할 작업
                    print("Response Data: \(data)")
                    
                    let decoder = JSONDecoder()
                    do {
                        let responseData = try decoder.decode(ResponseData.self, from: data)
                        // 성공적으로 디코딩된 경우, responseData를 사용하여 필요한 작업을 수행합니다.
//                        print(responseData)
//                        print("넥슬라이스")
//                        print(responseData.priceGraph?.data?.categories)
                        DispatchQueue.main.async {
                            // UI 업데이트나 메인 스레드에서 실행해야 하는 작업
                            self.responseData = responseData
                        }
                    } catch {
                        print(error)
                    }
                    
                }.resume()
            }
        }
}
