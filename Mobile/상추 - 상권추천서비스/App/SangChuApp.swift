import SwiftUI
import SwiftData
import NMapsMap
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate, NMFAuthManagerDelegate { // NMFAuthManagerDelegate 프로토콜을 채택합니다.

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 클라이언트 ID를 설정합니다. 잘못된 ID일 경우 인증에 실패합니다.
        NMFAuthManager.shared().clientId = "pghigxr727"
        // NMFAuthManager의 delegate로 self(이 클래스의 인스턴스)를 지정합니다. 이렇게 함으로써 인증 관련 이벤트를 처리할 수 있습니다.
        NMFAuthManager.shared().delegate = self
        return true
    }
    
    func authorized(_ state: NMFAuthState, error: Error?) {
        switch state {
        case .authorized: // 인증에 성공했을 때
            print("인증 성공")
        case .unauthorized: // 인증에 실패했을 때
            if let error = error {
                print("인증 오류: \(error.localizedDescription)")
            }
        @unknown default: // 알 수 없는 새로운 상태가 추가되었을 경우 대비
            print("알 수 없는 인증 상태입니다. 상태: \(state)")
            // 여기서 추가적인 안전 조치를 취할 수 있습니다.
        }
    }
}


@main
struct SangChuApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // NaverMap 활용을 위함
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Item.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
        }
    }
}

struct ContentView: View {
    @State private var selectedTab = "홈"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView().tabItem {
                Label("홈", systemImage: "house")
            }
            .tag("홈")
            
            BookMarkView()
                .tabItem {
                    Label("북마크", systemImage: "bookmark")
                }
                .tag("북마크")
        }.tint(Color.sangchu)
    }
}
