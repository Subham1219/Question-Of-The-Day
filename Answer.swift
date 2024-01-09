import SwiftUI

struct Answer: Codable {
    let date: Date
    let correct: Bool
}

struct AnswerCollection: Codable {
    var answers: [Answer] = []
    
    mutating func add(answer: Answer) {
        self.answers.append(answer)
    }
    
    func score() -> Double {
        var score = 0
        for answer in answers {
            if answer.correct {
               score += 1
            }
        }
        return Double(score / answers.count)
    }
}
