import MagnusDomain
import MagnusFeatures
import SwiftUI

struct EventAgendaCardView: View {
    let event: ConferenceEventDetails

    init(event: ConferenceEventDetails) {
        self.event = event
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(event.name)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskTextGrey)

            TabView {
                Text("Dzień 1")
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                Text("Dzień 2")
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(16)
        .background(Color.novoNordiskBackgroundGrey)
    }
}

#Preview("EventAgendaCardView") {

    let event = EventDetailsJsonMockGenerator.generateObject()

    VStack {
        if let event = event {
            EventAgendaCardView(event: event)
        } else {
            Text("Event not found")
        }
    }

}
