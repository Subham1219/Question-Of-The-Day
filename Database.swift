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
    
    init(player: Player? = .none) {
        self.player = player
        self.getQuestion()
    }
    
    func login(id: UUID) {
        self.firestore.collection("players").document(id.uuidString).getDocument(as: Player.self) { result in
            switch result {
            case .success(let player):
                self.player = .some(player)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func savePlayer() {
        guard let player = self.player else {
            return
        }
        if player.name == "Guest" {
            return
        }
        let id = player.id ?? UUID()
        do {
            try self.firestore.collection("players").document(id.uuidString).setData(from: self.player)
        } catch let error {
            print(error)
        }
    }
    
    func getQuestion() {
//        let formatter = { () -> DateFormatter in
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy.MM.dd"
//            return formatter
//        }()
//        let date = formatter.string(from: Date())
        let date = "2023.12.18" // for testing
        self.firestore.collection("questions").document(date).getDocument(as: Question.self) { result in
            switch result {
            case .success(let question):
                self.question = question
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func addScore() {
        self.player.score += 1
        self.savePlayer()
    }
}
