import SwiftUI

struct Question: Codable, View {
    let question: String
    let choices: [String]
    let max_attempts: Int
    let correct: Int
   
    mutating func check(answer: Int) -> Bool {
        if answer == self.correct {
            return true
        }
        return false
    }
    
    var body: some View {
        Text(self.question)
    }
}
