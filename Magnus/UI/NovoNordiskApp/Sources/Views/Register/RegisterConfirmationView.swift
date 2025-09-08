import SwiftUI

struct RegisterConfirmationView: View {

    let onMoveToLogin: () -> Void

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {
                           // Bottom logo
                            VStack(spacing: 16) {
                                Image("NovoNordiskLogo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 120)
                                    .opacity(0.8)
                            }
                            .padding(.top, 40)
                            .padding(.bottom, 30)
                                      
                        // Content section
                        VStack() {

                            Text(LocalizedStrings.registerConfirmationTitle)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.novoNordiskBlue)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                            
                            Spacer()

                            // Success icon 
                            ZStack {
                                FAIcon(
                                    .circle_check,
                                    type: .light,
                                    size: 180,
                                    color: Color("NovoNordiskBlue").opacity(0.7)
                                )
                            }
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0), value: true)

                            Spacer()
                            
                            // Message
                            VStack() {
                                Text(LocalizedStrings.emailSentMessage)
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
                            
                            // Go to password reset button
                            NovoNordiskButton(
                                title: LocalizedStrings.registerMoveToLogin,
                                style: .primary
                            ) {
                                onMoveToLogin()
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
    RegisterConfirmationView(onMoveToLogin: {})
}
