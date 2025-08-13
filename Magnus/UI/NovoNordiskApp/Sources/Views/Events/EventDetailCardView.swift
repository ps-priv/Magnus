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
        ScrollView(.vertical, showsIndicators: true) {
            VStack (alignment: .leading) {
                EventNavigationBar

            }
        }
    }


    @ViewBuilder
    var EventNavigationBar : some View   {
        HStack(spacing: 15) {
            Button(action: {
                //navigationManager.popToRoot()
            }) {
                FAIcon(FontAwesome.Icon.calendar, type: .light, size: 16, color: .novoNordiskBlue)
                    Text(LocalizedStrings.eventTabEvent)
                    .font(.novoNordiskMiddleText)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskBlue)
            }

            Button(action: {
                //navigationManager.popToRoot()
            }) {
                FAIcon(FontAwesome.Icon.file, type: .light, size: 16, color: .novoNordiskBlue)
                    Text(LocalizedStrings.eventTabMaterials)
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskBlue)
            }

            Button(action: {
                //navigationManager.popToRoot()
            }) {
                FAIcon(FontAwesome.Icon.image, type: .light, size: 16, color: .novoNordiskBlue)
                    Text(LocalizedStrings.eventTabPhotobooth)
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskBlue)
            }

            Spacer()

            giftsSection
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    var giftsSection: some View {
        Menu {
            Button {
               // onEditTap()
            } label: {
                Label(LocalizedStrings.eventGifts, systemImage: "pencil")
            }
        } label: {
            FAIcon(
                FontAwesome.Icon.ellipsisVertical,
                type: .light,
                size: 16,
                color: Color.novoNordiskTextGrey
            )
        }
        .menuStyle(BorderlessButtonMenuStyle())
        .background(Color.white)
    }
}


#Preview("EventDetailCardView") {

    let event = EventDetailsJsonMockGenerator.generateObject()

    VStack {
        if let event = event {
            EventDetailCardView(event: event)
            .environmentObject(NavigationManager())
        } else {
            Text("Event not found")
        }
    }
    .padding(16)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.novoNordiskBackgroundGrey) 
}