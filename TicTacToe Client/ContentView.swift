import SwiftUI
import Playgrounds

struct ContentView: View {

    let loginViewModel = LoginViewModel()
    let playerListViewModel = PlayerListViewModel()
    let matchListViewModel = MatchListViewModel()
    let boardViewModel = BoardViewModel(board: "..XOO..XX")

    var body: some View {
        VStack {
            LoginView(viewModel: loginViewModel)
            PlayerListView(viewModel: playerListViewModel)
            if playerListViewModel.playerSelection != nil {
                MatchListView(viewModel: matchListViewModel)
                if matchListViewModel.matchSelection != nil {
                    BoardView(viewModel: boardViewModel)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
