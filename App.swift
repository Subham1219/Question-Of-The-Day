import SwiftUI

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
    @State var leaderboard: Leaderboard
    @State var mode: Mode
    
    init() {
        self.database = Database()
        let player = Player()
        self.player = player
        self.leaderboard = Leaderboard(current: player)
        self.mode = .login(Login(player: player))
    }
    
    func login() async {
        switch self.mode {
        case .login(let login):
            self.player = login.player
            self.player.answers = await self.database.getAnswers(player: self.player)
            self.player.save()
        default:
            break
        }
        self.leaderboard.current = self.player
        self.leaderboard.setPlayers(all: await self.database.getPlayers())
        if let answer = self.player.done() {
            switch answer.completion {
            case .attempting(let attempt):
                self.mode = .question(attempt)
            case .done(let correct):
                self.mode = .answer(correct)
            }
        } else {
            self.mode = .question(1)
        }
    }
    
    func logout() {
        self.player.logout()
        self.mode = .login(Login(player: self.player))
    }
    
    var body: some Scene {
        WindowGroup {
            switch self.mode {
            case .login(let login):
                ZStack {
                    LinearGradient(colors: [.cyan, .green], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea()
                    VStack {
                        login
                        Button(action: { () -> Void in
                            Task {
                                await self.login()
                            }
                        }) {
                            Text("Login")
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.heavy)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.bottom, 20)
                        }
                        .task {
                            self.question = await self.database.getQuestion()
                            if !login.player.isGuest() {
                                await self.login()
                            }
                        }
                    }
                }
            case .question(var attempt):
                Text("Question of the Day!")
                    .font(.title)
                    .bold()
                    .padding()
                Spacer()
                if var question = self.question {
                    question
                    ForEach(Array(question.choices.enumerated()), id: \.0) { (n, choice) in
                        Button(action: { () -> Void in
                            self.player.update(completion: .attempting(attempt))
                            if question.check(answer: n) {
                                self.player.update(completion: .done(true))
                                Task {
                                    await self.database.saveAnswers(player: self.player)
                                    self.leaderboard.current = self.player
                                    self.leaderboard.setPlayers(all: await self.database.getPlayers())
                                }
                                self.mode = .answer(true)
                                return
                            }
                            if attempt >= question.max_attempts {
                                self.player.update(completion: .done(false))
                                Task {
                                    await self.database.saveAnswers(player: self.player)
                                    self.leaderboard.current = self.player
                                    self.leaderboard.setPlayers(all: await self.database.getPlayers())
                                }
                                self.mode = .answer(false)
                                return
                            }
                            attempt += 1
                        }) {
                            Text(choice)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(12)
                                .padding(.horizontal, 10)
                        }
                    }
                } else {
                    Text("No Question Today")
                }
                Spacer()
                Button(action: {
                    self.logout()
                }) {
                    Text("Logout")
                }
            case .answer(let correct):
                Text("Question of the Day!")
                    .font(.title)
                    .bold()
                    .padding()
                if let question = self.question {
                    question
                    Text("Correct answer is: \(question.choices[question.correct])")
                    if correct {
                        Text("Good job!")
                    } else {
                        Text("Maybe next time!")
                    }
                }
                self.leaderboard
                Spacer()
                Button(action: {
                    self.logout()
                }) {
                    Text("Logout")
                }
            }
        }
    }
}
