import SwiftUI

struct FirstTimeLoginView: View {
    @State private var userName: String = ""
    @State private var isNameSaved: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to our app!")
                    .font(.title)
                    .padding()

                TextField("Your Name", text: $userName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                NavigationLink(destination: ContentView(userName: userName), isActive: $isNameSaved) {
                    EmptyView()
                }

                Button(action: saveName) {
                    Text("Save")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
            }
            .onAppear {
                // Check if the name is already stored
                if let savedName = UserDefaults.standard.string(forKey: "userName") {
                    print("Welcome back, \(savedName)!")
                    userName = savedName
                    isNameSaved = true
                }
            }
        }
    }

    func saveName() {
        // Check if the input is not empty
        if !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            // Save the name in UserDefaults
            UserDefaults.standard.set(userName, forKey: "userName")
            print("Welcome, \(userName)!")
            
            // Navigate to the ContentView
            isNameSaved = true
        } else {
            print("Please enter a valid name.")
        }
    }
}
