import SwiftUI
import Playgrounds
import Dependencies

struct ContentView: View {
    @Environment(Session.self) var session
    @State private var opponentListViewModel: OpponentListViewModel
    @State private var matchListViewModel: MatchListViewModel
    @Dependency(\.server) private var baseServer

    init(session: Session) {
        self._opponentListViewModel = State(initialValue: OpponentListViewModel(session: session))
        self._matchListViewModel = State(initialValue: MatchListViewModel(session: session))
    }
    
    var loginViewModel: LoginViewModel {
        LoginViewModel(session: session)
    }
    var boardViewModel: BoardViewModel {
        BoardViewModel(session: session)
    }

    var body: some View {
        
        let authenticatedServer = Server(
            baseURL: baseServer.baseURL,
            accessToken: session.accessToken
        )
        
        NavigationSplitView(
            sidebar: {
                VStack {
                    // Display currently logged-in player from session
                    if let player = session.currentPlayer {
                        Text("Logged in as: \(player.firstName) \(player.lastName)")
                            .padding(.bottom, 8)
                    }
                    LoginView(
                        viewModel: loginViewModel,
                        playerViewModel: opponentListViewModel
                    )
                    OpponentListView(viewModel: opponentListViewModel)
                }
            }, content: {
                if session.opponent != nil {
                    MatchListView(viewModel: matchListViewModel)
                } else {
                    EmptyView()
                }
            }, detail: {
                if let _ = session.match {
                    BoardView(viewModel: .init(session: session))
                } else {
                    EmptyView()
                }
            }
        )
        .dependency(\.server, authenticatedServer)
    }
}

#Preview {
    @Previewable @Environment(Session.self) var session
    ContentView(session: session)
}

#Playground {
    _ = 1 + 2
}
