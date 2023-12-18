import SwiftUI

struct Login: View {
    @State private var name: String = ""
    @State private var isNameSaved: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to the Question of the Day!")
                    .font(.title)
                    .padding()

                TextField("Your Name", text: $name)
                    .padding()
            }
            .onAppear {
                if let savedName = UserDefaults.standard.string(forKey: "name") {
                    name = savedName
                    isNameSaved = true
                }
            }
        }
    }

    func saveName() {
        if !self.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            UserDefaults.standard.set(self.name, forKey: "name")
            self.isNameSaved = true
        }
    }
}
