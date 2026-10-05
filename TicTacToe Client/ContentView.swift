import SwiftUI
import Playgrounds

struct ContentView: View {
    var body: some View {
        VStack {
            PlayerListView()
            MatchListView()
            BoardView()
        }
    }
}

#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
