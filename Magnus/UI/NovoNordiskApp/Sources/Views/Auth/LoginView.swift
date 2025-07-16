import SwiftUI
import MagnusFeatures

struct LoginView: View {
    let onAuthenticationSuccess: () -> Void
    
    @StateObject private var viewModel = LoginViewModel()
    @State private var showError = false
    @State private var showForgotPassword = false
    
    init(onAuthenticationSuccess: @escaping () -> Void = {}) {
        self.onAuthenticationSuccess = onAuthenticationSuccess
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    Spacer(minLength: 40)
                    
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
                        Text(LocalizedStrings.loginTitle)
                            .font(.novoNordiskTitle)
                            .foregroundColor(Color("NovoNordiskBlue"))
                            .tracking(2)
                    }
                    .padding(.bottom, 20)
                    .padding(.top, geometry.safeAreaInsets.top + 24)
                    
                    // Login form
                    VStack(spacing: 24) {
                        
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
 
                        VStack(alignment: .leading, spacing: 8) {

                            NovoNordiskTextBox(
                                placeholder: LocalizedStrings.emailPlaceholder,
                                text: $viewModel.email,
                                style: .withTitle(LocalizedStrings.emailLabel, bold: true),
                            )
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        }
                        

                        VStack(alignment: .leading, spacing: 8) {
                            NovoNordiskTextBox(
                                placeholder: LocalizedStrings.passwordPlaceholder,
                                text: $viewModel.password,
                                style: .withTitle(LocalizedStrings.passwordLabel, bold: true),
                                isSecure: true,
                            )
                        }
                        
                        // Forgot password link
                        HStack {
                            NovoNordiskLinkButton(
                                title: LocalizedStrings.forgotPassword,
                                style: .underlined
                            ) {
                                showForgotPassword = true
                            }
                            
                            Spacer()
                        }
                        //.padding(.top, 8)
                        Spacer(minLength: 20)

                        // Buttons 
                        VStack(spacing: 16) {
                            
                            // Login button
                            NovoNordiskButton(
                                title: viewModel.isLoading ? LocalizedStrings.loading : LocalizedStrings.loginButton,
                                style: .primary,
                                isEnabled: viewModel.canLogin
                            ) {
                                Task {
                                    await viewModel.login()
                                }
                            }
                            .disabled(!viewModel.canLogin)
                            
                            // Register button
                            NovoNordiskButton(
                                title: LocalizedStrings.registerButton,
                                style: .outline
                            ) {
                                registerAction()
                            }
                            .disabled(viewModel.isLoading)
                        }
                    }
                    .padding(.horizontal, 24)
                    

                }
                .frame(minHeight: geometry.size.height)
            }
        }
        .background(Color.white)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onChange(of: viewModel.isAuthenticated) { isAuthenticated in
            if isAuthenticated {
                onAuthenticationSuccess()
            }
        }
        .fullScreenCover(isPresented: $showForgotPassword) {
            ForgotPasswordView {
                showForgotPassword = false
            }
        }
    }
    
    private func registerAction() {
        print("Register tapped")
        // Here you would navigate to registration screen
    }
}

// MARK: - SwiftUI Previews
#Preview {
    LoginView()
        .environmentObject(LoginViewModel())
} 
