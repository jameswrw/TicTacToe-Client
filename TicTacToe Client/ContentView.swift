import SwiftUI
import Playgrounds

struct ContentView: View {
    @Environment(Session.self) var session
    @State private var opponentListViewModel = OpponentListViewModel()

    var loginViewModel: LoginViewModel {
        LoginViewModel(session: session)
    }
    var matchListViewModel: MatchListViewModel {
        MatchListViewModel()
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
                    PlayerListView(viewModel: opponentListViewModel)
                }
            }, content: {
                if opponentListViewModel.playerSelection != nil {
                    MatchListView(viewModel: matchListViewModel)
                } else {
                    EmptyView()
                }
            }, detail: {
                if matchListViewModel.matchSelection != nil {
                    BoardView(viewModel: boardViewModel)
                } else {
                    EmptyView()
                }
            }
        )
    }
}

#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
