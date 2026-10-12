import SwiftUI
import Playgrounds

struct ContentView: View {

    let loginViewModel = LoginViewModel()
    let playerListViewModel = PlayerListViewModel()
    let matchListViewModel = MatchListViewModel()
    let boardViewModel = BoardViewModel(board: "..XOO..XX")

    var body: some View {
        NavigationSplitView(
            sidebar: {
                VStack {
                    LoginView(
                        viewModel: loginViewModel,
                        playerViewModel: playerListViewModel
                    )
                    PlayerListView(viewModel: playerListViewModel)
                }
            }, content: {
                if playerListViewModel.playerSelection != nil {
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
