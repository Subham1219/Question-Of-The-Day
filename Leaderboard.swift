import SwiftUI

struct Leaderboard: View {
    var current: Player
    var players: [Player] = []
    
    init(current: Player) {
        self.current = current
    }
    
    mutating func setPlayers(all: [Player]) {
        self.players = all.sorted { (p1, p2) -> Bool in
            return p1.score() > p2.score()
        }
    }
    
    func playerPosition(player: Player) -> String {
        for (i, leaderboard_player) in self.players.enumerated() {
            if leaderboard_player.name == player.name {
                return String(i + 1)
            }
        }
        return "Unknown"
    }
    
    func playerScore(player: Player) -> String {
        return String(player.score())
    }
    
    var body: some View {
        VStack {
            Text("Leaderboard:")
                .font(.headline)
            HStack {
                Text(self.playerPosition(player: self.current))
                Text("You")
                Spacer()
                Text(self.playerScore(player: self.current))
            }
            Divider()
            ScrollView {
                ForEach(self.players) { player in
                    HStack {
                        Text(self.playerPosition(player: player))
                        Text(player.name)
                        Spacer()
                        Text(self.playerScore(player: player))
                    }
                }
            }
        }
        .padding()
    }
}
