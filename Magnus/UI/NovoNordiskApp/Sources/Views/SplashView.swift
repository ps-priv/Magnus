import SwiftUI
import Foundation

struct SplashView: View {
    @State private var isActive = false
    @State private var logoOpacity = 0.0
    @State private var logoScale = 0.5
    @State private var backgroundOpacity = 1.0
    
    var body: some View {
        ZStack {
            // Background
            Color.white
            .ignoresSafeArea()
            .opacity(backgroundOpacity)
            
            VStack(spacing: 20) {
                // Logo/Icon
                Image("NovoNordiskLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(40) 
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                

                // Version Info
                .opacity(logoOpacity)
            }
        }
        .onAppear {
            startSplashAnimation()
        }
        .fullScreenCover(isPresented: $isActive) {
            NovoNordiskContentView()
        }
    }
    
    private func startSplashAnimation() {
        // Animate logo appearance
        withAnimation(.easeOut(duration: 2.0)) {
            logoOpacity = 1.0
            logoScale = 1.0
        }
        
        // After 2.5 seconds, transition to main view
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                backgroundOpacity = 0.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isActive = true
            }
        }
    }
}

#Preview{
    SplashView()
}

