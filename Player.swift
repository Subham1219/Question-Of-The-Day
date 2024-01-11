import SwiftUI

class Player: Codable, ObservableObject {
    @Published var name: String = UserDefaults.standard.string(forKey: "name") ?? "Guest"
    @Published var answers: [Answer] = []
    
    enum JSON: String, CodingKey {
        case answers
    }
    
    init() {
        if let answers = UserDefaults.standard.object(forKey: "answers") as? [Answer] {
            self.answers = answers
        }
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: JSON.self)
        self.answers = try values.decode([Answer].self, forKey: .answers)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: JSON.self)
        try container.encode(self.answers, forKey: .answers)
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
        if var answer = self.find(date: today) {
            answer.completion = completion
        } else {
            self.answers.append(Answer(date: today, completion: completion))
        }
        self.save()
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
        UserDefaults.standard.set(self.name, forKey: "name")
//        UserDefaults.standard.set(self.answers, forKey: "answers")
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "answers")
    }
}
