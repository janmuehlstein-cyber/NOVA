import SwiftUI

@main
struct NOVAPulseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}

struct ContentView: View {
    var body: some View {
        CalendarWebView()
            .ignoresSafeArea(edges: .bottom)
    }
}
