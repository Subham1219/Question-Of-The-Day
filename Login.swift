import SwiftUI

struct Login: View {
    @State var player: Player = Player()
    
    @State var name: String = ""
    var body: some View {
        VStack(spacing: 30) {
            Text("Welcome to the Question of the Day!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
            TextField("Your Name", text: self.$name)
                .onChange(of: self.name) {
                    self.player.name = self.name
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
    }
}
 
