import SwiftUI

struct EventListEmptyStateView: View {
    @EnvironmentObject var navigationManager: NavigationManager

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            FAIcon(.calendar, type: .light, size: 60, color: .novoNordiskBlue)
            Text(LocalizedStrings.eventsListEmptyStateTitle)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.novoNordiskBlue)

            Text(LocalizedStrings.eventsListEmptyStateDescription)
                .font(.body)
                .foregroundColor(.novoNordiskBlue)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()
            EventsListLink(action: {
                navigationManager.navigate(to: .eventsList)
                print("eventsListLink tapped")
            })
        }
    }
}