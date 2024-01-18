import SwiftUI
import FirebaseCore

enum Mode {
    case login(Login)
    case question(Int)
    case answer(Bool)
}

@main
struct Question_Of_The_Day: App {
    @ObservedObject var database: Database = Database()
    @State var mode: Mode = .login(Login())
    
    func login() {
        switch self.mode {
        case .login(let login):
            login.player.save()
            if login.player.name != "Guest" {
                self.database.login(name: login.player.name)
                self.database.savePlayer()
            }
        default:
            break
        }
        self.database.getQuestion()
        if let player = self.database.player {
            if let answer = player.done() {
                switch answer.completion {
                case .attempting(let attempt):
                    self.mode = .question(attempt)
                case .done(let correct):
                    self.mode = .answer(correct)
                }
            }
            if self.database.question != nil {
                self.mode = .question(1)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            switch self.mode {
            case .login(let login):
                Spacer()
                login
                Button(action: { () -> Void in
                    self.login()
                }) {
                    Text("Login")
                }
                Spacer()
            case .question(var attempt):
                Text("Question of the Day!")
                Spacer()
                if var question = self.database.question {
                    question
                    ForEach(Array(question.choices.enumerated()), id: \.0) { (n, choice) in
                        Button(action: { () -> Void in
                            if let player = self.database.player {
                                player.update(completion: .attempting(attempt))
                            }
                            if question.check(answer: n) {
                                if let player = self.database.player {
                                    player.update(completion: .done(true))
                                    self.database.savePlayer()
                                }
                                self.mode = .answer(true)
                                return
                            }
                            if attempt >= question.max_attempts {
                                if let player = self.database.player {
                                    player.update(completion: .done(false))
                                    self.database.savePlayer()
                                }
                                self.mode = .answer(false)
                                return
                            }
                            attempt += 1
                        }) {
                            Text(choice)
                        }
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
            case .answer(let correct):
                HStack {
                    Text("Question of the Day!")
                    if let player = self.database.player {
                        Text("Score: \(String(player.score()))")
                    }
                }
                Spacer()
                if let question = self.database.question {
                    question
                    Text("Correct answer is: \(question.choices[question.correct])")
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
