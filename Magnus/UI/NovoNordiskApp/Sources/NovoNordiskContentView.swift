import SwiftUI
import MagnusCore
//import MagnusDomain
//import MagnusFeatures

struct NovoNordiskContentView: View {
    @State private var user: User?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Novo Nordisk App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
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
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                // Create a sample user using MagnusCore
                self.user = UserManager.shared.createUser(
                    id: "novo-1",
                    email: "user@novonordisk.com",
                    firstname: "Novo",
                    lastname: "Nordisk"
                )
            }
        }
    }
}

struct NovoNordiskContentView_Previews: PreviewProvider {
    static var previews: some View {
        NovoNordiskContentView()
    }
} 
