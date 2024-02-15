import SwiftUI

struct Login: View {
    @State var player: Player = Player()
    
    @State var name: String = ""
    var body: some View {
        VStack {
            Text("Welcome to the Question of the Day!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 30)
            TextField("Your Name", text: self.$name)
                .onChange(of: self.name) {
                    self.player.name = self.name
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Text("Write Your Name to Login!") 
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 30)
        }
        .cornerRadius(15)
        .padding(.horizontal, 20)
    }
}
