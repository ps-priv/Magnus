import SwiftUI

// MARK: - Ankieta Thank You View
struct AnkietaThankYouView: View {
    let onClose: () -> Void
    
    init(onClose: @escaping () -> Void = {}) {
        self.onClose = onClose
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            TopBarView(title: "Ankieta")
            
            // Main Content
            VStack(spacing: 40) {
                Spacer()
                
                // Thank you content
                VStack(spacing: 24) {
                    // Main heading
                    Text("Dziękujemy!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    // Subtitle
                    Text("To już wszystko.")
                        .font(.title3)
                        .foregroundColor(.primary)
                    
                    // Checkmark icon
                    Circle()
                        .stroke(Color.novoNordiskBlue, lineWidth: 8)
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(Color.novoNordiskBlue)
                        )
                        .padding(.vertical, 20)
                    
                    // Description text
                    VStack(spacing: 8) {
                        Text("Dziękujemy za Twój")
                            .font(.body)
                            .foregroundColor(.secondary)
                        Text("czas i wkład w ulepszenie")
                            .font(.body)
                            .foregroundColor(.secondary)
                        Text("kolejnych spotkań")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                // Close button
                Button(action: onClose) {
                    Text("Zamknij")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.novoNordiskBlue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
        }
        .navigationBarHidden(true)
    }
}



// MARK: - Preview
#Preview("Ankieta Thank You") {
    AnkietaThankYouView {
        print("Close tapped")
    }
            BottomMenu(selectedTab: .constant(.start))
}

#Preview("Comparison") {
    VStack(spacing: 0) {
        AnkietaThankYouView()
                BottomMenu(selectedTab: .constant(.start))
    }
} 