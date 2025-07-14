import SwiftUI

struct ForgotPasswordView: View {
    let onCancel: () -> Void
    
    @State private var email: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    
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
                        if !errorMessage.isEmpty {
                            NovoNordiskErrorView.error(
                                errorMessage,
                                title: LocalizedStrings.error,
                                style: .animated
                            ) {
                                errorMessage = ""
                            }
                            .padding(.top, 8)
                        }
                        
                        // Instructions
                        Text(LocalizedStrings.forgotPasswordMessage)
                            .font(.novoNordiskBody)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            //.padding(.horizontal, 24)
                        
                        // Email input
                        VStack(alignment: .leading, spacing: 8) {
                            NovoNordiskTextBox(
                                placeholder: LocalizedStrings.emailPlaceholder,
                                text: $email,
                                style: .withTitle(LocalizedStrings.emailLabel, bold: true)
                            )
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        }
                        
                        Spacer(minLength: 20)

                        // Buttons
                        VStack(spacing: 16) {
                            // Reset password button
                            NovoNordiskButton(
                                title: isLoading ? LocalizedStrings.loading : LocalizedStrings.resetPasswordButton,
                                style: .primary,
                                isEnabled: !email.isEmpty && !isLoading
                            ) {
                                resetPassword()
                            }
                            .disabled(email.isEmpty || isLoading)
                            
                            // Have verification code button
                            NovoNordiskButton(
                                title: LocalizedStrings.haveVerificationCode,
                                style: .outline
                            ) {
                                haveVerificationCodeAction()
                            }
                            .disabled(isLoading)
                            
                            // Cancel button
                            NovoNordiskButton(
                                title: LocalizedStrings.cancel,
                                style: .outline
                            ) {
                                onCancel()
                            }
                            .disabled(isLoading)
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
        }
    }
    
    // MARK: - Private Methods
    
    private func resetPassword() {
        guard !email.isEmpty else { return }
        
        isLoading = true
        errorMessage = ""
        
        // TODO: Implement password reset logic
        // For now, simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            
            // Simulate success or error
            if email.contains("@") {
                print("Password reset sent to: \(email)")
                // TODO: Show success message or navigate to next screen
            } else {
                errorMessage = "Nieprawidłowy format email"
            }
        }
    }
    
    private func haveVerificationCodeAction() {
        print("Have verification code tapped")
        // TODO: Navigate to verification code screen
    }
}

#Preview {
    ForgotPasswordView {
        print("Cancel tapped")
    }
} 