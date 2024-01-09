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
            return true // fix
        })
    }
    
    func find(name: String) -> Player? {
        for player in self.players {
            if player.name == name {
                return .some(player)
            }
        }
        return .none
    }
    
    var body: some View {
        Text("Hello")
    }
}
