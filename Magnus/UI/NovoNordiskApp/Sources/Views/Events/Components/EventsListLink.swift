import SwiftUI

struct EventsListLink: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                FAIcon(
                    FontAwesome.Icon.box_archive,
                    type: .thin,
                    size: 21,
                    color: Color.novoNordiskBlue
                )
                Text(LocalizedStrings.eventsListLinkToArchive)
                    .font(.system(size: 16))
                    .foregroundColor(Color.novoNordiskBlue)
                Spacer()
            }
            .padding(.bottom, 20)
        }
    }
}