import SwiftUI
import FirebaseCore

enum Mode {
    case login(Login)
    case question(Int)
    case answer(Bool)
}

@main
struct Question_Of_The_Day: App {
    var database: Database
    @State var player: Player
    @State var question: Question?
    @State var mode: Mode
    
    init() {
        self.database = Database()
        let player = Player()
        self.player = player
        self.mode = .login(Login(player: player))
    }
    
    func login() async {
        switch self.mode {
        case .login(let login):
            self.player.answers = await self.database.getAnswers(player: login.player)
            print("num of answers: \(self.player.answers.count)")
        default:
            break
        }
        if let answer = self.player.done() {
            switch answer.completion {
            case .attempting(let attempt):
                self.mode = .question(attempt)
            case .done(let correct):
                self.mode = .answer(correct)
            }
        } else {
            if self.question != nil {
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
                    Task {
                        await self.login()
                    }
                }) {
                    Text("Login")
                }
                Spacer()
            case .question(var attempt):
                Text("Question of the Day!")
                Spacer()
                if var question = self.question {
                    question
                        .onAppear() {
                            Task {
                                self.question = await self.database.getQuestion()
                            }
                        }
                    ForEach(Array(question.choices.enumerated()), id: \.0) { (n, choice) in
                        Button(action: { () -> Void in
                            self.player.update(completion: .attempting(attempt))
                            if question.check(answer: n) {
                                self.player.update(completion: .done(true))
                                Task {
                                    await self.database.saveAnswers(player: self.player)
                                }
                                self.mode = .answer(true)
                                return
                            }
                            if attempt >= question.max_attempts {
                                self.player.update(completion: .done(false))
                                Task {
                                    await self.database.saveAnswers(player: self.player)
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
                    self.mode = .login(Login())
                }) {
                    Text("Logout")
                }
            case .answer(let correct):
                HStack {
                    Text("Question of the Day!")
                    Text("Score: \(String(self.player.score()))")
                }
                .onAppear() {
                    Task {
                        self.question = await self.database.getQuestion()
                    }
                }
                Spacer()
                if let question = self.question {
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
                    self.mode = .login(Login())
                }) {
                    Text("Logout")
                }
            }
        }
    }
}
