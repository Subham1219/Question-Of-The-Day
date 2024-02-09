import SwiftUI

struct Login: View {
    @State var player: Player = Player()
    
    @State var name: String = ""
    var body: some View {
        VStack {
            Text("Welcome to the Question of the Day!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.bottom, 20)
            
            TextField("Your Name", text: self.$name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                
            }) {
                
            }
            .padding(.top, 20)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .padding(.horizontal, 20)
    }
}

