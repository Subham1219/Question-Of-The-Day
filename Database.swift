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
    
    init() {
        self.retrieve()
    }
    
    func retrieve() {
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
}
