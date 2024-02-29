import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct Database {
    let firestore = { () -> Firestore in
        FirebaseApp.configure()
        return Firestore.firestore()
    }()
    
    func getAnswers(player: Player) async -> [Answer] {
        var answers = player.answers
        if !player.isGuest() {
            do {
                answers = try await self.firestore.collection("players").document(player.name).getDocument(as: Player.self).answers
            } catch {
                print("Error decoding city: \(error)")
            }
        }
        return answers
    }
        
    func saveAnswers(player: Player) async {
        if player.isGuest() {
            return
        }
        do {
            try self.firestore.collection("players").document(player.name).setData(from: player)
        } catch let error {
            print("Error saving answers: \(error)")
        }
    }
    
    func getQuestion() async -> Question? {
//        let date = String(TimeFormatter.string(from: Date()).split(separator: " ")[0])
        let date = "2024.02.23"
        do {
            let question = try await self.firestore.collection("questions").document(date).getDocument(as: Question.self)
            return .some(question)
        } catch {
            print("Error decoding answers: \(error)")
        }
        return .none
    }
    
    func getPlayers() async -> [Player] {
        var players: [Player] = []
        do {
            let documents = try await self.firestore.collection("players").getDocuments().documents
            for document in documents {
                do {
                    let player = try document.data(as: Player.self)
                    player.name = document.documentID
                    players.append(player)
                } catch {
                    players.append(Player(name: document.documentID))
                }
            }
        } catch {
            print("Error getting leaderboard: \(error)")
        }
        return players
    }
}
