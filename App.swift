import SwiftUI
import FirebaseCore

enum Mode {
    case login(Login)
    case question(Int)
    case answer(Bool)
}

let MAX_ATTEMPTS = 3

@main
struct Question_Of_The_Day: App {
    @ObservedObject var database: Database
    @State var mode: Mode
    
    init() {
        let database = Database()
        let login = Login()
        if login.player.name == "Guest" {
            self.database = database
            self.mode = .login(login)
            return
        }
        login.player.save()
        database.login(name: login.player.name)
        database.savePlayer()
        database.getQuestion()
        self.database = database
        self.mode = .question(1)
    }
    
    
    var body: some Scene {
        WindowGroup {
            switch self.mode {
            case .login(let login):
                login
                Button(action: { () -> Void in
                    login.player.save()
                    self.database.login(name: login.player.name)
                    self.database.savePlayer()
                    self.database.getQuestion()
                    self.mode = .question(1)
                }) {
                    Text("Login")
                        .padding()
                }
                .padding()
            case .question(var attempt):
                Text("Question of the Day!")
                Spacer()
                if let question = self.database.question {
                    question
                    ForEach(Array(question.choices.enumerated()), id: \.0) { (n, choice) in
                        Button(action: { () -> Void in
                            if n == question.answer {
                                self.database.addScore()
                                self.mode = .answer(true)
                                return
                            }
                            attempt += 1
                            if attempt > MAX_ATTEMPTS {
                                self.mode = .answer(false)
                            }
                        }) {
                            Text(choice)
                        }
                    }
                }
                Spacer()
                Button(action: {
                    var login = Login()
                    login.player.logout()
                    self.mode = .login(login)
                }) {
                    Text("Logout")
                }
            case .answer(let correct):
                Text("Question of the Day!")
                Spacer()
                if let question = self.database.question {
                    question
                    Text("Correct answer is: \(question.choices[question.answer])")
                    if correct {
                        Text("Good job!")
                    } else {
                        Text("Maybe next time!")
                    }
                }
                Spacer()
                Button(action: {
                    let login = Login()
                    login.player.logout()
                    self.mode = .login(login)
                }) {
                    Text("Logout")
                }
            }
        }
    }
}
