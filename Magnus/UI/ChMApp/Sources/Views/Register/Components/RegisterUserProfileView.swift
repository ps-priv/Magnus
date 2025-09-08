import MagnusApplication
import MagnusDomain
import SwiftUI

struct RegisterUserProfileView: View {
    let user: RegisterUserRequest
    let onRegister: () -> Void
    let onCancel: () -> Void
    @State private var hasBusiness: Bool = false
    @State private var showPrivacyPolicy: Bool = false
    @State private var showTermsOfUse: Bool = false

    public init(
        user: RegisterUserRequest, onRegister: @escaping () -> Void, onCancel: @escaping () -> Void
    ) {
        self.user = user
        self.onRegister = onRegister
        self.onCancel = onCancel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                FAIcon(.userCircle, type: .regular, size: 20, color: .novoNordiskBlue)
                Text(LocalizedStrings.registerScreenTitle)
                    .font(.headline)
                    .foregroundColor(Color.novoNordiskTextGrey)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 12) {
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
                            style: .withTitle(
                                LocalizedStrings.userProfilePostalcode + ":", bold: true)
                        )
                        .frame(width: (geometry.size.width - 12) / 3)  // 1/3 szerokości minus spacing

                        NovoNordiskTextBox(
                            placeholder: LocalizedStrings.userProfileCity,
                            text: .constant(""),
                            style: .withTitle(
                                LocalizedStrings.userProfileCity + ":", bold: true)
                        )
                        .frame(width: (geometry.size.width - 12) * 2 / 3)  // 2/3 szerokości minus spacing
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
                    style: .withTitle(
                        LocalizedStrings.userProfileCompanyName + ":", bold: true),
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
                    NovoNordiskLinkButton(
                        title: LocalizedStrings.userProfilePolicyLink, style: .small
                    ) {
                        showPrivacyPolicy = true
                    }
                    .padding(.leading, 30)
                }

                VStack(alignment: .leading, spacing: 0) {
                    NovoNordiskCheckbox(
                        title: LocalizedStrings.userProfileRodo,
                        isChecked: $hasBusiness,
                        //style: .regular
                    )

                    NovoNordiskLinkButton(
                        title: LocalizedStrings.userProfileRodoLink, style: .small
                    ) {
                        showTermsOfUse = true
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

                    NovoNordiskLinkButton(
                        title: LocalizedStrings.userProfileMarketingLink, style: .small
                    ) {
                        print("Regulamin aplikacji tapped")
                    }
                    .padding(.leading, 30)
                }
            }

            NovoNordiskButton(title: LocalizedStrings.registerButton, style: .primary) {
                onRegister()
            }
            .padding(.top, 16)

            NovoNordiskButton(title: LocalizedStrings.cancelButton, style: .outline) {
                onCancel()
            }
        }
    }
}
