import SwiftUI

struct EventAgendaTabItem: Hashable {
    let title: String
    let subtitle: String
}

struct EventAgendaTabsView: View {
    @Binding var selectedIndex: Int
    let items: [EventAgendaTabItem]

    private let cornerRadius: CGFloat = 14
    private let verticalPadding: CGFloat = 10
    private let horizontalPadding: CGFloat = 4

    var body: some View {
        GeometryReader { geo in
            let itemCount = max(items.count, 1)
            let itemWidth = (geo.size.width - horizontalPadding * 2) / CGFloat(itemCount)

            ZStack(alignment: .leading) {
                // Outer pill
                Capsule(style: .continuous)
                    .fill(Color.white)

                Capsule(style: .continuous)
                    .stroke(Color.novoNordiskBlue.opacity(0.15), lineWidth: 1)

                // Moving selection background
                Capsule(style: .continuous)
                    .fill(Color.novoNordiskBlue)
                    .frame(width: itemWidth - 2, height: geo.size.height - 2)
                    .offset(x: horizontalPadding + CGFloat(selectedIndex) * itemWidth + 1)
                    .animation(.easeInOut(duration: 0.22), value: selectedIndex)

                // Tabs content
                HStack(spacing: 0) {
                    ForEach(items.indices, id: \.self) { index in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.22)) {
                                selectedIndex = index
                            }
                        }) {
                            VStack(spacing: 2) {
                                Text(items[index].title)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(selectedIndex == index ? Color.white : Color.novoNordiskBlue)
                                    .frame(maxWidth: .infinity)

                                Text(items[index].subtitle)
                                    .font(.novoNordiskBody)
                                    .foregroundStyle(selectedIndex == index ? Color.white.opacity(0.85) : Color.novoNordiskTextGrey)
                                    .frame(maxWidth: .infinity)
                            }
                            .frame(width: itemWidth, height: geo.size.height)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .clipShape(Capsule(style: .continuous))
        }
        .frame(height: 56)
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
    }
}

#Preview("EventAgendaTabsView") {
    @State var selected = 0

    let items = [
        EventAgendaTabItem(title: "Dzień 1", subtitle: "17 maja 2025"),
        EventAgendaTabItem(title: "Dzień 2", subtitle: "18 maja 2025"),
    ]

    return VStack(alignment: .leading, spacing: 16) {
        EventAgendaTabsView(selectedIndex: $selected, items: items)
            .padding()
            .background(Color.novoNordiskBackgroundGrey)

        Text("Wybrano: \(items[selected].title)")
            .padding(.horizontal)
    }
}
