import SwiftUI
import MapKit
import MagnusDomain

struct MapView: View {
    let location: ConferenceEventLocation

    @State private var region: MKCoordinateRegion

    init(location: ConferenceEventLocation) {
        self.location = location
        let latitude = Double(location.latitude) ?? 0.0
        let longitude = Double(location.longitude) ?? 0.0
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        _region = State(initialValue: MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [AnnotationItem(coordinate: region.center)]) { item in
            MapMarker(coordinate: item.coordinate, tint: .blue)
        }
        .cornerRadius(12)
    }
}

private struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

#Preview("MapView") {
    let sample = ConferenceEventLocation(
        name: "Venue",
        city: "City",
        zip_code: "00-000",
        street: "Street 1",
        latitude: "52.2297",
        longitude: "21.0122",
        image: "",
        phone: "",
        email: "",
        www: "https://example.com",
        header_description: "",
        description: ""
    )
    MapView(location: sample)
        .frame(height: 190)
        .padding()
}
