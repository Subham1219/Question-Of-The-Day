import SwiftUI
import FirebaseCore

@main
struct Question_Of_The_Day: App {
    @ObservedObject var database: Database = Database()
    
    var body: some Scene {
        WindowGroup {
            Text("Question of the Day!")
            Spacer()
            if let question = self.database.question {
                question
            }
            Spacer()
        }
    }
}
