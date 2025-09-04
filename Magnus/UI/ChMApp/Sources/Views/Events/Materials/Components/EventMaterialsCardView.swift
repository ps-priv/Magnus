import MagnusDomain
import MagnusFeatures
import MagnusApplication
import Kingfisher
import SwiftUI
import MapKit

struct EventMaterialsCardView: View {

    let event: ConferenceEventDetails
    @EnvironmentObject var navigationManager: NavigationManager

    init(event: ConferenceEventDetails) {
        self.event = event
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
        VStack(alignment: .leading) {
            EventTitleSection
            EventMaterialsListSection
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        }
    }

    @ViewBuilder
    private var EventTitleSection: some View {
        Text(event.name)
            .font(.novoNordiskCaption)
            .fontWeight(.bold)
            .foregroundColor(Color.novoNordiskTextGrey)
    }

    @ViewBuilder
    private var materialsTitle: some View {
        HStack {
            HStack {
                Text(LocalizedStrings.eventMaterialsScreenTitle)
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
    private var EventMaterialsListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            materialsTitle
            
            ForEach(event.materials, id: \.id) { material in
                MaterialItemComponent(file_type: material.file_type, name: material.name, publication_date: material.publication_date, link: material.link)
            }
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
