import SwiftUI

class Player: Codable, ObservableObject {
    @Published var name: String = "Guest"
    @Published var answers: [Answer]
    
    init() {
        self.name = UserDefaults.standard.string(forKey: "name") ?? "Guest"
        self.answers = []
    }
    
    enum JSON: String, CodingKey {
        case answers
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: JSON.self)
        self.answers = try values.decode([Answer].self, forKey: .answers)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: JSON.self)
        try container.encode(self.answers, forKey: .answers)
    }
    
    func isGuest() -> Bool {
        if self.name != "Guest" {
            return false
        }
        return true
    }
    
    func find(date: Date) -> Answer? {
        let day = DayFormatter.string(from: date)
        for answer in self.answers {
            if answer.day == day {
                return .some(answer)
            }
        }
        return .none
    }
    
    func done() -> Answer? {
        let today = Date()
        return self.find(date: today)
    }
    
    func update(completion: Completion) {
        let today = Date()
        if let answer = self.find(date: today) {
            answer.completion = completion
        } else {
            self.answers.append(Answer(date: today, completion: completion))
        }
    }
    
    func score() -> Double {
        if answers.count == 0 {
            return 0
        }
        var score = 0
        for answer in answers {
            switch answer.completion {
            case .attempting(_):
                continue
            case .done(let correct):
                if correct {
                    score += 1
                }
            }
        }
        return Double(score / answers.count)
    }
    
    func save() {
        if self.isGuest() {
            return
        }
        UserDefaults.standard.setValue(self.name, forKey: "name")
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "name")
    }
}
