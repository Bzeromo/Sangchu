import SwiftUI
import SwiftData

@main
struct SangChuApp: App {

    @AppStorage("isFirstTimeLaunch") private var isFirtTimeLaunch: Bool = true // 처음 로그인했는지 판별
    
    init() {
        // indicatort 색 조정
//        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.sangchu
//        UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.5)
        // NavigationBar 색 조정
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .modelContainer(sharedModelContainer) // 초기값
//                .modelContainer(for: BookMarkItem.self) // ItemContainer로 묶기 전
                .modelContainer(ItemsContainer.create(shouldCreateDefaults: &isFirtTimeLaunch)) // 묶은 후
//                .accentColor(Color("sangchu"))
        }
    }
}

struct ContentView: View {
    @State private var showMainView = false
    
    
    var body: some View {
        ZStack{
            if showMainView {
                NavigationStack{
                    HomeView()
                }
            } else {
                SplashView().onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        withAnimation{
                            showMainView = true
                        }
                    }
                }
            }
        }
        
        
       
    }
}
// 이전 코드
//            TabView(selection: $selectedTab) {
//                HomeView().tabItem {
//                    Label("홈", systemImage: "house")
//                }
//                .tag("홈")
//
//
//                BookMarkTabView()
//                    .tabItem {
//                        Label("북마크", systemImage: "bookmark")
//                    }
//                    .tag("북마크")
//
//                SampleMain().tabItem {
//                    Label("연습", systemImage: "xmark")
//                }
//                .tag("연습")
//            }.tint(Color("sangchu"))
