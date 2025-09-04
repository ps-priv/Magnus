import MagnusDomain
import MagnusFeatures
import MagnusApplication
import SwiftUI
import Foundation

struct MaterialsInEvent: View {
    let eventMaterials: ConferenceMaterialsDto
    let selectedMaterialId: String?

    init(eventMaterials: ConferenceMaterialsDto, selectedMaterialId: String?) {
        self.eventMaterials = eventMaterials
        self.selectedMaterialId = selectedMaterialId
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if eventMaterials.hasMaterials() {
                eventTitle
                ForEach(Array(eventMaterials.eventMaterials.enumerated()), id: \.offset) { index, item in
                    MaterialRowItem(material: item, isSelected: item.id == selectedMaterialId)
                        .id(item.id)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var eventTitle: some View {
        VStack {
            HStack(alignment: .top) {
                FAIcon(
                    FontAwesome.Icon.calendar,
                    type: .light,
                    size: 18,
                    color: .novoNordiskBlue
                )
                .padding(.top, 4)
                VStack(alignment: .leading) {    
                    Text(eventMaterials.event_title)
                        .font(.novoNordiskBody)
                        .fontWeight(.bold)
                        .foregroundColor(Color.novoNordiskBlue)
                        .lineLimit(1)
                        .multilineTextAlignment(.leading)
                    Text(PublishedDateHelper.formatDateRangeForEvent(eventMaterials.date_from, eventMaterials.date_to, LocalizedStrings.months, dateFormat: "yyyy-MM-dd"))
                        .font(.novoNordiskSmallText)
                        .fontWeight(.bold)
                        .foregroundColor(Color.novoNordiskBlue)
                }
                Spacer()
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.novoNordiskBlue)
        }

    }
}
