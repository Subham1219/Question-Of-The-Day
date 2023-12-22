import SwiftUI

struct Leaderboard: Codable, View {
    var players: [Player]
    
    enum JSON: String, CodingKey {
        case players
    }
    
    init() {
        self.players = []
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: JSON.self)
        self.players = try container.decode([Player].self, forKey: .players)
    }
    
    func leaderboard() -> [Player] {
        return self.players.sorted(by: { (l, r) -> Bool in
            l.score > r.score
        })
    }
    
    func find(id: UUID) -> Player? {
        for player in self.players {
            if player.id == id {
                return .some(player)
            }
        }
        return .none
    }
    
    var body: some View {
        Text("Hello")
    }
}
