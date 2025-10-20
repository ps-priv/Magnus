import MagnusFeatures
import SwiftUI

struct ForgotPasswordView: View {
    let onCancel: () -> Void

    @StateObject private var viewModel = ForgotPasswordViewModel()

    @State private var showConfirmation = false
    @State private var showResetPassword = false

    init(onCancel: @escaping () -> Void) {
        self.onCancel = onCancel
    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {

                        Spacer(minLength: 20)

                        // Bottom logo
                        VStack(spacing: 16) {
                            Image("NovoNordiskLogo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 120)
                                .opacity(0.8)
                        }

                        // Top section with logo and title
                        VStack(spacing: 24) {
                            // Title
                            Text(LocalizedStrings.forgotPasswordTitle)
                                .font(.novoNordiskTitle)
                                .foregroundColor(Color("NovoNordiskBlue"))
                                .multilineTextAlignment(.center)
                                .tracking(2)
                        }
                        .padding(.top, geometry.safeAreaInsets.top + 24)

                        Spacer(minLength: 20)

                        // Form content
                        VStack(spacing: 24) {

                            // Error message
                            if !viewModel.errorMessage.isEmpty {
                                NovoNordiskErrorView.error(
                                    viewModel.errorMessage,
                                    title: LocalizedStrings.loginError,
                                    style: .animated
                                ) {
                                    viewModel.clearError()
                                }
                                .padding(.top, 8)
                            }

                            // Instructions
                            // Text(LocalizedStrings.forgotPasswordMessage)
                            //     .font(.novoNordiskBody)
                            //     .fontWeight(.bold)
                            //     .foregroundColor(Color.novoNordiskBlue)
                            //     .multilineTextAlignment(.center)

                            Spacer()
                            // Email input
                            VStack(alignment: .leading, spacing: 8) {
                                Text(LocalizedStrings.recoveryEmailTextBoxLabel)
                                    .font(.novoNordiskBody)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.novoNordiskTextGrey)
                                    .multilineTextAlignment(.center)

                                NovoNordiskTextBox(
                                    placeholder: LocalizedStrings.emailPlaceholder,
                                    text: $viewModel.email
                                )
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)

                            }

                            Spacer(minLength: 20)

                            // Buttons
                            VStack(spacing: 16) {
                                // Reset password button
                                NovoNordiskButton(
                                    title: viewModel.isLoading
                                        ? LocalizedStrings.loading
                                        : LocalizedStrings.resetPasswordButton,
                                    style: .primary,
                                    isEnabled: viewModel.canSendResetPasswordEmail
                                ) {
                                    Task {
                                        await viewModel.sendResetPasswordEmail()
                                    }
                                }
                                .disabled(!viewModel.canSendResetPasswordEmail)

                                // Have verification code button
                                NovoNordiskButton(
                                    title: LocalizedStrings.haveVerificationCode,
                                    style: .outline
                                ) {
                                    haveVerificationCodeAction()
                                }
                                .disabled(viewModel.isLoading)

                                // Cancel button
                                NovoNordiskButton(
                                    title: LocalizedStrings.cancel,
                                    style: .outline
                                ) {
                                    onCancel()
                                }
                                .disabled(viewModel.isLoading)
                            }
                            .padding(.top, 12)
                        }
                        .padding(.horizontal, 24)

                    }
                    .frame(minHeight: geometry.size.height)
                }
            }
            .background(Color.white)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .onChange(of: viewModel.emailSentSuccessfully) { _, success in
                if success {
                    showConfirmation = true
                }
            }
            .fullScreenCover(isPresented: $showConfirmation) {
                PasswordResetConfirmationView {
                    // When user taps "Go to password reset"
                    showConfirmation = false
                    showResetPassword = true
                }
            }
            .fullScreenCover(isPresented: $showResetPassword) {
                ResetPasswordView {
                    showResetPassword = false
                }
            }
        }
    }

    private func haveVerificationCodeAction() {
        print("Have verification code tapped")
        showResetPassword = true
        // TODO: Navigate to verification code screen
    }
}

#Preview {
    ForgotPasswordView {
        print("Cancel tapped")
    }
}
