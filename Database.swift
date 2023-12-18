import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

class Database: ObservableObject {
    private let firestore: Firestore = { () -> Firestore in
        FirebaseApp.configure()
        return Firestore.firestore()
    }()
    @Published var question: Question? = .none
    @Published var leaderboard: [Player] = []
    
    init() {
        self.getQuestion()
        self.getLeaderboard()
    }
    
    func getQuestion() {
        let formatter = { () -> DateFormatter in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            return formatter
        }()
        let date = formatter.string(from: Date())
        self.firestore.collection("questions").document(date).getDocument(as: Question.self) { result in
            switch result {
            case .success(let question):
                self.question = question
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getLeaderboard() {
        self.firestore.collection("players").document("leaderboard").getDocument(as: [String].self) { result in
            switch result {
            case .success(let positions):
                var players: [Player] = []
                for name in positions {
                    players.append(Player(name: name))
                }
                self.leaderboard = players
            case .failure(let error):
                print(error)
            }
        }
    }
}
