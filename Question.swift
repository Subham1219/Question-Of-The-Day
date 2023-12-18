import SwiftUI

struct Question: Decodable, View {
    let question: String
    let answer: String
    
    var body: some View {
        Text(self.question)
    }
}
