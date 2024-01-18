import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class Database: ObservableObject {
    private let firestore: Firestore = { () -> Firestore in
        FirebaseApp.configure()
        return Firestore.firestore()
    }()
    @Published var player: Player? = .none
    @Published var question: Question? = .none
    
    func login(name: String) {
        self.firestore.collection("players").document(name).getDocument(as: Player.self) { result in
            switch result {
            case .success(let player):
                self.player = .some(player)
            case .failure(_):
                print("Player not found in the database")
            }
        }
    }
    
    func savePlayer() {
        guard let player = self.player else {
            return
        }
        do {
            try self.firestore.collection("players").document(player.name).setData(from: player)
        } catch {
            print("Not able to save the player in the database")
        }
    }
    
    func getQuestion() {
//        let date = DayFormatter.string(from: Date())
        let date = "2024.1.18"
        self.firestore.collection("questions").document(date).getDocument(as: Question.self) { result in
            switch result {
            case .success(let question):
                self.question = question
            case .failure(_):
                print("Question not found in the database")
            }
        }
    }
}
