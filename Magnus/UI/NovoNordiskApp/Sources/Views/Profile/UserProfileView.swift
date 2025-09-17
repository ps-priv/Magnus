import CoreImage
import CoreImage.CIFilterBuiltins
import MagnusDomain
import MagnusFeatures
import SwiftUI
import PopupView


enum UserProfilePanel {
    case informacje
    case identyfikator
    case zmienHaslo
}

@MainActor
struct UserProfileView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @State private var user: AuthUser? = nil
    @State private var selectedPanel: UserProfilePanel? = .informacje
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showSuccessAlert = false
    @State private var hasBusiness = false

    @State private var showPrivacyPolicy = false
    @State private var showTermsOfUse = false
    @State private var showGdprPolicy = false


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
                        .transition(.opacity.combined(with: .scale))
                        .animation(.easeInOut(duration: 0.3), value: selectedPanel)
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
            Text("Hasło zostało pomyślnie zmienione")
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

            if let user = user {
                VStack(alignment: .leading, spacing: 12) {
                    NovoNordiskTextBox(
                        placeholder: LocalizedStrings.userProfileFirstname,
                        text: .constant(user.firstName),
                        style: .withTitle(LocalizedStrings.userProfileFirstname + ":", bold: true)
                    )

                    NovoNordiskTextBox(
                        placeholder: LocalizedStrings.userProfileLastname,
                        text: .constant(user.lastName),
                        style: .withTitle(LocalizedStrings.userProfileLastname + ":", bold: true)
                    )

                    NovoNordiskTextBox(
                        placeholder: LocalizedStrings.userProfileDepartment,
                        text: .constant(""),
                        style: .withTitle(LocalizedStrings.userProfileDepartment + ":", bold: true)
                    )

                    NovoNordiskTextBox(
                        placeholder: LocalizedStrings.userProfileEmail,
                        text: .constant(user.email),
                        style: .withTitle(LocalizedStrings.userProfileEmail + ":", bold: true),
                        isEnabled: false
                    )

                    // NovoNordiskTextBox(
                    //     placeholder: LocalizedStrings.userProfileNpwz,
                    //     text: .constant(""),
                    //     style: .withTitle(LocalizedStrings.userProfileNpwz + ":", bold: true)
                    // )

                    // NovoNordiskTextBox(
                    //     placeholder: LocalizedStrings.userProfileAddress,
                    //     text: .constant(""),
                    //     style: .withTitle(LocalizedStrings.userProfileAddress + ":", bold: true)
                    // )

                    // GeometryReader { geometry in
                    //     HStack(spacing: 12) {
                    //         NovoNordiskTextBox(
                    //             placeholder: LocalizedStrings.userProfilePostalcode,
                    //             text: .constant(""),
                    //             style: .withTitle(
                    //                 LocalizedStrings.userProfilePostalcode + ":", bold: true)
                    //         )
                    //         .frame(width: (geometry.size.width - 12) / 3)  // 1/3 szerokości minus spacing

                    //         NovoNordiskTextBox(
                    //             placeholder: LocalizedStrings.userProfileCity,
                    //             text: .constant(""),
                    //             style: .withTitle(
                    //                 LocalizedStrings.userProfileCity + ":", bold: true)
                    //         )
                    //         .frame(width: (geometry.size.width - 12) * 2 / 3)  // 2/3 szerokości minus spacing
                    //     }
                    // }
                    // .frame(height: 80)

                    // NovoNordiskTextBox(
                    //     placeholder: LocalizedStrings.userProfilePesel,
                    //     text: .constant(""),
                    //     style: .withTitle(LocalizedStrings.userProfilePesel + ":", bold: true)
                    // )

                    // NovoNordiskCheckbox(
                    //     title: LocalizedStrings.userProfileHasCompany,
                    //     isChecked: $hasBusiness,
                    //     //style: .regular
                    // ) { isChecked in
                    //     // Clear fields when unchecked
                    //     if !isChecked {
                    //         // nip = ""
                    //         // companyName = ""
                    //         // taxOffice = ""
                    //     }
                    // }

                    // NovoNordiskTextBox(
                    //     placeholder: LocalizedStrings.userProfileNip,
                    //     text: .constant(""),
                    //     style: .withTitle(LocalizedStrings.userProfileNip + ":", bold: true),
                    //     isEnabled: hasBusiness
                    // )

                    // NovoNordiskTextBox(
                    //     placeholder: LocalizedStrings.userProfileCompanyName,
                    //     text: .constant(""),
                    //     style: .withTitle(
                    //         LocalizedStrings.userProfileCompanyName + ":", bold: true),
                    //     isEnabled: hasBusiness
                    // )

                    // NovoNordiskTextBox(
                    //     placeholder: LocalizedStrings.userProfileTaxOffice,
                    //     text: .constant(""),
                    //     style: .withTitle(LocalizedStrings.userProfileTaxOffice + ":", bold: true),
                    //     isEnabled: hasBusiness
                    // )

                    // VStack(alignment: .leading, spacing: 0) {
                    //     NovoNordiskCheckbox(
                    //         title: LocalizedStrings.userProfilePolicy,
                    //         isChecked: $hasBusiness,
                    //         //style: .regular
                    //     )
                    //     NovoNordiskLinkButton(
                    //         title: LocalizedStrings.userProfilePolicyLink, style: .small
                    //     ) {
                    //        showPrivacyPolicy = true
                    //     }
                    //     .padding(.leading, 30)
                    // }

                    // VStack(alignment: .leading, spacing: 0) {
                    //     NovoNordiskCheckbox(
                    //         title: LocalizedStrings.userProfileRodo,
                    //         isChecked: $hasBusiness,
                    //         //style: .regular
                    //     )

                    //     NovoNordiskLinkButton(
                    //         title: LocalizedStrings.userProfileRodoLink, style: .small
                    //     ) {
                    //         showTermsOfUse = true
                    //         print("Regulamin aplikacji tapped")
                    //     }
                    //     .padding(.leading, 30)
                    // }

                    // VStack(alignment: .leading, spacing: 0) {
                    //     NovoNordiskCheckbox(
                    //         title: LocalizedStrings.userProfileMarketing,
                    //         isChecked: $hasBusiness,
                    //         //style: .regular
                    //     )

                    //     NovoNordiskLinkButton(
                    //         title: LocalizedStrings.userProfileMarketingLink, style: .small
                    //     ) {
                    //             print("Regulamin aplikacji tapped")
                    //     }
                    //     .padding(.leading, 30)
                    // }
                }

                Spacer()
            }

            Spacer()

            NovoNordiskButton(title: LocalizedStrings.buttonSave, style: .primary) {
                print("Primary tapped")
            }
            .padding(.top, 16)

            NovoNordiskButton(title: LocalizedStrings.buttonLogout, style: .outline) {
                print("Logout tapped")
                userProfileViewModel.logout()
            }
        }
    }

    @ViewBuilder
    private func identyfikatorPanel() -> some View {
        VStack(alignment: .center, spacing: 16) {
            if let user = user {
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

    // MARK: - QR Code Generation
    private func generateQRCodeText(user: AuthUser) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        let currentDateTime = dateFormatter.string(from: Date())

        return "\(user.firstName) \(user.lastName)\n\(currentDateTime)"
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
                    placeholder: LocalizedStrings.userProfileNewPassword,
                    text: .constant(""),
                    style: .withTitle(LocalizedStrings.userProfileNewPassword, bold: true),
                    isSecure: true
                )

                NovoNordiskTextBox(
                    placeholder: LocalizedStrings.userProfileRetypeNewPassword,
                    text: .constant(""),
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
        !newPassword.isEmpty && !confirmPassword.isEmpty && newPassword == confirmPassword
            && newPassword.count >= 6
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
