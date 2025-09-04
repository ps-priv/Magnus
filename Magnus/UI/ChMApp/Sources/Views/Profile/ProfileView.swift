import SwiftUI
import MagnusFeatures
import MagnusDomain

enum ProfilePanel {
    case informacje
    case identyfikator
    case zmienHaslo
}

struct ProfileView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var user: AuthUser? = nil
    @State private var selectedPanel: ProfilePanel? = nil
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showSuccessAlert = false
    
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
                
                // Main Action Buttons
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        ProfileMainButton(
                            title: "Informacje",
                            icon: .info,
                            isSelected: selectedPanel == .informacje
                        ) {
                            selectedPanel = selectedPanel == .informacje ? nil : .informacje
                        }
                        
                        ProfileMainButton(
                            title: "Identyfikator",
                            icon: .info,
                            isSelected: selectedPanel == .identyfikator
                        ) {
                            selectedPanel = selectedPanel == .identyfikator ? nil : .identyfikator
                        }
                        
                        ProfileMainButton(
                            title: "Zmień hasło",
                            icon: .settings,
                            isSelected: selectedPanel == .zmienHaslo
                        ) {
                            selectedPanel = selectedPanel == .zmienHaslo ? nil : .zmienHaslo
                        }
                    }
                }
                
                // Panel Content
                if let panel = selectedPanel {
                    panelContent(for: panel)
                        .transition(.opacity.combined(with: .scale))
                        .animation(.easeInOut(duration: 0.3), value: selectedPanel)
                }
                
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
        .alert("Sukces", isPresented: $showSuccessAlert) {
            Button("OK") { }
        } message: {
            Text("Hasło zostało pomyślnie zmienione")
        }
    }
    
    @ViewBuilder
    private func panelContent(for panel: ProfilePanel) -> some View {
        VStack(spacing: 16) {
            switch panel {
            case .informacje:
                informacjePanel()
            case .identyfikator:
                identyfikatorPanel()
            case .zmienHaslo:
                zmienHasloPanel()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    @ViewBuilder
    private func informacjePanel() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                FAIcon(.settings, type: .solid, size: 20, color: .novoNordiskBlue)
                Text("Informacje o profilu")
                    .font(.headline)
                    .foregroundColor(.novoNordiskBlue)
                Spacer()
            }
            
            if let user = user {
                VStack(alignment: .leading, spacing: 12) {
                    InfoRow(label: "Imię i nazwisko", value: user.fullName)
                    InfoRow(label: "Adres email", value: user.email)
                    InfoRow(label: "Rola", value: user.roleName)
                    InfoRow(label: "Status konta", value: "Aktywne")
                    InfoRow(label: "Data rejestracji", value: "15.03.2024")
                    InfoRow(label: "Ostatnie logowanie", value: "Dziś, 14:30")
                }
            }
        }
    }
    
    @ViewBuilder
    private func identyfikatorPanel() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                FAIcon(.info, type: .solid, size: 20, color: .novoNordiskBlue)
                Text("Identyfikator użytkownika")
                    .font(.headline)
                    .foregroundColor(.novoNordiskBlue)
                Spacer()
            }
            
            if let user = user {
                VStack(alignment: .leading, spacing: 12) {
                    InfoRow(label: "ID użytkownika", value: user.id)
                    InfoRow(label: "Email", value: user.email)
                    InfoRow(label: "Unikalny identyfikator", value: "NN-\(user.id.prefix(8))")
                    
                    HStack {
                        Text("Kod QR")
                            .font(.body)
                            .foregroundColor(.secondary)
                        Spacer()
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                FAIcon(.settings, type: .solid, size: 30, color: .gray)
                            )
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func zmienHasloPanel() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                FAIcon(.settings, type: .solid, size: 20, color: .novoNordiskBlue)
                Text("Zmień hasło")
                    .font(.headline)
                    .foregroundColor(.novoNordiskBlue)
                Spacer()
            }
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nowe hasło")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    SecureField("Wprowadź nowe hasło", text: $newPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Potwierdź hasło")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    SecureField("Potwierdź nowe hasło", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Button(action: changePassword) {
                    Text("Zmień hasło")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            canChangePassword ? Color.novoNordiskBlue : Color.gray
                        )
                        .cornerRadius(8)
                }
                .disabled(!canChangePassword)
            }
        }
    }
    
    private var canChangePassword: Bool {
        !newPassword.isEmpty && 
        !confirmPassword.isEmpty && 
        newPassword == confirmPassword && 
        newPassword.count >= 6
    }
    
    private func changePassword() {
        // Symulacja zmiany hasła
        newPassword = ""
        confirmPassword = ""
        selectedPanel = nil
        showSuccessAlert = true
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

struct ProfileMainButton: View {
    let title: String
    let icon: FontAwesome.Icon
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                FAIcon(icon, type: .solid, size: 24, color: isSelected ? .white : .novoNordiskBlue)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .novoNordiskBlue)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                isSelected ? Color.novoNordiskBlue : Color.white
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.novoNordiskBlue.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body)
                .fontWeight(.medium)
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
