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
        if let answer = database.player.done() {
            self.mode = .answer(answer.correct)
        } else {
            self.mode = .question(1)
        }
        self.database = database
    }
    
    
    var body: some Scene {
        WindowGroup {
            switch self.mode {
            case .login(let login):
                Spacer()
                login
                Button(action: { () -> Void in
                    if login.player.name == "Guest" {
                        return
                    }
                    login.player.save()
                    self.database.login(name: login.player.name)
                    self.database.savePlayer()
                    self.database.getQuestion()
                    if let answer = self.database.player.done() {
                        self.mode = .answer(answer.correct)
                    } else {
                        self.mode = .question(1)
                    }
                }) {
                    Text("Login")
                }
                Spacer()
            case .question(var attempt):
                Text("Question of the Day!")
                Spacer()
                if let question = self.database.question {
                    question
                    ForEach(Array(question.choices.enumerated()), id: \.0) { (n, choice) in
                        Button(action: { () -> Void in
                            if n == question.answer {
                                if let player = self.database.player {
                                    player.answer(correct: true)
                                    self.database.savePlayer()
                                }
                                self.mode = .answer(true)
                                return
                            }
                            attempt += 1
                            if attempt > MAX_ATTEMPTS {
                                if let player = self.database.player {
                                    player.answer(correct: false)
                                    self.database.savePlayer()
                                }
                                self.mode = .answer(false)
                            }
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
