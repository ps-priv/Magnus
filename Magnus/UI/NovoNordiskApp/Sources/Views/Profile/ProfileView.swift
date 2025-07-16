import SwiftUI
import MagnusFeatures
import MagnusDomain

struct ProfileView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var user: AuthUser? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                VStack(spacing: 16) {
                    FAIcon(.userCircle, type: .solid, size: 80, color: .novoNordiskBlue)
                    
                    if let user = user {
                        Text(user.fullName)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(user.email)
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        Text(user.roleName)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.novoNordiskBlue.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                
                // Profile Actions
                VStack(spacing: 12) {
                    ProfileActionRow(icon: .settings, title: "Ustawienia") {
                        navigationManager.navigate(to: .settings)
                    }
                    
                    ProfileActionRow(icon: .bell, title: "Powiadomienia") {
                        // Handle notifications
                    }
                    
                    ProfileActionRow(icon: .signOut, title: "Wyloguj się", isDestructive: true) {
                        handleLogout()
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .onAppear {
            loadUserData()
        }
    }
    
    private func loadUserData() {
        do {
            user = try DIContainer.shared.authStorageService.getUserData()
        } catch {
            print("Failed to load user data: \(error)")
        }
    }
    
    private func handleLogout() {
        Task {
            do {
                try DIContainer.shared.authStorageService.clearAllAuthData()
                // Navigate back to login (this would need proper implementation in real app)
                print("User logged out successfully")
            } catch {
                print("Failed to logout: \(error)")
            }
        }
    }
}

struct ProfileActionRow: View {
    let icon: FontAwesome.Icon
    let title: String
    let isDestructive: Bool
    let action: () -> Void
    
    init(icon: FontAwesome.Icon, title: String, isDestructive: Bool = false, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.isDestructive = isDestructive
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                FAIcon(icon, type: .light, size: 20, color: isDestructive ? .red : .novoNordiskBlue)
                Text(title)
                    .font(.body)
                    .foregroundColor(isDestructive ? .red : .primary)
                Spacer()
                FAIcon(.circle_arrow_right, type: .light, size: 16, color: .gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - SwiftUI Previews
#Preview {
    ProfileView()
        .environmentObject(NavigationManager())
} 
