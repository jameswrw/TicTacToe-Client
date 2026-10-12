import SwiftUI

@main struct MyApp: App {
    @State private var session = Session()
    var body: some Scene {
        WindowGroup {
            ContentView(session: session)
                .environment(session)
        }
    }
}
