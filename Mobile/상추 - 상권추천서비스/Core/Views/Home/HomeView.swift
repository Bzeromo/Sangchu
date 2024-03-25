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
    @State var gradiant = [Color(hex: "37683B"), Color(hex: "529B58")]
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
                                    .background(Color.white)
                                    .foregroundColor(Color("sangchu"))
                                    .cornerRadius(10)
                            }
                        }.padding(.bottom,20)
                        
                    }
                }.frame(height: 500)
            }
            
            Spacer().frame(height: 20)
            
            // Top10 서울 상권 Section
            Section(header: HStack(alignment: .bottom){
                Text("서울시 상권 Top 10").font(.title2).fontWeight(.semibold).foregroundColor(.black).padding(.leading , 20)
                Spacer()
                NavigationLink(destination: BDMapView()) {
                               Text("지도보러가기")
                                   .font(.system(size: 17)) // 텍스트 크기 설정
                                   .foregroundColor(Color("sangchu")) // Text Color를 지정합니다. "sangchu"는 Assets에 정의된 색상 이름이어야 합니다.
                                   .padding(.trailing, 20) // 오른쪽 패딩을 추가합니다.
                           }
            }
            )  {
                HStack{
                    Text("서울에서 뜨고있는 상권을 한눈에!").font(.system(size: 14)).foregroundColor(.gray).padding(.leading , 20)
                    Spacer()
                }
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack {
//                        
//                        if let top10 = Top10 {
//                            ForEach(top10) { s in
//                                Text(s.dongName)
//                            }
//                        } else {
//                            // Top10이 nil일 때 표시할 내용
//                            Text("데이터가 없습니다.")
//                        }
//                    }
//                }
                
                ScrollView(.horizontal){
                    HStack{
                        if let top10 = Top10 {
                            // 배열이 비어 있지 않은 경우에만 내부 로직 실행
                            if !top10.isEmpty {
                                ForEach(top10) { district in
                                    VStack{
                                        Text(district.commercialDistrictName)
                                        Text("\(district.commercialDistrictCode)")
                                    }
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
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
                    }.padding(.leading,20)
                }
            }
            Divider().background(Color.gray.opacity(0.3)) // 절취선의 색상과 투명도를 설정합니다.
                .padding(.leading, 20).padding(.top, 20)
            
            // 북마크 Section
            Section(header: HStack(alignment: .bottom){
                Text("북마크").font(.title2).fontWeight(.semibold).foregroundColor(.black).padding(.leading , 20)
                Spacer()
                NavigationLink (destination: BookMarkList()) {
                    Text("전체보러가기").font(.system(size: 17)).fontWeight(.regular).foregroundColor(Color("sangchu")).padding(.trailing , 20)
                }
            }
            )  {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack {
//
//                        if let top10 = Top10 {
//                            ForEach(top10) { s in
//                                Text(s.dongName)
//                            }
//                        } else {
//                            // Top10이 nil일 때 표시할 내용
//                            Text("데이터가 없습니다.")
//                        }
//                    }
//                }
                
                ScrollView(.horizontal) {
                    HStack {
                        // 배열이 비어 있지 않은 경우에만 내부 로직 실행
                        if !items.isEmpty {
                            ForEach(items) { Bookmark in
                                VStack {
                                    Text(Bookmark.cdTitle)
                                }
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .scrollTransition{ content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1.0 : 0.5) // 그전의 것이 연하게됨
                                    // 아래는 크기조절
                                        .scaleEffect(x : phase.isIdentity ? 1.0 : 0.3, y: phase.isIdentity ? 1.0 : 0.3)
                                        .offset(y:phase.isIdentity ? 0 : 50)
                                    
                                }
//                                .containerRelativeFrame(.horizontal, count : 4, spacing : 10)
                                
                            }
                        } else {
                            // 배열이 비어 있는 경우
                            Text("데이터가 없습니다.")
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }.padding(.leading,20)
                }
//                .scrollTargetBehavior(.paging) // 알맞게 페이징됨,
                .scrollTargetBehavior(.viewAligned) // 알맞게 페이징됨,
            }
            Divider().background(Color.gray.opacity(0.3)) // 절취선의 색상과 투명도를 설정합니다.
                .padding(.leading, 20).padding(.top, 20)
                // 하단 네비바들
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
                    
                }
            
            
            
            
        } // 전체를 담은 ScrollView
        
        //            .accentColor(Color("sangchu")) // 툴바 자식들 색상
        //            .navigationBarTitle("홈", displayMode: .inline)
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
