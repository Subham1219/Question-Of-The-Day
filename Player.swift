import SwiftUI

struct Player: Codable {
    let id: UUID
    var name: String
    var score: Int = 0
    
    init(name: String = "Guest") {
        if let savedID = UserDefaults.standard.string(forKey: "playerID") {
            self.id = UUID(uuidString: savedID) ?? UUID()
            self.name = "Unknown"
            self.score = UserDefaults.standard.integer(forKey: "playerScore")
            print("existing: \(self)")
            return
        }
        self.id = UUID()
        self.name = name
        self.score = UserDefaults.standard.integer(forKey: "playerScore")
        print("new: \(self)")
    }
    
    func save() -> Bool {
        if self.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
        UserDefaults.standard.set(self.id.uuidString, forKey: "playerID")
        UserDefaults.standard.set(self.score, forKey: "playerScore")
        return true
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "playerID")
        UserDefaults.standard.removeObject(forKey: "playerScore")
    }
}
