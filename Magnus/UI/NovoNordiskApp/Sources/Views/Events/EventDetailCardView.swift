import SwiftUI
import MagnusDomain
import MagnusApplication
import MagnusFeatures

struct EventDetailCardView: View {
    let event: ConferenceEventDetails 
    @EnvironmentObject var navigationManager: NavigationManager

    init(event: ConferenceEventDetails) {
        self.event = event
    }

    var body: some View {
        VStack {
            
        }
    }
}

#Preview("EventDetailCardView") {

    let event = EventDetailsJsonMockGenerator.generateObject()
    
    VStack {
        if let event = event {
            EventDetailCardView(event: event)
            .environmentObject(NavigationManager())
        }
    }   
}