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
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func savePlayer() {
        guard let player = self.player else {
            return
        }
        do {
            try self.firestore.collection("players").document(player.name).setData(from: player)
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
}
