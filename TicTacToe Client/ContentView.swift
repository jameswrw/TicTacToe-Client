import SwiftUI
import Playgrounds
import Dependencies
import SwiftData

struct ContentView: View {
    @Environment(Session.self) var session
    @Environment(\.modelContext) private var context
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
                    LoginView(viewModel: loginViewModel)
                    if session.currentPlayer != nil {
                        OpponentListView(viewModel: opponentListViewModel)
                    }
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
        // When the current player changes (i.e., login success), fetch opponents
        .onChange(of: session.currentPlayer) { _, newPlayer in
            guard let player = newPlayer else { return }
            Task {
                await opponentListViewModel.fetchOpponents(
                    playerID: player.id,
                    context: context,
                    server: authenticatedServer
                )
            }
        }
        // Also fetch on appear if already authenticated (e.g., returning users)
        .task(id: session.currentPlayer?.id) {
            if let player = session.currentPlayer {
                await opponentListViewModel.fetchOpponents(
                    playerID: player.id,
                    context: context,
                    server: authenticatedServer
                )
            }
        }
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
