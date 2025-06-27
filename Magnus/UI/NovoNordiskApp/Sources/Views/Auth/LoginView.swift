import SwiftUI
import MagnusFeatures

struct LoginView: View {
    let onAuthenticationSuccess: () -> Void
    
    @StateObject private var viewModel = LoginViewModel()
    @State private var showError = false
    
    init(onAuthenticationSuccess: @escaping () -> Void = {}) {
        self.onAuthenticationSuccess = onAuthenticationSuccess
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Top section with logo and title
                    VStack(spacing: 24) {
                        // Title
                        Text(LocalizedStrings.loginTitle)
                            .font(.novoNordiskTitle)
                            .foregroundColor(Color("NovoNordiskBlue"))
                            .tracking(2)
                    }
                    .padding(.bottom, 60)
                    .padding(.top, geometry.safeAreaInsets.top + 24)
                    
                    // Login form
                    VStack(spacing: 24) {
 
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
                                print("Forgot password tapped")
                            }
                            
                            Spacer()
                        }
                        //.padding(.top, 8)
                        
                        // Buttons
                        VStack(spacing: 16) {
                            // Error message
                            if !viewModel.errorMessage.isEmpty {
                                Text(viewModel.errorMessage)
                                    .font(.novoNordiskCaption)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 16)
                                    .onTapGesture {
                                        viewModel.clearError()
                                    }
                            }
                            
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
                        //.padding(.top, 12)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                    
                    // Bottom logo
                    VStack(spacing: 16) {
                        Image("NovoNordiskLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 120)
                            .opacity(0.8)
                    }
                    .padding(.bottom, 40)
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
    }
    
    private func registerAction() {
        print("Register tapped")
        // Here you would navigate to registration screen
    }
}

#Preview {
    LoginView()
} 
