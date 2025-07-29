import SwiftUI

struct AcademyCategoryItemView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(Color.novoNordiskTextGrey)
            Spacer()
            FAIcon(.circle_arrow_right, size: 24, color: Color.novoNordiskLightBlue)
        }
        .frame(maxWidth: .infinity, maxHeight: 75)
        .padding(.horizontal, 20)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 0)
    }
}

#Preview {
    VStack {
        AcademyCategoryItemView(title: "Diabetologia")
    }
    .padding(.horizontal, 20)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(.systemGray6))
}
