import SwiftUI

struct Player: Decodable, View {
    let name: String
    
    var body: some View {
        Text(self.name)
    }
}
