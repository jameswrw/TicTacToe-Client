import SwiftUI
import SwiftData

@main struct MyApp: App {
    @State private var session = Session()
    @State private var server = Server(baseURL: URL(string: TicTacToeAPI.baseURL.rawValue)!)
    
    var body: some Scene {
        WindowGroup {
            ContentView(session: session)
                .environment(session)
                .environment(server)
        }
        .modelContainer(for: [Player.self, Match.self])
    }
}
