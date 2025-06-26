import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var isLoggedIn = false
    
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
                                text: $email,
                                style: .withTitle(LocalizedStrings.emailLabel, bold: true),
                            )
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        }
                        

                        VStack(alignment: .leading, spacing: 8) {
                            NovoNordiskTextBox(
                                placeholder: LocalizedStrings.passwordPlaceholder,
                                text: $password,
                                style: .withTitle(LocalizedStrings.passwordLabel, bold: true),
                                isSecure: true,
                            )
                        }
                        
                        // Forgot password link
                        HStack {
                            FAIcon(.questionCircle, type: .light)
                                .foregroundColor(Color("NovoNordiskBlue"))
                                .font(.system(size: 16))
                            
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
                            // Login button
                            NovoNordiskButton(
                                title: LocalizedStrings.loginButton,
                                style: .primary,
                                isEnabled: !email.isEmpty && !password.isEmpty && !isLoading
                            ) {
                                loginAction()
                            }
                            .disabled(isLoading)
                            
                            // Register button
                            NovoNordiskButton(
                                title: LocalizedStrings.registerButton,
                                style: .outline
                            ) {
                                registerAction()
                            }
                            .disabled(isLoading)
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
        .fullScreenCover(isPresented: $isLoggedIn) {
            NovoNordiskContentView()
        }
    }
    
    private func loginAction() {
        isLoading = true
        
        // Simulate login process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            print("Login attempt with email: \(email)")
            // Simulate successful login
            isLoggedIn = true
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
