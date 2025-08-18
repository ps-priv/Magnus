import MagnusDomain
import MagnusFeatures
import MagnusApplication
import Kingfisher
import SwiftUI
import MapKit

struct EventLocationCardView: View {

    @State private var cameraPosition: MapCameraPosition = .automatic
    let location: ConferenceEventLocation
    let event_name: String

    init(location: ConferenceEventLocation, event_name: String) {
        self.location = location
        self.event_name = event_name
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
        VStack(alignment: .leading) {
            eventTitleSection

            VStack(alignment: .leading) {
               locationTitle
               locationContent
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(Color.white)
            .cornerRadius(25)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
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
    private var locationTitle: some View {
        HStack {
            HStack {
                FAIcon(.location, type: .regular, size: 20, color: Color.novoNordiskBlue)
                Text(LocalizedStrings.eventLocationScreenTitle)
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
    private var locationContent: some View {
        VStack(alignment: .leading) {
            Text(location.name)
                .font(.novoNordiskRegularText)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskTextGrey)
            
            HStack {
                Text(location.city)
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskTextGrey)
                Text("|")
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskTextGrey)
                Text(location.street)
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskTextGrey)
                Spacer()
            }

            Text(location.name)
                .font(.novoNordiskMiddleText)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskTextGrey)
            
                Button {
                    if let url = URL(string: location.www) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Text(location.getDomainAddressFromWww())
                        .font(.novoNordiskMiddleText)
                        .underline()
                        .foregroundColor(Color.novoNordiskLightBlue)
                }

            KFImage(URL(string: location.image))
                .placeholder {
                    Rectangle().fill(Color.gray.opacity(0.3))
                        .overlay(
                            VStack {
                                ProgressView()
                                    .scaleEffect(1.2)
                                    .tint(.novoNordiskBlue)
                                FAIcon(.newspaper, type: .light, size: 40, color: .gray)
                                    .padding(.top, 8)
                            }
                        )
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 190)
                .clipped()
                .cornerRadius(12)

            Text(location.description)
                .font(.novoNordiskMiddleText)
                .foregroundColor(Color.novoNordiskTextGrey)


            let coord = CLLocationCoordinate2D(
                latitude: Double(location.latitude) ?? 0.0,
                longitude: Double(location.longitude) ?? 0.0
            )

            Map(position: $cameraPosition) {
                Marker(location.name, systemImage: "mappin", coordinate: coord)
            }
            .frame(height: 200)
            .cornerRadius(12)
            .onAppear {
                cameraPosition = .camera(MapCamera(centerCoordinate: coord, distance: 800, heading: 0, pitch: 0))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

#Preview("EventLocationCardView") {
    let event = EventDetailsJsonMockGenerator.generateObject()
    VStack {
        if let event = event {
            EventLocationCardView(location: event.location, event_name: event.name)
        } else {
            Text("Event not found")
        }
    }
    .padding(16)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background(Color.novoNordiskBackgroundGrey)
}
