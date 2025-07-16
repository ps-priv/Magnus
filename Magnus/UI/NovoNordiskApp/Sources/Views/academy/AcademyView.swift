import SwiftUI

struct AcademyView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    FAIcon(.graduationCap, type: .solid, size: 60, color: .novoNordiskBlue)
                    Text("Novo Nordisk Academy")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.novoNordiskBlue)
                    Text("Centrum edukacyjne dla profesjonalistów medycznych")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                
                // Coming Soon
                VStack(spacing: 16) {
                    FAIcon(.settings, type: .light, size: 40, color: .gray)
                    Text("Wkrótce dostępne")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                    Text("Pracujemy nad nową sekcją Academy. Znajdziesz tutaj kursy online, webinary i materiały edukacyjne.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
        .background(Color(.systemGray6))
    }
}

#Preview {
    AcademyView()
} 
