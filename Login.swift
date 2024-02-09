import SwiftUI

struct Login: View {
    @State var player: Player = Player()
    
    @State var name: String = ""
    var body: some View {
        ZStack {
            
            LinearGradient(colors: [.purple, .green], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                Text("Welcome to the Question of the Day!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.bottom, 20)
                
            }) {
                
                Button(action: {
                    
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(15)
            .padding(.horizontal, 20)
        }
    }
    
}
