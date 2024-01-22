import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseDatabase

struct Database {
    func isGuest(name: String) -> Bool {
        if name != "Guest" {
            return false
        }
        return true
    }
    
    func getPlayer(player: Player) -> Player {
        if self.isGuest(name: player.name) {
            return player
        }
        // add database routine here
        return player
    }
    
    func saveAnswers(player: Player) {
        if self.isGuest(name: player.name) {
            return
        }
        // add database routine here
    }
    
    func getQuestion() -> Question {
//        let date = DayFormatter.string(from: Date())
        let date = "2024.1.18" // for testing
        return Question(question: "How many degrees are there in a right angle?", choices: ["45", "90", "180"], max_attempts: 1, correct: 1)
    }
}
