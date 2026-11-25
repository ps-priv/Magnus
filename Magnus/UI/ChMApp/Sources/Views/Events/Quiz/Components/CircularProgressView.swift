import SwiftUI

struct CircularProgressView: View {
    let percentage: Double
    let lineWidth: CGFloat = 20
    let size: CGFloat = 200
    
    private var progressColor: Color {
        Color(red: 0/255, green: 174/255, blue: 239/255) // Niebieski
    }
    
    private var remainingColor: Color {
        Color(red: 255/255, green: 102/255, blue: 0/255) // Pomarańczowy
    }
    
    var body: some View {
        ZStack {
            // Background circle (remaining part)
            Circle()
                .stroke(
                    remainingColor,
                    lineWidth: lineWidth
                )
                .frame(width: size, height: size)
            
            // Progress circle (completed part)
            Circle()
                .trim(from: 0, to: percentage / 100)
                .stroke(
                    progressColor,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: percentage)
            
            // Percentage text in center
            VStack(spacing: 4) {
                Text(String(format: "%.1f%%", percentage))
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(Color.novoNordiskBlue)
            }
        }
    }
}
