import SwiftUI

struct AcademyView: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Button(action: {
                // TODO: Implement
            }) {
                VStack(alignment: .center) {
                    FAIcon(.user_doctor, type: .light, size: 56, color: .novoNordiskBlue)
                    Text(LocalizedStrings.academyDoctor)
                        .font(.headline)
                        .foregroundColor(Color.novoNordiskTextGrey)
                }
                .frame(maxWidth: 345, maxHeight: 165)
                .background(Color.white)
                .cornerRadius(12)
            }
            .padding(.bottom, 10)

            Button(action: {
                // TODO: Implement
            }) {
                VStack(alignment: .center) {
                    FAIcon(.user, type: .light, size: 56, color: .novoNordiskBlue)
                    Text(LocalizedStrings.academyPatient)
                        .font(.headline)
                        .foregroundColor(Color.novoNordiskTextGrey)
                }
                .frame(maxWidth: 345, maxHeight: 165)
                .background(Color.white)
                .cornerRadius(12)
            }

            Spacer()
        }
        .padding(.horizontal, 50)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGray6))
    }
}

#Preview {
    AcademyView()
}
