import SwiftUI

class Player: Codable, ObservableObject {
    @Published var name: String = UserDefaults.standard.string(forKey: "name") ?? "Guest"
    @Published var answers: AnswerCollection = AnswerCollection()
    
    enum JSON: String, CodingKey {
        case answers
    }
    
    init() {
        if let answers = UserDefaults.standard.object(forKey: "answers") as? [Answer] {
            self.answers.answers = answers
        }
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: JSON.self)
        self.answers = try values.decode(AnswerCollection.self, forKey: .answers)
    }
    
    func answer(correct: Bool) {
        let answer = Answer(date: Date(), correct: correct)
        self.answers.add(answer: answer)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: JSON.self)
        try container.encode(self.answers, forKey: .answers)
    }
    
    func save() {
        UserDefaults.standard.set(self.name, forKey: "name")
        UserDefaults.standard.set(self.answers, forKey: "answers")
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "answers")
    }
}
