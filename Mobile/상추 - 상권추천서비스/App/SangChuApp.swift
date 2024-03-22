import SwiftUI
import SwiftData

@main
struct SangChuApp: App {

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
//    @State private var selectedTab = "홈"
    
    var body: some View {
        NavigationStack{
            HomeView().tint(Color("sangchu"))
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
