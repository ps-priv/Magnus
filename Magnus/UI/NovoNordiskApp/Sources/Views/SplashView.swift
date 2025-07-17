import SwiftUI
import Foundation
#if DEBUG
import Inject
#endif

struct SplashView: View {
    let onAnimationComplete: () -> Void
    
    @State private var ballOpacity = 1.0
    @State private var ballOffset: CGFloat = -200
    @State private var ballScale = 0.1
    @State private var logoOpacity = 0.0
    @State private var logoScale = 0.0
    @State private var backgroundOpacity = 1.0
    @State private var showLogo = false
    #if DEBUG
    @ObserveInjection var inject
    #endif
    
    init(onAnimationComplete: @escaping () -> Void = {}) {
        self.onAnimationComplete = onAnimationComplete
    }
    
    var body: some View {
        ZStack {
            // Background
            Color.white
            .ignoresSafeArea()
            .opacity(backgroundOpacity)
            
            ZStack {
                // Animated Dot
                if !showLogo {
                    Circle()
                        .fill(Color.novoNordiskBlue)
                        .frame(width: 15, height: 15)
                        .scaleEffect(ballScale)
                        .opacity(ballOpacity)
                        .offset(y: ballOffset)
                        .transition(.scale.combined(with: .opacity))
                }
                
                // Logo/Icon (morphs from dot)
                if showLogo {
                    Image("NovoNordiskLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(40)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .onAppear {
            startSplashAnimation()
        }
        #if DEBUG
        .enableInjection()
        #endif
    }
    
    private func startSplashAnimation() {
        // Phase 1: Dot flies down from top and grows
        withAnimation(.easeOut(duration: 1.0)) {
            ballOffset = 0  // Move to center
            ballScale = 1.0  // Grow to full size
        }
        
        // Phase 2: Smooth transformation from dot to logo
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.3)) {
                showLogo = true  // This triggers the transition
                logoOpacity = 1.0
                logoScale = 1.0
            }
        }
        
        // Phase 3: Complete animation and notify parent
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                backgroundOpacity = 0.0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onAnimationComplete()
            }
        }
    }
}

#Preview{
    SplashView()
}

