import SwiftUI
import MagnusFeatures
import MagnusDomain

struct MaterialsListCardView: View {
    let materials: [ConferenceMaterialListItem]
    
    private enum Tab: Equatable {
        case general
        case forEvent
    }

    @State private var selectedTab: Tab = .general

    init(materials: [ConferenceMaterialListItem]) {
        self.materials = materials
    }

    var body: some View {
        ScrollView {
            MaterialsNavigationBar
            Group {
                switch selectedTab {
                case .general:
                    GeneralTabContent
                case .forEvent:
                    ForEventTabContent
                }
            }
        }
    }

    @ViewBuilder
    var MaterialsNavigationBar: some View {
        HStack(spacing: 16) {
            // General tab
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) { selectedTab = .general }
            }) {
                HStack(spacing: 6) {
                    FAIcon(FontAwesome.Icon.file, type: .light, size: 16, color: .novoNordiskBlue)
                    Text(LocalizedStrings.materialsListTabGeneral)
                        .font(.novoNordiskMiddleText)
                        .fontWeight(selectedTab == .general ? .bold : .regular)
                        .foregroundColor(Color.novoNordiskBlue)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                //.background(selectedTab == .general ? Color.novoNordiskBlue.opacity(0.1) : Color.clear)
                .cornerRadius(8)
            }

            // For Event tab
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) { selectedTab = .forEvent }
            }) {
                HStack(spacing: 6) {
                    FAIcon(FontAwesome.Icon.calendar, type: .light, size: 16, color: .novoNordiskBlue)
                    Text(LocalizedStrings.materialsListTabForEvent)
                        .font(.novoNordiskMiddleText)
                        .fontWeight(selectedTab == .forEvent ? .bold : .regular)
                        .foregroundColor(Color.novoNordiskBlue)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                //.background(selectedTab == .forEvent ? Color.novoNordiskBlue.opacity(0.1) : Color.clear)
                .cornerRadius(8)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Tab Contents
    @ViewBuilder
    private var GeneralTabContent: some View {
        // Placeholder content. Replace with actual list when row view is available.
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizedStrings.materialsListTabGeneral)
                .font(.novoNordiskMiddleText)
                .foregroundColor(.novoNordiskBlue)
            Text("\(materials.count)")
                .font(.novoNordiskMiddleText)
                .foregroundColor(.novoNordiskGrey)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
    }

    @ViewBuilder
    private var ForEventTabContent: some View {
        // Placeholder content for event-specific materials
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizedStrings.materialsListTabForEvent)
                .font(.novoNordiskMiddleText)
                .foregroundColor(.novoNordiskBlue)
            Text("\(materials.count)")
                .font(.novoNordiskMiddleText)
                .foregroundColor(.novoNordiskGrey)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
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


