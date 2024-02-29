import SwiftUI

struct Leaderboard: View {
    var current: Player
    var players: [Player] = []
    
    init(current: Player) {
        self.current = current
    }
    
    mutating func setPlayers(all: [Player]) {
        self.players = all.sorted { (p1, p2) -> Bool in
            let p1_score = p1.score()
            let p2_score = p2.score()
            if p1_score != p2_score {
                return p1_score > p2_score
            }
            if p1.answers.count < 1 {
                return true
            }
            if p2.answers.count < 1 {
                return false
            }
            guard let p1_date = TimeFormatter.date(from: p1.answers.last!.time) else {
                return true
            }
            guard let p2_date = TimeFormatter.date(from: p2.answers.last!.time) else {
                return false
            }
            return p1_date < p2_date
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

