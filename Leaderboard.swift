import SwiftUI

struct Leaderboard: View {
    var current: Player
    var players: [Player] = []
    
    init(current: Player) {
        self.current = current
    }
    
    mutating func setPlayers(all: [Player]) {
        self.players = all.sorted { $0.score() > $1.score() }
    }
    
    func playerScore() -> String {
        let points = self.current.score()
        var score = "You have \(points) point"
        if points != 1 {
            score += "s"
        }
        return score
    }
    
    var body: some View {
        VStack {
            Text("Leaderboard(\(self.playerScore()))")
            ForEach(self.players) { player in
                HStack {
                    Text(player.name)
                    Spacer()
                    Text(String(player.score()))
                }
            }
        }
        .padding()
    }
}
