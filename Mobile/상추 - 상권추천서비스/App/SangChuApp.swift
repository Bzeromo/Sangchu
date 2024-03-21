import SwiftUI
import SwiftData

@main
struct SangChuApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([Item.self])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }() // 초기 설정값들
    
    @AppStorage("isFirstTimeLaunch") private var isFirtTimeLaunch: Bool = true // 처음 로그인했는지 판별
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .modelContainer(sharedModelContainer) // 초기값
//                .modelContainer(for: BookMarkItem.self) // ItemContainer로 묶기 전
                .modelContainer(ItemsContainer.create(shouldCreateDefaults: &isFirtTimeLaunch)) // 묶은 후
        }
    }
}

struct ContentView: View {
    @State private var selectedTab = "홈"
    
    var body: some View {
        NavigationStack{
            
            TabView(selection: $selectedTab) {
                HomeView().tabItem {
                    Label("홈", systemImage: "house")
                }
                .tag("홈")
                
                
                BookMarkTabView()
                    .tabItem {
                        Label("북마크", systemImage: "bookmark")
                    }
                    .tag("북마크")
                
                SampleMain().tabItem {
                    Label("연습", systemImage: "xmark")
                }
                .tag("연습")
            }.tint(Color("sangchu"))
        }
       
    }
}

struct SampleMain: View {
    
//    @State var gradiant = [Color(hex: "93C73D").opacity(0),Color(hex: "93C73D").opacity(0.5),Color(hex: "93C73D").opacity(0.7),Color(hex: "93C73D").opacity(0.7), Color(hex: "93C73D")]
    
    @State var gradiant = [Color(hex: "37683B"), Color(hex: "529B58")]
    
    var body: some View {
        ScrollView(.vertical) {
            GeometryReader { geometry in
                let offset = geometry.frame(in: .global).minY
                let scaleFactor = max(1, 1 - (-offset / 500)) // 위로하면 음수, 아래로 하면 양수
                                
                VStack {
                    ZStack{
                        Image(uiImage: UIImage(named: "AppIcon.png")!)
                            .resizable()
//                                                    .aspectRatio(contentMode: .fit)
                                                    .scaleEffect(scaleFactor) // 스크롤에 따라 크기 늘림
                            .frame(alignment: .top)
                            .offset(y: offset * -0.6)
                        
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
                        
                    }.frame(height: 600) // 상단 사진과 글귀
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
                    )
                    
                    // 검색창
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
            }
        }
        .ignoresSafeArea(.all)
        .background(Color(hex: "F4F5F7")) // Vstack
        
    }
}
