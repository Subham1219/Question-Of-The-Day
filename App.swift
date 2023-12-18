import SwiftUI
import FirebaseCore

enum Mode {
    case login(Login)
    case question(Int)
    case answer
}

@main
struct Question_Of_The_Day: App {
    @State var mode: Mode = .login(Login())
    @ObservedObject var database: Database = Database()
    
    var body: some Scene {
        WindowGroup {
            switch self.mode {
            case .login(let login):
                login
                Button(action: { () -> Void in
                    login.saveName()
                    self.mode = .question(1)
                }) {
                    Text("Login")
                        .padding()
                }
                .padding()
            case .question:
                Text("Question of the Day!")
                Spacer()
                if let question = self.database.question {
                    question
                }
                Button(action: { () -> Void in
                    self.mode = .answer
                }) {
                    Text("Show Answer")
                }
                Spacer()
            case .answer:
                Text("Question of the Day!")
                Spacer()
                if let question = self.database.question {
                    question
                    Text(question.answer)
                }
                Spacer()
            }
        }
    }
}
