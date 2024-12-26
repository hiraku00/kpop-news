import SwiftUI
import FirebaseCore

@main
struct kpop_newsApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
