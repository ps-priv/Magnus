import MagnusDomain
import MagnusFeatures
import Pow
import Sentry
import SwiftUI
import OneSignalFramework

struct LoginView: View {
    let onAuthenticationSuccess: () -> Void

    @StateObject private var viewModel = LoginViewModel()
    @State private var showError = false
    @State private var showForgotPassword = false
    @State private var showRegister = false
    @State private var showRegisterConfirmation = false

    init(onAuthenticationSuccess: @escaping () -> Void = {}) {
        self.onAuthenticationSuccess = onAuthenticationSuccess
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
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
                    VStack(spacing: 10) {
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
                            .changeEffect(.shake(rate: .fast), value: viewModel.LoginAttempts)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            NovoNordiskTextBox(
                                placeholder: LocalizedStrings.passwordPlaceholder,
                                text: $viewModel.password,
                                style: .withTitle(LocalizedStrings.passwordLabel, bold: true),
                                isSecure: true,
                            )
                            .changeEffect(.shake(rate: .fast), value: viewModel.LoginAttempts)
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
                        // .padding(.top, 8)
                        Spacer(minLength: 20)

                        // Loading indicator
                        if viewModel.isLoading {
                            LoadingIndicator()
                        }

                        // Buttons
                        VStack(spacing: 16) {
                            // Login button
                            NovoNordiskButton(
                                title: viewModel.isLoading
                                    ? LocalizedStrings.loading : LocalizedStrings.loginButton,
                                style: .primary,
                                isEnabled: viewModel.canLogin
                            ) {
                                Task {
                                    await viewModel.login()

                                    if viewModel.isLoggedIn && !viewModel.userId.isEmpty {
                                        OneSignal.login(viewModel.userId)
                                        OneSignal.User.addTag(key: "user_id", value: viewModel.userId)
                                        OneSignal.User.addTag(key: "user_id_int", value: String(viewModel.userIdInt))
                                    }
                                }
                            }   
                            .disabled(!viewModel.canLogin)

                            // Register button
                            // NovoNordiskButton(
                            //     title: LocalizedStrings.registerButton,
                            //     style: .outline
                            // ) {
                            //     showRegister = true
                            // }
                            // .disabled(viewModel.isLoading)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .frame(minHeight: geometry.size.height)
                .padding(.bottom, 16)
                .scrollDismissesKeyboard(.interactively)
            }
        }
        .background(Color.white)
        .onChange(of: viewModel.isAuthenticated) { _, isAuthenticated in
            if isAuthenticated {
                onAuthenticationSuccess()
            }
        }
        .fullScreenCover(isPresented: $showForgotPassword) {
            ForgotPasswordView {
                showForgotPassword = false
            }
        }
        .fullScreenCover(isPresented: $showRegister) {
            RegisterUserView(
                onRegister: {
                    showRegister = false
                    showRegisterConfirmation = true
                },
                onCancel: {
                    showRegister = false
                }
            )
        }
        .fullScreenCover(isPresented: $showRegisterConfirmation) {
            RegisterConfirmationView(onMoveToLogin: {
                showRegister = false
                showRegisterConfirmation = false
            })
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(LoginViewModel())
}
