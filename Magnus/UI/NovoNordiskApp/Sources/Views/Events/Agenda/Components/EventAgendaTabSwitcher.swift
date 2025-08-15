import SwiftUI

struct EventAgendaTabItem2: Hashable {
    let id: Int
    let title: String
    let subtitle: String

    init(id: Int, title: String, subtitle: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
    }
}

struct EventAgendaTabSwitcher: View {
    
    @Binding var selectedIndex: Int
    let items: [EventAgendaTabItem2]

    init(selectedIndex: Binding<Int>, items: [EventAgendaTabItem2]) {
        self._selectedIndex = selectedIndex
        self.items = items
    }
    
    var body: some View {
        ControlGroup {
            ForEach(items, id: \.id) { item in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.22)) {
                        print("Selected item: \(item)")
                        selectedIndex = item.id
                        print("Selected index: \(selectedIndex)")
                    }
                }) {
                    VStack(spacing: 2) {
                        Text(item.title)
                            .font(.novoNordiskRegularText)
                            .fontWeight(.bold)
                            .foregroundStyle(selectedIndex == item.id ? Color.white : Color.novoNordiskBlue)
                            .frame(maxWidth: .infinity)

                        Text(item.subtitle)
                            .font(.novoNordiskMiddleText)
                            .foregroundStyle(selectedIndex == item.id ? Color.white : Color.novoNordiskBlue)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(RoundedCorner(radius: 12, corners: .allCorners))
                }
                .buttonStyle(.plain)
            }
        }
        .controlGroupStyle(EventAgendaPillControlGroupStyle(selectedIndex: selectedIndex, itemCount: items.count))
    }
}

// MARK: - ControlGroupStyle

struct EventAgendaPillControlGroupStyle: ControlGroupStyle {
    var selectedIndex: Int
    var itemCount: Int
    var horizontalPadding: CGFloat = 4
    var height: CGFloat = 56

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geo in
            let count = max(itemCount, 1)
            let itemWidth = (geo.size.width - horizontalPadding * 2) / CGFloat(count)

            ZStack(alignment: .leading) {
                RoundedCorner(radius: 12, corners: .allCorners)
                    .fill(Color.white)
                    .overlay(
                        RoundedCorner(radius: 12, corners: .allCorners)
                            .stroke(Color.novoNordiskBlue, lineWidth: 1)
                    )

                let isFirst = selectedIndex == 0
                let isLast = selectedIndex == count - 1
                let corners: UIRectCorner = isFirst ? [.topLeft, .bottomLeft] : (isLast ? [.topRight, .bottomRight] : [])
                RoundedCorner(radius: 12, corners: corners)
                    .fill(Color.novoNordiskBlue)
                    .frame(width: itemWidth, height: geo.size.height)
                    .animation(.easeInOut(duration: 0.22), value: selectedIndex)
                    .zIndex(0)

                HStack(spacing: 0) {
                    configuration.content
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
                .allowsHitTesting(true)
                .zIndex(1)
            }
            .clipShape(RoundedCorner(radius: 12, corners: .allCorners))
        }
        .frame(height: height)
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, 10)
    }
}

#Preview("EventAgendaTabSwitcher") {
    @State var selected = 0

    let items = [
        EventAgendaTabItem2(id: 0, title: "Dzień 1", subtitle: "17 maja 2025"),
        EventAgendaTabItem2(id: 1, title: "Dzień 2", subtitle: "18 maja 2025"),
        EventAgendaTabItem2(id: 2, title: "Dzień 3", subtitle: "19 maja 2025"),
    ]

    VStack {
        EventAgendaTabSwitcher(selectedIndex: $selected, items: items)
    }
    .padding(.horizontal, 30)
}
