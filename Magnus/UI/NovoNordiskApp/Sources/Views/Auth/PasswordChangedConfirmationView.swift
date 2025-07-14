import SwiftUI

struct PasswordChangedConfirmationView: View {
    let onGoToLogin: () -> Void
    
    init(onGoToLogin: @escaping () -> Void) {
        self.onGoToLogin = onGoToLogin
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                        // Bottom logo at top
                        VStack(spacing: 16) {
                            Image("NovoNordiskLogo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 120)
                                .opacity(0.8)
                        }
                        .padding(.top, 40)
                        
                        Spacer(minLength: geometry.size.height * 0.15)
                        
                        // Content section
                        VStack(spacing: 40) {
                            
                            // Success icon
                            ZStack {
                                FAIcon(
                                    .circle_check,
                                    type: .light,
                                    size: 180,
                                    color: Color("NovoNordiskBlue")
                                )
                            }
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0), value: true)
                            
                            // Message
                            VStack(spacing: 16) {
                                Text(LocalizedStrings.passwordChangedMessage)
                                    .font(.novoNordiskBody)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(4)
                                    .padding(.horizontal, 32)
                            }
                        }
                        
                        Spacer(minLength: 40)
                        
                        // Bottom section
                        VStack(spacing: 32) {
                            
                            // Go to login button
                            NovoNordiskButton(
                                title: LocalizedStrings.goToLogin,
                                style: .primary
                            ) {
                                onGoToLogin()
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    .frame(minHeight: geometry.size.height)
                }
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            // Add haptic feedback for success
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
    }
}

#Preview {
    PasswordChangedConfirmationView {
        print("Go to login tapped")
    }
} 