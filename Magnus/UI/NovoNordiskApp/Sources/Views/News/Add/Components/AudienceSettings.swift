import SwiftUI
import Foundation
import MagnusDomain

struct AudienceSettings: View {
    enum Mode: String, CaseIterable, Identifiable {
        case all
        case selected

        var id: String { rawValue }

        var title: String {
            switch self {
            case .all: return LocalizedStrings.audienceSettingsAll
            case .selected: return LocalizedStrings.audienceSettingsSelected
            }
        }
    }

    @Binding var selectedGroups: [NewsGroup]
    @State private var mode: Mode = .all
    var availableGroups: [NewsGroup] = []

    // Available groups to choose from
    // private let availableGroups: [NewsGroup] = [
    //     .init(id: "grupaA", name: "grupaA"),
    //     .init(id: "grupaB", name: "grupaB"),
    //     .init(id: "grupaC", name: "grupaC")
    // ]

    init(selectedGroups: Binding<[NewsGroup]>, availableGroups: [NewsGroup]) {
        self._selectedGroups = selectedGroups
        self.availableGroups = availableGroups
        // Derive initial mode from the provided selection
        let initialMode: Mode = selectedGroups.wrappedValue.isEmpty ? .all : .selected
        self._mode = State(initialValue: initialMode)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Combo box (drop-down) with precise styling via Menu
            Menu {
                Button(Mode.all.title) { mode = .all }
                Button(Mode.selected.title) { mode = .selected }
            } label: {
                HStack {
                    Text(mode.title)
                        .foregroundColor(Color.novoNordiskBlue)
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.down")
                        .renderingMode(.template)
                        .foregroundColor(Color.novoNordiskBlue)
                }
                .padding(.horizontal, 15)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, minHeight: 37, maxHeight: 37)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.novoNordiskBlue, lineWidth: 2)
            )

            if mode == .selected {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(availableGroups) { group in
                        Toggle(isOn: binding(for: group)) {
                            Text(group.name)
                        }
                        .tint(Color.novoNordiskBlue)
                    }
                }
                .padding(.leading, 2)
            }
        }
        .onChange(of: mode, initial: false) { _, newValue in
            if newValue == .all {
                selectedGroups.removeAll()
            }
        }
    }

    // MARK: - Helpers

    private func binding(for group: NewsGroup) -> Binding<Bool> {
        Binding<Bool>(
            get: { selectedGroups.contains(group) },
            set: { isOn in
                if isOn {
                    if !selectedGroups.contains(group) {
                        selectedGroups.append(group)
                    }
                } else {
                    selectedGroups.removeAll { $0 == group }
                }

                print("Selected groups: \(selectedGroups)")
            }
        )
    }
}

#Preview {

    @State @Previewable var selectedGroups: [NewsGroup] = []

    let availableGroups: [NewsGroup] = [
        .init(id: "grupaA", name: "Kardio"),
        .init(id: "grupaB", name: "Badania i rozwój"),
        .init(id: "grupaC", name: "Produkty")
    ]

    AudienceSettings(selectedGroups: $selectedGroups, availableGroups: availableGroups)
            .padding()

}