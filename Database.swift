import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct Database {
    let firestore = { () -> Firestore in
        FirebaseApp.configure()
        return Firestore.firestore()
    }()
    
    func isGuest(name: String) -> Bool {
        if name != "Guest" {
            return false
        }
        return true
    }
    
    func getAnswers(player: Player) async -> [Answer] {
        var answers = player.answers
        if !self.isGuest(name: player.name) {
            do {
                answers = try await self.firestore.collection("players").document(player.name).getDocument(as: Player.self).answers
            } catch {
                print("Error decoding city: \(error)")
            }
        }
        return answers
    }
        
    func saveAnswers(player: Player) async {
        if self.isGuest(name: player.name) {
            return
        }
        do {
            try self.firestore.collection("players").document(player.name).setData(from: player)
        } catch let error {
            print("Error saving answers: \(error)")
        }
    }
    
    func getQuestion() async -> Question? {
        //        let date = DayFormatter.string(from: Date())
        let date = "2024.1.22" // for testing
        do {
            let question = try await self.firestore.collection("questions").document(date).getDocument(as: Question.self)
            return .some(question)
        } catch {
            print("Error decoding city: \(error)")
        }
        return .none
    }
}
