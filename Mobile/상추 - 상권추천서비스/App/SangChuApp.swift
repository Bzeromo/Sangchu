import SwiftUI
import SwiftData

@main
struct SangChuApp: App {

    @AppStorage("isFirstTimeLaunch") private var isFirtTimeLaunch: Bool = true // 처음 로그인했는지 판별
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(ItemsContainer.create(shouldCreateDefaults: &isFirtTimeLaunch)) // 묶은 후
                .accentColor(Color(hex:"58b295"))
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
