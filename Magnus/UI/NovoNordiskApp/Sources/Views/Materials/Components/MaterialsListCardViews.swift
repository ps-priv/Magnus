import SwiftUI
import MagnusFeatures
import MagnusDomain
import MagnusApplication
import Foundation

struct MaterialsListCardView: View {
    let materials: [ConferenceMaterialListItem]
    let materialId: String

    let generalMaterials: [ConferenceMaterialListItem]
    let eventMaterials: [ConferenceMaterialsDto]
    
    private enum Tab: Equatable {
        case general
        case forEvent
    }

    @State private var selectedTab: Tab = .general
    @State private var scrollTargetId: String?

    init(materials: [ConferenceMaterialListItem], materialId: String) {
        self.materials = materials
        self.materialId = materialId
        self.generalMaterials = MaterialsListHelper.getGeneralMaterials(materials: materials)
        self.eventMaterials = MaterialsListHelper.getEventMaterials(materials: materials)
    }

    private func selectMaterial(materialId: String) {
        guard !materialId.isEmpty else { return }
        // Check in general materials
        if generalMaterials.contains(where: { $0.id == materialId }) {
            print("Selected general material: \(materialId)")
            selectedTab = .general
            scrollTargetId = materialId
            return
        }
        // Check in event materials
        let existsInEvents = eventMaterials.contains { dto in
            dto.eventMaterials.contains(where: { $0.id == materialId })
        }
        if existsInEvents {
            print("Selected event material: \(materialId)")
            selectedTab = .forEvent
            scrollTargetId = materialId
        }
    }

    var body: some View {
        ScrollViewReader { proxy in
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
            .onAppear {
                // Decide initial tab and scroll when view appears
                selectMaterial(materialId: materialId)
                if let target = scrollTargetId {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation { proxy.scrollTo(target, anchor: .center) }
                    }
                }
            }
            .onChange(of: selectedTab) { _, _ in
                if let target = scrollTargetId {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation { proxy.scrollTo(target, anchor: .center) }
                    }
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
            ForEach(Array(generalMaterials.enumerated()), id: \.offset) { index, item in
                MaterialRowItem(material: item, isSelected: item.id == materialId)
                    .id(item.id)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
        .padding(.horizontal, 10)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }

    @ViewBuilder
    private var ForEventTabContent: some View {
        // Placeholder content for event-specific materials
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(eventMaterials.enumerated()), id: \.offset) { index, item in
               MaterialsInEvent(eventMaterials: item, selectedMaterialId: materialId)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 8)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    let response = MaterialsDetailsJsonMockGenerator.generateObject()

    VStack {
        MaterialsListCardView(materials: response?.materials ?? [], materialId: "eyJpZCI6NCwidG9rZW4iOiIzNXxTSUtXb3BrdHk4amhGNkN1RWZTNnIzcmMzcWxDRTBKSlF6cEtrekl1YzRmMDk2M2QifQ")
    }
    .padding()
    .background(Color.novoNordiskBackgroundGrey)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}



