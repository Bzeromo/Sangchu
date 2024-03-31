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
    // Scroll 위치 인식에 사용
    @StateObject private var viewModel: ViewModel = ViewModel()
    // SwiftData에 사용
    @Environment(\.modelContext) var context
    @Query private var items: [BookMarkItem]
    // SwiftData 사용 끝
    @State var gradiant = [Color(hex: "37683B"), Color(hex: "529B58")]// 사용할 그라디언트 색상 배열

    
    let MainColors: [Color] = [Color(hex: "50B792"),Color(hex: "3B7777")]
    
    let gradientColors: [Color] = [Color(hex: "FF8080"),Color(hex: "FFA680"),Color(hex: "FFBF80"),Color(hex: "FFD480"),Color(hex: "FFE680"),Color(hex: "F4FF80"),Color(hex: "D5FF80"),Color(hex: "A2FF80"),Color(hex: "80FF9E"),Color(hex: "80FFD5"),Color(hex: "80EAFF"),Color(hex: "80A6FF"),Color(hex: "8A80FF"),Color(hex: "BF80FF"),Color(hex: "FD80FF"),Color(hex: "FF8097")]
   
    let topColors: [Color] = [Color(hex: "87CC6C"),Color(hex: "6DBCCD"),Color(hex: "C078D2")]
    
  
    
    let numberTop: [Color] = [Color(hex: "F5DC82"),Color(hex: "FDFF93"),Color(hex: "F6F339"),Color(hex: "93C73D")]
    let numberBottom: [Color] = [Color(hex: "E36AD4"),Color(hex: "F45E35"),Color(hex: "86D979"),Color(hex: "F0F2ED")]

    @State var Top10 : [HomeModel.CommercialDistrict]? = nil
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
            
            
            
            VStack{
                
//                ZStack{
//                    VStack{
//                        let offset = $viewModel.offset //  기본값은 47 원하는 액션은 양수
//                        let scaleFactor = max(1.15, 1.15 + offset.wrappedValue / 380)
//                        let offsetFactor = min(-28, -28 - offset.wrappedValue * 0.8)
//                        // 위로하면 양수, 아래로 하면 음수
//                        Image(uiImage: UIImage(named: "Main.png")!)
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .scaleEffect(scaleFactor) // 스크롤에 따라 크기 늘림
//                            .frame(alignment: .top)
//                            .offset(y: offsetFactor)
//                        Spacer()
//                    }
//
//                    LinearGradient(colors: gradiant, startPoint: .bottom, endPoint: .top).frame(height : 150)
//                    .frame(maxHeight: .infinity, alignment: .bottom)
//
//                    VStack(alignment: .center){
//                        HStack{
//                            Spacer()
//                            Button(action: {}) {
//                                Image(systemName: "magnifyingglass.circle")
//                                    .resizable()
//                                    .frame(width: 30, height: 30)
//                                    .foregroundColor(.black) // 버튼의 크기를 지정합니다.
//                            }.padding(.top, 40).padding(.trailing,20)
//                        }
//                        Spacer()
//                        VStack(spacing: 7){
//                            Text("상추")
//                                .font(.system(size: 17))
//                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                            //                                    .foregroundColor(Color(hex: "767676"))
//                                .foregroundColor(Color.white)
//                            Text("맞춤형 분석 서비스를")
//                                .font(.system(size: 25))
//                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                            //                                    .foregroundColor(Color(hex: "767676"))
//                                .foregroundColor(Color.white)
//                            Text("체험해보세요")
//                                .font(.system(size: 25))
//                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                                .foregroundColor(Color.white)
//                            NavigationLink(destination: ChooseBorough()) {
//                                Text("무료체험")
//                                    .font(.system(size: 17))
//                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                                    .padding()
//                                    .frame(width: UIScreen.main.bounds.width * 0.78)
//                                    .background(Color.white)
//                                    .foregroundColor(Color("sangchu"))
//                                    .cornerRadius(10)
//                            }
//                        }.padding(.bottom,20)
//
//                    }
//                }.frame(height: 500)
                
                // 여기서부터 지우면댐
                ZStack{
                    VStack{
                        let offset = $viewModel.offset //  기본값은 47 원하는 액션은 양수
                        let scaleFactor = max(1.15, 1.15 + offset.wrappedValue / 380)
                        let offsetFactor = min(-29, -29 - offset.wrappedValue * 0.8)
                        // 위로하면 양수, 아래로 하면 음수
                        Image(uiImage: UIImage(named: "Main2.png")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(scaleFactor) // 스크롤에 따라 크기 늘림
                            .frame(alignment: .top)
                            .offset(y: offsetFactor)
                        Spacer()
                    }
                    
                    LinearGradient(colors: [Color(hex: "434343"), Color(hex: "434343").opacity(0)], startPoint: .bottom, endPoint: .top).frame(height : 200)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    
                    VStack(alignment: .center){
                        HStack{
                            Spacer()
                            Button(action: {}) {
                                Image(systemName: "magnifyingglass.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.black) // 버튼의 크기를 지정합니다.
                            }.padding(.top, 40).padding(.trailing,20).hidden() // 검색기능 만들고 숨김해제
                        }
                        Spacer()
                        VStack(spacing: 7){
                            Label(
                                title: { Text("상 추") },
                                icon: { Image(systemName: "leaf.fill") }
                            )
                                .font(.system(size: 18))
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .foregroundColor(Color(hex: "F2EADA"))
                                .padding(.bottom, 5)
                           
                            Spacer()
                            Text("창업 초보자를 위한")
                                .font(.system(size: 18))
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .foregroundColor(Color.white)
                            
                            //                                    .foregroundColor(Color(hex: "767676"))
                                .foregroundColor(Color.white)
                            Text("서울시 요식업 상권 분석 서비스")
                                .font(.system(size: 18))
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .foregroundColor(Color.white)
                            NavigationLink(destination: ChooseBorough()) {
                                Text("지금 시작하기")
                                    .font(.system(size: 18))
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .padding()
                                    .frame(width: UIScreen.main.bounds.width * 0.74 ,height: 40)
                                    .background(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                                    .foregroundColor(Color.white)
                                    .cornerRadius(20)
                            }
                        }.padding(.bottom,20)
                        
                    }
                }.frame(height: 500)
                
                // 여기까지 VStack은 남겨
            }
            
            Spacer().frame(height: 20)
            
            // Top10 서울 상권 Section
            Section(header: HStack(alignment: .bottom, spacing: 5){
                Text("서울시 상권").font(.title2).fontWeight(.semibold).foregroundColor(.black).padding(.leading , 20)
                    Text("Top 10").font(.title2).fontWeight(.semibold).foregroundStyle( LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                
              
                Spacer()
                NavigationLink(destination: BDMapView()) {
                    
                        
                        Label(
                            title: { Text("지도 >") },
                            icon: { Image(systemName: "map.fill") }
                        )
                            .fontWeight(.medium)
                            .font(.system(size: 14)) // 텍스트 크기
                            .padding(.trailing, 20) // 오른쪽 패딩
                            .foregroundStyle( LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                    
                  
                    
                    
                           }
            }
            )  {
                HStack{
                    Text("서울에서 뜨고있는 상권을 한눈에!").font(.system(size: 14)).foregroundColor(.gray).padding(.leading , 20)
                    Spacer()
                }
                ScrollView(.horizontal){
                    LazyHStack{
                        if let top10 = Top10 {
                            // 배열이 비어 있지 않은 경우에만 내부 로직 실행
                            if !top10.isEmpty {
                                ForEach(Array(zip(top10.indices, top10)), id: \.0) { index, district in
                                    NavigationLink(destination: BDMapView(cameraLatitude: district.longitude, cameraLongitude: district.latitude, selectedCDCode: String(district.commercialDistrictCode), selectedCDName: district.commercialDistrictName)){
                                        ZStack {
                                            VStack{
                                                Text("👑\(index + 1)위").foregroundColor(Color(hex: "FBD256")).fontWeight(.bold).font(.system(size : 28))
                                            }
                                            .offset(x:100,y:-63)
                                            
                                            
                                             VStack(alignment: .leading){
                                                        
                                                        VStack{
                                                            HStack{
                                                                Text("\(Int(district.commercialDistrictScore))점").font(.title).foregroundColor(Color.white).fontWeight(.bold)
                                                                Spacer()
                                                            }
                                                            
                                                            HStack{
                                                                Text(district.commercialDistrictName).font(.title3).fontWeight(.bold).foregroundColor(.white.opacity(0.7)).lineLimit(1)
                                                                Spacer()
                                                            }
                                                        }.padding(.leading , 10).padding(.top, 10)
                                                       
//                                                        HStack{
//                                                            VStack(alignment: .leading){
//                                                                Text("매출점수").font(.caption)
//                                                                Text("상주인구점수").font(.caption)
//                                                                Text("유동인구점수").font(.caption)
//                                                                Text("다양성").font(.caption)
//                                                            }.hidden()
//                                                            VStack(alignment: .leading){
//                                                                Text("\(Int(district.salesScore))").font(.caption)
//                                                                Text("\(Int(district.residentPopulationScore))").font(.caption)
//                                                                Text("\(Int(district.floatingPopulationScore))").font(.caption)
//                                                                Text("\(Int(district.rdiScore))").font(.caption)
//                                                            }.hidden()
//                                                        }
                                                        Spacer()
                                                        HStack{
                                                           Spacer()
                                                            VStack(alignment: .center){
                                                                LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing).mask(
                                                                    Text("자세히").font(.system(size : 14)).fontWeight(.semibold
                                                                )
                                                                )
                                                            }.frame(width: UIScreen.main.bounds.width * 0.2, height : 28).background(Color.white.opacity(0.7)).cornerRadius(50).padding(.trailing , 10)
                                                        }
                                                    }.frame(maxWidth: .infinity)
                                            
                                            
                                        }
                                    }
                                    .scrollTransition{ content, phase in
                                            content
                                                .opacity(phase.isIdentity ? 1.0 : 0.5) // 그전의 것이 연하게됨
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.8, height : 180)
                                    .padding()
                                    .background(LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing)) // Top배경
//                                    .foregroundColor(.white)
                                    .cornerRadius(35)
                                }
                            } else {
                                // 배열이 비어 있는 경우
                                Text("데이터가 없습니다.")
                                    .padding()
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        } else {
                            // Top10이 nil인 경우
                            Text("준비중")
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }.scrollTargetLayout()
                   
                }
                .safeAreaPadding(.horizontal,15)
                .contentMargins(10, for: .scrollContent)
                .scrollTargetBehavior(.paging) // 알맞게 페이징됨,
                .scrollIndicators(.hidden) // 밑에 바 숨겨줌
            }
            Divider().background(Color.gray.opacity(0.3)) // 절취선의 색상과 투명도를 설정합니다.
                .padding(.leading, 20).padding(.top, 20)
            
            // 자치구별 Top 상권 Section
            Section(header: HStack(alignment: .bottom, spacing: 5){
                
                    Text("자치구별").font(.title2).fontWeight(.semibold).foregroundColor(.black).padding(.leading , 20)
                    Text("Hot").font(.title2).fontWeight(.semibold).foregroundStyle( LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                    Text("상권 🔥").font(.title2).fontWeight(.semibold).foregroundColor(.black)
                
               
                Spacer()
            }
            )  {
                HStack{                    Text("우리 동네 상권의 랭킹은?").font(.system(size: 14)).foregroundColor(.gray).padding(.leading , 20)
                    Spacer()
                }
                BoroughTop10()
//                .safeAreaPadding(.horizontal,15)
//                .contentMargins(10, for: .scrollContent)
//                .scrollIndicators(.hidden) // 밑에 바 숨겨줌
            }
            Divider().background(Color.gray.opacity(0.3)) // 절취선의 색상과 투명도를 설정합니다.
                .padding(.leading, 20).padding(.top, 20)
            
            
            // 북마크 Section
            Section(header: HStack(alignment: .bottom,spacing: 5){
                Text("북마크").font(.title2).fontWeight(.semibold).foregroundColor(.black).padding(.leading , 20)
                Label(
                    title: { Text("") },
                    icon: { Image(systemName: "bookmark.fill") }
                )
                .font(.title2).fontWeight(.semibold)
                    .foregroundStyle( LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
            
                Spacer()
                NavigationLink (destination: BookMarkList()) {
                    Label(
                        title: { Text("전체보기 >") },
                        icon: { Image(systemName: "book.fill") }
                    )
                        .fontWeight(.medium)
                        .font(.system(size: 14)) // 텍스트 크기
                        .padding(.trailing, 20) // 오른쪽 패딩
                        .foregroundStyle( LinearGradient(colors: MainColors, startPoint: .leading, endPoint: .trailing))
                
                }
            }
            )  {
                
                    LazyVStack {
                        // 배열이 비어 있지 않은 경우에만 내부 로직 실행
                        if !items.isEmpty {
                            ForEach(0..<items.count, id: \.self) { index in
                                                   NavigationLink(destination: UpdateBookMarkView(item: items[index])) {
                                                       HStack(spacing: 0){
                                                           HStack{
                                                               Spacer()
                                                               Image(uiImage: UIImage(named: "AppIcon.png")!)
                                                                   .resizable()
                                                                   .frame(width: UIScreen.main.bounds.width * 0.18, height: UIScreen.main.bounds.width * 0.18, alignment: .center)
                                                                   .clipShape(Circle()) // 동그랗게 잘라주기
                                                               Spacer()
                                                           }
                                                           .frame(width : UIScreen.main.bounds.width * 0.24)
                                                           VStack(alignment: .leading, spacing: 1){
                                                                Spacer()
                                                               HStack{
                                                                   Text("\(items[index].cdTitle)").foregroundColor(.black).lineLimit(1).fontWeight(.semibold)
                                                                   Spacer()
                                                               }
                                                               HStack{
                                                                   
                                                                   if items[index].userMemo == "" {
                                                                       Text("작성된 메모가 없습니다").foregroundColor(Color(hex:"c6c6c6")).lineLimit(1).fontWeight(.medium).font(.caption)
                                                                   } else {
                                                                       Text("\(items[index].userMemo)").foregroundColor(Color(hex:"c6c6c6")).lineLimit(1).fontWeight(.medium)
                                                                           .font(.caption)
                                                                   }
                                                                   
                                                                   Spacer()
                                                               }
                                                                   
                                                                   
                                                                   
                                                               HStack{
                                                                   Text("\(items[index].timestamp,format: Date.FormatStyle(date:.numeric, time:.none))").foregroundColor(Color(hex:"c6c6c6")).lineLimit(1).fontWeight(.medium).font(.caption)
                                                                   Spacer()
                                                               }
                                                                   Spacer()
                                                           }.frame(maxWidth : .infinity)
                                                           HStack {
                                                               Image(systemName: "chevron.right")
                                                                   .foregroundStyle(LinearGradient(colors: MainColors, startPoint: .top, endPoint: .bottom)) // 여기서 원하는 색상으로 변경하세요.
                                                                   .font(.system(size:24))
                                                               Spacer()
                                                           }.frame(width : UIScreen.main.bounds.width * 0.1)

                                                       }
                                                       .frame(width : UIScreen.main.bounds.width * 0.9, height : 90)
                                                       .background(Color.white)
                                                       .cornerRadius(35)
                                                   }
                                       
                                   }
                        }
                    }
                
                   
                
//                .scrollTargetBehavior(.paging) // 알맞게 페이징됨,
//                .scrollTargetBehavior(.viewAligned) // 알맞게 페이징됨,
            }
            Divider().background(Color.gray.opacity(0.3)) // 절취선의 색상과 투명도를 설정합니다.
                .padding(.leading, 20).padding(.top, 20)
                // 하단 네비바들
                
            
            
            
            
        } // 전체를 담은 ScrollView
        .ignoresSafeArea(.all)
        .onPreferenceChange(ScrollOffsetKey.self) {
            viewModel.setOffset($0)
        }.background(Color(hex: "F4F5F7"))
            .onAppear {
                TopDecode()
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
    
    // 스크롤뷰 이미지 동적 전환을 위함
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
    
    func TopDecode() {
        HomeNetworkManager.shared.fetch(endpoint: "/commdist/top") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    print("저녁")
                    do {
                        // HomeModel.CommercialDistricts 타입으로 디코딩 수정
                        print("아침")
                        let decodedTop10 = try JSONDecoder().decode([HomeModel.CommercialDistrict].self, from: data)
                        print("점심")
                        Top10 = decodedTop10
                        print("저녁")
                        
                    } catch {
                        print("Decoding error: \(error)")
                    }
                case .failure(let error):
                    print("Fetch error: \(error)")
                }
            }
        }
    }
    
}
