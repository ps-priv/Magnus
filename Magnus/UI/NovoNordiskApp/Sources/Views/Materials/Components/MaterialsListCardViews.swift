import SwiftUI
import MagnusFeatures
import MagnusDomain

struct MaterialsListCardView: View {
    let materials: [ConferenceMaterialListItem]

    init(materials: [ConferenceMaterialListItem]) {
        self.materials = materials
    }

    var body: some View {
        ScrollView {
            EventNavigationBar
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(materials, id: \.id) { material in
                    //AcademyMaterialRowItem(material: material)
                }
            }
        }
    }

    @ViewBuilder
    var EventNavigationBar: some View {
        HStack(spacing: 15) {
            Button(action: {
                //navigationManager.popToRoot()
            }) {
                FAIcon(FontAwesome.Icon.file, type: .light, size: 16, color: .novoNordiskBlue)
                Text(LocalizedStrings.materialsListTabGeneral)
                    .font(.novoNordiskMiddleText)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskBlue)
            }

            Button(action: {

            }) {
                FAIcon(FontAwesome.Icon.calendar, type: .light, size: 16, color: .novoNordiskBlue)
                Text(LocalizedStrings.materialsListTabForEvent)
                    .font(.novoNordiskMiddleText)
                    .foregroundColor(Color.novoNordiskBlue)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    let response = MaterialsDetailsJsonMockGenerator.generateObject()



    VStack {
        MaterialsListCardView(materials: response?.materials ?? [])
    }
    .padding()
    .background(Color.novoNordiskBackgroundGrey)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}

