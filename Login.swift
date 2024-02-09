import SwiftUI

struct Login: View {
    @State var player: Player = Player()
    
    @State var name: String = ""
    var body: some View {
            
            VStack {
                Text("Welcome to the Question of the Day!")
                    .font(.system(.title, design: .rounded))
                                    .fontWeight(.heavy)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                TextField("Your Name", text: self.$name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            .cornerRadius(15)
            .background(Color.gray.opacity(0.1))
            .padding(.horizontal, 20)
        }
    }
    

