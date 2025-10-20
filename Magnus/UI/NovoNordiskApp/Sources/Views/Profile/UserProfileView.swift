import CoreImage
import CoreImage.CIFilterBuiltins
import MagnusDomain
import MagnusFeatures
import SwiftUI


enum UserProfilePanel {
    case informacje
    case identyfikator
    case zmienHaslo
}

@MainActor
struct UserProfileView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @State private var selectedPanel: UserProfilePanel? = .informacje
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showSuccessAlert = false
    @State private var showErrorAlert = false
    @State private var hasBusiness = false

    @State private var showPrivacyPolicy = false
    @State private var showTermsOfUse = false
    @State private var showGdprPolicy = false
    
    // Editable user profile fields
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""


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

                        // UserProfileMainButton(
                        //     title: LocalizedStrings.userProfileIdButton,
                        //     icon: .qrcode,
                        //     isSelected: selectedPanel == .identyfikator
                        // ) {
                        //     selectedPanel = selectedPanel == .identyfikator ? nil : .identyfikator
                        // }

                        UserProfileMainButton(
                            title: LocalizedStrings.userProfileChangePassword,
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
                }

                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)  
        }
        .background(Color.novoNordiskBackgroundGrey)
        .onAppear {
            loadUserData()
        }
        .alert("Sukces", isPresented: $showSuccessAlert) {
            Button("OK") {}
        } message: {
            Text(LocalizedStrings.passwordChangedMessage)
        }
        .alert("Błąd", isPresented: $showErrorAlert) {
            Button("OK") {}
        } message: {
            Text(userProfileViewModel.errorMessage)
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            VStack() {
                PrivacyPolicyView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.white)
            .cornerRadius(20, corners: [.topLeft, .topRight])
        }
        .sheet(isPresented: $showTermsOfUse) {
            VStack() {
                TermsOfServiceView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.white)
            .cornerRadius(20, corners: [.topLeft, .topRight])
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
                    .foregroundColor(Color.novoNordiskTextGrey)
                Spacer()
            }

            if userProfileViewModel.user != nil {
                VStack(alignment: .leading, spacing: 12) {
                    NovoNordiskTextBox(
                        placeholder: LocalizedStrings.userProfileFirstname,
                        text: $firstName,
                        style: .withTitle(LocalizedStrings.userProfileFirstname + ":", bold: true)
                    )

                    NovoNordiskTextBox(
                        placeholder: LocalizedStrings.userProfileLastname,
                        text: $lastName,
                        style: .withTitle(LocalizedStrings.userProfileLastname + ":", bold: true)
                    )

                    NovoNordiskTextBox(
                        placeholder: LocalizedStrings.userProfileEmail,
                        text: $email,
                        style: .withTitle(LocalizedStrings.userProfileEmail + ":", bold: true),
                        isEnabled: false
                    )

                }

                Spacer()
            }

            Spacer()

            NovoNordiskButton(title: LocalizedStrings.buttonSave, style: .primary) {
                Task {
                    // Update ViewModel with edited values
                    if let user = userProfileViewModel.user {
                        userProfileViewModel.user = UserProfileResponse(
                            id: user.id,
                            email: email,
                            firstName: firstName,
                            lasName: lastName,
                            role: user.role,
                            groups: user.groups
                        )
                    }
                    await userProfileViewModel.updateUser()
                }
            }
            .padding(.top, 16)

            NovoNordiskButton(title: LocalizedStrings.buttonLogout, style: .outline) {
                userProfileViewModel.logout()
            }
        }
    }

    @ViewBuilder
    private func identyfikatorPanel() -> some View {
        VStack(alignment: .center, spacing: 16) {
            if let user = userProfileViewModel.user {
                Text(LocalizedStrings.userProfileQrcodeId)
                    .font(.headline)
                    .foregroundColor(Color.novoNordiskTextGrey)
                    .fontWeight(.bold)

                // QR Code
                if let qrImage = generateQRCode(from: generateQRCodeText(user: user)) {
                    Image(uiImage: qrImage)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 270, height: 270)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 270, height: 270)
                        .overlay(
                            Text("Błąd generowania QR")
                                .foregroundColor(Color.novoNordiskTextGrey)
                        )
                }

                Text(LocalizedStrings.userProfileQrcodeDescription)
                    .font(.body)
                    .foregroundColor(Color.novoNordiskTextGrey)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }

    private func generateQRCodeText(user: UserProfileResponse) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let currentDateTime = dateFormatter.string(from: Date())

        return "\(user.firstName) \(user.lasName)\n\(currentDateTime)"
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()

        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            // Scale up the QR code for better quality
            let scaleX = 270 / outputImage.extent.size.width
            let scaleY = 270 / outputImage.extent.size.height
            let transformedImage = outputImage.transformed(
                by: CGAffineTransform(scaleX: scaleX, y: scaleY))

            if let cgimg = context.createCGImage(transformedImage, from: transformedImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return nil
    }

    @ViewBuilder
    private func zmienHasloPanel() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                FAIcon(.lock, type: .solid, size: 20, color: .novoNordiskBlue)
                Text(LocalizedStrings.userProfileChangePassword)
                    .font(.headline)
                    .foregroundColor(Color.novoNordiskTextGrey)
                Spacer()
            }

            VStack(spacing: 16) {

                NovoNordiskTextBox(
                    placeholder: LocalizedStrings.passwordLabel,
                    text: $currentPassword,
                    style: .withTitle(LocalizedStrings.passwordLabel, bold: true),
                    isSecure: true
                )

                NovoNordiskTextBox(
                    placeholder: LocalizedStrings.userProfileNewPassword,
                    text: $newPassword,
                    style: .withTitle(LocalizedStrings.userProfileNewPassword, bold: true),
                    isSecure: true
                )

                NovoNordiskTextBox(
                    placeholder: LocalizedStrings.userProfileRetypeNewPassword,
                    text: $confirmPassword,
                    style: .withTitle(LocalizedStrings.userProfileRetypeNewPassword, bold: true),
                    isSecure: true
                )

                Button(action: changePassword) {
                    Text(LocalizedStrings.buttonChangePassword)
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
        !currentPassword.isEmpty && !newPassword.isEmpty && !confirmPassword.isEmpty && newPassword == confirmPassword
            && newPassword.count >= 6
    }

    private func changePassword() {
        Task {
            await userProfileViewModel.changePassword(
                currentPassword: currentPassword,
                newPassword: newPassword
            )
            
            if userProfileViewModel.hasError {
                showErrorAlert = true
            } else {
                // Clear all form state
                currentPassword = ""
                newPassword = ""
                confirmPassword = ""
                showSuccessAlert = true
            }
        }
    }

        private func loadUserData() {
        Task {
                await userProfileViewModel.getUserProfile()
                
                // Initialize local state with user data
                if let user = userProfileViewModel.user {
                    firstName = user.firstName
                    lastName = user.lasName
                    email = user.email
                }
        }
    }
}

// MARK: - DateFormatter Extension
extension DateFormatter {
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        return formatter
    }()
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
