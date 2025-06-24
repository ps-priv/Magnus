import SwiftUI
import MagnusCore
import MagnusDomain
import MagnusFeatures

struct ChMContentView: View {
    @State private var user: User?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("ChM App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
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
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("ChM")
            .onAppear {
                // Create a sample user using MagnusCore
                self.user = UserManager.shared.createUser(
                    id: "chm-1",
                    email: "user@chm.com",
                    firstname: "ChM",
                    lastname: "User"
                )
            }
        }
    }
}

struct ChMContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChMContentView()
    }
} 