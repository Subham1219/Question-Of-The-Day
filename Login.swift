import SwiftUI

struct Login: View {
    @State var player: Player = Player()
    
    @State var name: String = ""
    var body: some View {
        
        
        
        ZStack{
            LinearGradient(colors: [.blue, .green], startPoint: .leading, endPoint: .trailing)
                .ignoresSafeArea(.all)
            VStack {
                Text("Welcome to the Question of the Day!") // Add your title here
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                    VStack {
                        TextField("Your Name", text: self.$name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                    }
                VStack {
                    Text("Write Your Name to Login!") // Add your title here
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 30)
                }
                    .cornerRadius(15)
                    .background(Color.gray.opacity(0.1))
                    .padding(.horizontal, 20)
                }
            }
        }
    }

