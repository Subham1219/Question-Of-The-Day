import SwiftUI

class Player: Codable, ObservableObject, Identifiable {
    let id = UUID()
    @Published var name: String = "Guest"
    @Published var answers: [Answer]
    
    init() {
        self.name = UserDefaults.standard.string(forKey: "name") ?? "Guest"
        self.answers = []
    }
    
    init(name: String) {
        self.name = name
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
        if self.name == "Guest" {
            return true
        }
        return false
    }
    
    func find(date: Date) -> Answer? {
        let target = Calendar.current.dateComponents([.year, .month, .day], from: date)
        for answer in self.answers {
            guard let time = TimeFormatter.date(from: answer.time) else {
                continue
            }
            let found = Calendar.current.dateComponents([.year, .month, .day], from: time)
            if found.year == target.year && found.month == target.month && found.day == target.day {
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
            self.answers.append(Answer(time: today, completion: completion))
        }
    }
    
    func score() -> Int {
        var score = 0
        if answers.count == 0 {
            return score
        }
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
        return score
    }
    
    func save() {
        UserDefaults.standard.setValue(self.name, forKey: "name")
    }
    
    func logout() {
        self.name = "Guest"
        UserDefaults.standard.setValue(self.name, forKey: "name")
        self.answers = []
    }
}
