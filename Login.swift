import SwiftUI

struct Login: View {
    @State var player: Player = Player()
    
    @State var name: String = ""
    var body: some View {
        VStack {
            Text("Welcome to the Question of the Day!")
            TextField("Your Name", text: self.$name)
                .onChange(of: self.name) {
                    self.player.name = self.name
                }
        }
        .padding()
    }
}
