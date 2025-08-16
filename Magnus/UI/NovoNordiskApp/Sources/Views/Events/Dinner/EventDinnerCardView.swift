import MagnusDomain
import MagnusFeatures
import MagnusApplication
import Kingfisher
import SwiftUI
import MapKit

struct EventDinnerCardView: View {

    @State private var cameraPosition: MapCameraPosition = .automatic
    let dinner: ConferenceEventDinner
    let event_name: String

    init(dinner: ConferenceEventDinner, event_name: String) {
        self.dinner = dinner
        self.event_name = event_name
    }

    var body: some View {
        VStack(alignment: .leading) {
            eventTitleSection

            VStack(alignment: .leading) {
               dinnerTitle
               dinnerContent
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(Color.white)
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
    }

    @ViewBuilder
    private var eventTitleSection: some View {
        Text(event_name)
            .font(.novoNordiskCaption)
            .fontWeight(.bold)
            .foregroundColor(Color.novoNordiskTextGrey)
    }

    @ViewBuilder
    private var dinnerTitle: some View {
        HStack {
            HStack {
                FAIcon(.dinner, type: .regular, size: 20, color: Color.novoNordiskBlue)
                Text(LocalizedStrings.eventDinnerScreenTitle)
                    .font(.novoNordiskSectionTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskBlue)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            Spacer()
        }
        .background(Color.novoNordiskLighGreyForPanelBackground)
    }

    @ViewBuilder
    private var dinnerContent: some View {
        VStack(alignment: .leading) {
            Text(dinner.name)
                .font(.novoNordiskRegularText)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskTextGrey)
            
            HStack {
                Text(dinner.city)
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskTextGrey)
                Text("|")
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskTextGrey)
                Text(dinner.street)
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskTextGrey)
                Spacer()
            }

            Button {
                if let url = URL(string: dinner.www) {
                    UIApplication.shared.open(url)
                }
            } label: {
                    Text(dinner.getDomainAddressFromWww())
                        .font(.novoNordiskMiddleText)
                        .underline()
                        .foregroundColor(Color.novoNordiskLightBlue)
                }

            KFImage(URL(string: dinner.image))
                .placeholder {
                    Rectangle().fill(Color.gray.opacity(0.3))
                        .overlay(
                            VStack {
                                ProgressView()
                                    .scaleEffect(1.2)
                                    .tint(.novoNordiskBlue)
                                FAIcon(.image, type: .light, size: 40, color: .gray)
                                    .padding(.top, 8)
                            }
                        )
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 190)
                .clipped()
                .cornerRadius(12)

            Text(dinner.description)
                .font(.novoNordiskMiddleText)
                .foregroundColor(Color.novoNordiskTextGrey)


            let coord = CLLocationCoordinate2D(
                latitude: Double(dinner.latitude) ?? 0.0,
                longitude: Double(dinner.longitude) ?? 0.0
            )

            Map(position: $cameraPosition) {
                Marker(dinner.name, systemImage: "mappin", coordinate: coord)
            }
            .onAppear {
                cameraPosition = .camera(MapCamera(centerCoordinate: coord, distance: 800, heading: 0, pitch: 0))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

#Preview("EventDinnerCardView") {
    let event = EventDetailsJsonMockGenerator.generateObject()
    VStack {
        if let event = event {
            EventDinnerCardView(dinner: event.dinner, event_name: event.name)
        } else {
            Text("Event not found")
        }
    }
    .padding(16)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(Color.novoNordiskBackgroundGrey)
}
