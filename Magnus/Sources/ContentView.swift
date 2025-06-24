import SwiftUI
import MagnusCore

public struct ContentView: View {
    @State private var user: User?
    
    public init() {
        // Create a sample user using MagnusCore
        self._user = State(initialValue: UserManager.shared.createUser(
            id: "1",
            email: "john.doe@example.com",
            firstname: "John",
            lastname: "Doe"
        ))
    }

    public var body: some View {
        VStack(spacing: 20) {
            Text("Magnus App")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if let user = user {
                VStack(alignment: .leading, spacing: 10) {
                    Text("User Information:")
                        .font(.headline)
                    
                    Text("ID: \(user.id)")
                    Text("Email: \(user.email)")
                    Text("Name: \(user.fullName)")
                    
                    if UserManager.shared.validateUser(user) {
                        Text("✅ User is valid")
                            .foregroundColor(.green)
                    } else {
                        Text("❌ User is invalid")
                            .foregroundColor(.red)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
