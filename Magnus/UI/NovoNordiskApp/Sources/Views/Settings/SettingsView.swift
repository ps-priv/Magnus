import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var emailNotifications = false
    @State private var darkModeEnabled = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Notification Settings
                VStack(alignment: .leading, spacing: 16) {
                    Text("Powiadomienia")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 12) {
                        SettingsToggleRow(
                            icon: .bell,
                            title: "Powiadomienia push",
                            isOn: $notificationsEnabled
                        )
                        
                        SettingsToggleRow(
                            icon: .message,
                            title: "Powiadomienia email",
                            isOn: $emailNotifications
                        )
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                
                // Appearance Settings
                VStack(alignment: .leading, spacing: 16) {
                    Text("Wygląd")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    SettingsToggleRow(
                        icon: .settings,
                        title: "Tryb ciemny",
                        isOn: $darkModeEnabled
                    )
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                
                // App Info
                VStack(alignment: .leading, spacing: 16) {
                    Text("Informacje o aplikacji")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    VStack(spacing: 12) {
                        SettingsInfoRow(title: "Wersja", value: "1.0.0")
                        SettingsInfoRow(title: "Build", value: "100")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
        .background(Color(.systemGray6))
    }
}

struct SettingsToggleRow: View {
    let icon: FontAwesome.Icon
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            FAIcon(icon, type: .light, size: 20, color: .novoNordiskBlue)
            Text(title)
                .font(.body)
            Spacer()
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .novoNordiskBlue))
        }
    }
}

struct SettingsInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    SettingsView()
} 
