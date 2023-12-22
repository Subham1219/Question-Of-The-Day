import SwiftUI

struct Question: Decodable, View {
    let question: String
    let choices: [String]
    let answer: Int
    
    var body: some View {
        Text(self.question)
    }
}
