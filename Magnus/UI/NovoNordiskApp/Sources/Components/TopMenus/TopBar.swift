import SwiftUI

// MARK: - TopBarView
struct TopBarView: View {
    let title: String
    let showIcons: Bool
    
    init(title: String = "Moje konto", showIcons: Bool = true) {
        self.title = title
        self.showIcons = showIcons
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading)
            Spacer()
            
            if showIcons {
                HStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.primary)
                    Image(systemName: "envelope")
                        .foregroundColor(.primary)
                    Image(systemName: "bell")
                        .foregroundColor(.primary)
                    Image(systemName: "person.crop.circle")
                        .foregroundColor(.primary)
                }
                .padding(.trailing)
            }
        }
        .frame(height: 44)
        .background(
            Color.white
                .ignoresSafeArea(edges: .top)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        
    }
}

// MARK: - For Bottom Menu Integration
struct TopBarForBottomMenu: View {
    let selectedTab: BottomMenuTab
    
    var body: some View {
        TopBarView(title: selectedTab.title)
    }
}

#Preview("Top Bar") {
    VStack {
        TopBarView(title: "Ankieta")
        Spacer()
        BottomMenu(selectedTab: .constant(.start))
    }
}

#Preview("Bottom Menu Integration") {
    VStack {
        TopBarForBottomMenu(selectedTab: .events)
        Spacer()
        BottomMenu(selectedTab: .constant(.start))
    }
}


