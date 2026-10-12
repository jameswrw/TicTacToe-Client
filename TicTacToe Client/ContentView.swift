import SwiftUI
import Playgrounds

struct ContentView: View {
    @Environment(Session.self) var session
    @State private var opponentListViewModel: OpponentListViewModel
    @State private var matchListViewModel: MatchListViewModel

    init(session: Session) {
        self._opponentListViewModel = State(initialValue: OpponentListViewModel(session: session))
        self._matchListViewModel = State(initialValue: MatchListViewModel(session: session))
    }
    
    var loginViewModel: LoginViewModel {
        LoginViewModel(session: session)
    }
    var boardViewModel: BoardViewModel {
        BoardViewModel(board: "..XOO..XX")
    }

    var body: some View {
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
                if session.match != nil {
                    BoardView(viewModel: boardViewModel)
                } else {
                    EmptyView()
                }
            }
        )
    }
}

#Preview {
    @Previewable @Environment(Session.self) var session
    ContentView(session: session)
}

#Playground {
    _ = 1 + 2
}
