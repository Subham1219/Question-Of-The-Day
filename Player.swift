import SwiftUI

class Player: Codable, ObservableObject {
    @Published var name: String = UserDefaults.standard.string(forKey: "playerName") ?? "Guest"
    @Published var score: Int
    
    enum JSON: String, CodingKey {
        case score
    }
    
    init() {
        self.score = UserDefaults.standard.integer(forKey: "playerScore")
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: JSON.self)
        self.score = try values.decode(Int.self, forKey: .score)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: JSON.self)
        try container.encode(self.score, forKey: .score)
    }
    
    func save() {
        UserDefaults.standard.set(self.name, forKey: "playerName")
        UserDefaults.standard.set(self.score, forKey: "playerScore")
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "playerName")
        UserDefaults.standard.removeObject(forKey: "playerScore")
    }
}
