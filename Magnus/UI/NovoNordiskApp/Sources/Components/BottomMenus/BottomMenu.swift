import SwiftUI

// MARK: - Bottom Menu Tab Item
enum BottomMenuTab: Int, CaseIterable {
    case start = 0
    case news = 1
    case events = 2
    case materials = 3
    case academy = 4
    
    var icon: FontAwesome.Icon {
        switch self {
        case .start:
            return .home
        case .news:
            return .newspaper
        case .events:
            return .calendar
        case .materials:
            return .fileAlt
        case .academy:
            return .graduationCap
        }
    }
    
    var title: String {
        switch self {
        case .start:
            return NSLocalizedString("BOTTOM_MENU_START", comment: "")
        case .news:
            return NSLocalizedString("BOTTOM_MENU_NEWS", comment: "")
        case .events:
            return NSLocalizedString("BOTTOM_MENU_EVENTS", comment: "")
        case .materials:
            return NSLocalizedString("BOTTOM_MENU_MATERIALS", comment: "")
        case .academy:
            return NSLocalizedString("BOTTOM_MENU_ACADEMY", comment: "")
        }
    }
}

// MARK: - Bottom Menu Item View
struct BottomMenuItemView: View {
    let tab: BottomMenuTab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                FAIcon(
                    tab.icon,
                    type: .thin,
                    size: 24,
                    color: isSelected ? Color.novoNordiskSelectedLightBlue : Color.novoNordiskBlue
                )
                
                Text(tab.title)
                    .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? Color.novoNordiskSelectedLightBlue :
                                     Color.novoNordiskBlue)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

// MARK: - Bottom Menu View
struct BottomMenu: View {
    @Binding var selectedTab: BottomMenuTab
    let onTabSelected: ((BottomMenuTab) -> Void)?
    
    init(selectedTab: Binding<BottomMenuTab>, onTabSelected: ((BottomMenuTab) -> Void)? = nil) {
        self._selectedTab = selectedTab
        self.onTabSelected = onTabSelected
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Separator line
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 0.5)
            
            // Menu items
            HStack(spacing: 0) {
                ForEach(BottomMenuTab.allCases, id: \.rawValue) { tab in
                    BottomMenuItemView(
                        tab: tab,
                        isSelected: selectedTab == tab
                    ) {
                        selectedTab = tab
                        onTabSelected?(tab)
                    }
                }
            }
            .padding(.top, 20)
            .background(Color.white)
        }
        .background(Color.white)
        .shadow(
            color: Color.black.opacity(0.1),
            radius: 8,
            x: 0,
            y: -2
        )
    }
}

// MARK: - Bottom Menu Container
struct BottomMenuContainer<Content: View>: View {
    @State private var selectedTab: BottomMenuTab = .start
    let content: (BottomMenuTab) -> Content
    
    init(@ViewBuilder content: @escaping (BottomMenuTab) -> Content) {
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Main content area
                content(selectedTab)
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height - bottomMenuHeight(geometry: geometry)
                    )
                
                // Bottom menu
                BottomMenu(selectedTab: $selectedTab)
                    .frame(height: bottomMenuHeight(geometry: geometry))
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private func bottomMenuHeight(geometry: GeometryProxy) -> CGFloat {
        let safeAreaBottom = geometry.safeAreaInsets.bottom
        let menuHeight: CGFloat = 60
        return menuHeight + safeAreaBottom
    }
}

// MARK: - Preview
#Preview("Bottom Menu") {
    VStack {
        Spacer()
        BottomMenu(selectedTab: .constant(.start))
    }
    .background(Color.gray.opacity(0.1))
}

#Preview("Bottom Menu Container") {
    BottomMenuContainer { selectedTab in
        VStack {
            Spacer()
            
            Text("Aktualnie wybrana zakładka:")
                .font(.headline)
                .foregroundColor(Color.novoNordiskBlue)
            
            Text(selectedTab.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskBlue)
            
            FAIcon(
                selectedTab.icon,
                type: .solid,
                size: 80,
                color: Color.novoNordiskBlue
            )
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}
