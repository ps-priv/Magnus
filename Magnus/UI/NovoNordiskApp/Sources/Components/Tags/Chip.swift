import SwiftUI

struct Chip: View {
    let text: String
    let onDelete: (String) -> Void

    var body: some View {
        HStack {
            Text(text)
                .font(.novoNordiskMiddleText)
                .foregroundColor(.novoNordiskTextGrey)
                .padding(.leading, 6)
            Button {
                onDelete(text)
            } label: {
                FAIcon(.close, size: 16, color: Color.novoNordiskLightBlue)
                .padding(.trailing, 6)
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.novoNordiskLightBlue.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.novoNordiskLightBlue, lineWidth: 1)
        )
    }
}

#Preview {
    Chip(text: "#Kardiologia") { _ in }
}
