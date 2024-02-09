import SwiftUI

struct Login: View {
    @State var player: Player = Player()
    
    @State var name: String = ""
    var body: some View {
        ZStack{
            LinearGradient(colors: [.blue, .green], startPoint: .leading, endPoint: .trailing)
                                .ignoresSafeArea(.all)
            VStack {
                TextField("Your Name", text: self.$name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
            }
            .cornerRadius(15)
            .background(Color.gray.opacity(0.1))
            .padding(.horizontal, 20)
        }
    }
}
