import SwiftUI
import SwiftData

@main
struct SangChooApp: App {
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
        }.tint(Color("sangchoo"))
    }
}
