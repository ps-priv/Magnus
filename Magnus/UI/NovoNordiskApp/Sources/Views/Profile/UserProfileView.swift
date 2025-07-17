import SwiftUI
import MagnusFeatures
import MagnusDomain

#if DEBUG
import Inject
#endif

enum UserProfilePanel {
    case informacje
    case identyfikator
    case zmienHaslo
}

struct UserProfileView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var user: AuthUser? = nil
    @State private var selectedPanel: UserProfilePanel? = .informacje
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showSuccessAlert = false
    @State private var hasBusiness = false

    #if DEBUG
    @ObserveInjection var inject
    #endif

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {          
                // Main Action Buttons
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        UserProfileMainButton(
                            title: LocalizedStrings.userProfileInformationButton,
                            icon: .circle_information,
                            isSelected: selectedPanel == .informacje
                        ) {
                            selectedPanel = selectedPanel == .informacje ? nil : .informacje
                        }
                        
                        UserProfileMainButton(
                            title: LocalizedStrings.userProfileIdButton,
                            icon: .qrcode,
                            isSelected: selectedPanel == .identyfikator
                        ) {
                            selectedPanel = selectedPanel == .identyfikator ? nil : .identyfikator
                        }
                        
                        UserProfileMainButton(
                            title:  LocalizedStrings.userProfileChangePassword,
                            icon: .lock,
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
    private func panelContent(for panel: UserProfilePanel) -> some View {
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
    }
    
    @ViewBuilder
    private func informacjePanel() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                FAIcon(.userCircle, type: .regular, size: 20, color: .novoNordiskBlue)
                Text(LocalizedStrings.userProfileInformationButton)
                    .font(.headline)
                Spacer()
            }
            
            if let user = user {
                VStack (alignment: .leading, spacing: 12) {
                    NovoNordiskTextBox(
                        placeholder: LocalizedStrings.userProfileFirstname,
                        text: .constant(user.firstName),
                        style: .withTitle(LocalizedStrings.userProfileFirstname + ":", bold: true)
                    )

                    NovoNordiskTextBox(
                        placeholder: LocalizedStrings.userProfileLastname,
                        text: .constant(""),
                        style: .withTitle(LocalizedStrings.userProfileLastname + ":", bold: true)
                    )

                    NovoNordiskTextBox(
                        placeholder: LocalizedStrings.userProfileDepartment,
                        text: .constant(""),
                        style: .withTitle(LocalizedStrings.userProfileDepartment + ":", bold: true)
                    )

                    NovoNordiskTextBox(
                        placeholder: LocalizedStrings.userProfileEmail,
                        text: .constant(""),
                        style: .withTitle(LocalizedStrings.userProfileEmail + ":", bold: true)
                    )

                    NovoNordiskTextBox(
                        placeholder: LocalizedStrings.userProfileNpwz,
                        text: .constant(""),
                        style: .withTitle(LocalizedStrings.userProfileNpwz + ":", bold: true)
                    )

                    NovoNordiskTextBox(
                        placeholder: LocalizedStrings.userProfileAddress,
                        text: .constant(""),
                        style: .withTitle(LocalizedStrings.userProfileAddress + ":", bold: true)
                    )

                    GeometryReader { geometry in
                        HStack(spacing: 12) {
                            NovoNordiskTextBox(
                                placeholder: LocalizedStrings.userProfilePostalcode,
                                text: .constant(""),
                                style: .withTitle(LocalizedStrings.userProfilePostalcode + ":", bold: true)
                            )
                            .frame(width: (geometry.size.width - 12) / 3) // 1/3 szerokości minus spacing
                            
                            NovoNordiskTextBox(
                                placeholder: LocalizedStrings.userProfileCity,
                                text: .constant(""),
                                style: .withTitle(LocalizedStrings.userProfileCity + ":", bold: true)
                            )
                            .frame(width: (geometry.size.width - 12) * 2 / 3) // 2/3 szerokości minus spacing
                        }
                    }
                    .frame(height: 80) 

                    NovoNordiskTextBox(
                        placeholder: LocalizedStrings.userProfilePesel,
                        text: .constant(""),
                        style: .withTitle(LocalizedStrings.userProfilePesel + ":", bold: true)
                    )

                    NovoNordiskCheckbox(
                        title: LocalizedStrings.userProfileHasCompany,
                        isChecked: $hasBusiness,
                        //style: .regular
                    ) { isChecked in
                        // Clear fields when unchecked
                        if !isChecked {
                            // nip = ""
                            // companyName = ""
                            // taxOffice = ""
                        }
                    }

                       NovoNordiskTextBox(
                            placeholder: LocalizedStrings.userProfileNip,
                            text: .constant(""),
                            style: .withTitle(LocalizedStrings.userProfileNip + ":", bold: true),
                            isEnabled: hasBusiness
                        )

                        NovoNordiskTextBox(
                            placeholder: LocalizedStrings.userProfileCompanyName,
                            text: .constant(""),
                            style: .withTitle(LocalizedStrings.userProfileCompanyName + ":", bold: true),
                            isEnabled: hasBusiness
                        )

                        NovoNordiskTextBox(
                            placeholder: LocalizedStrings.userProfileTaxOffice,
                            text: .constant(""),
                            style: .withTitle(LocalizedStrings.userProfileTaxOffice + ":", bold: true),
                            isEnabled: hasBusiness
                        )

                    VStack(alignment: .leading, spacing: 0) {
                        NovoNordiskCheckbox(
                            title: LocalizedStrings.userProfilePolicy,
                            isChecked: $hasBusiness,
                            //style: .regular
                        )
                        NovoNordiskLinkButton(title: LocalizedStrings.userProfilePolicyLink, style: .small) {
                            print("Regulamin aplikacji tapped")
                        }
                        .padding(.leading, 30)
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        NovoNordiskCheckbox(
                            title: LocalizedStrings.userProfileRodo,
                            isChecked: $hasBusiness,
                            //style: .regular
                        )

                        NovoNordiskLinkButton(title: LocalizedStrings.userProfileRodoLink, style: .small) {
                            print("Regulamin aplikacji tapped")
                        }     
                        .padding(.leading, 30)
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        NovoNordiskCheckbox(
                            title: LocalizedStrings.userProfileMarketing,
                            isChecked: $hasBusiness,
                            //style: .regular
                        )

                        NovoNordiskLinkButton(title: LocalizedStrings.userProfileMarketingLink, style: .small) {
                            print("Regulamin aplikacji tapped")
                        }
                        .padding(.leading, 30)
                    }
                }
            }

            NovoNordiskButton(title: LocalizedStrings.buttonSave, style: .primary) {
                print("Primary tapped")
            }
            .padding(.top, 16)

            NovoNordiskButton(title: LocalizedStrings.buttonLogout, style: .outline) {

            }
        }
    }
    
    @ViewBuilder
    private func identyfikatorPanel() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                FAIcon(.settings, type: .solid, size: 20, color: .novoNordiskBlue)
                Text("Identyfikator użytkownika")
                    .font(.headline)
                    .foregroundColor(.novoNordiskBlue)
                Spacer()
            }
            
            if let user = user {
                VStack(alignment: .leading, spacing: 12) {

                    HStack {
                        Text("Kod QR")
                            .font(.body)
                            .foregroundColor(.secondary)
                        Spacer()
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                FAIcon(.info, type: .solid, size: 30, color: .gray)
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
                FAIcon(.search, type: .solid, size: 20, color: .novoNordiskBlue)
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
}

struct UserProfileMainButton: View {
    let title: String
    let icon: FontAwesome.Icon
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: action) {
                FAIcon(icon, size: 14, color: .novoNordiskBlue)
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(.novoNordiskBlue)
                    .fontWeight(isSelected ? .bold : .regular)
            }
        }
    }
}

#Preview {
    UserProfileView()
        .environmentObject(NavigationManager())
} 
