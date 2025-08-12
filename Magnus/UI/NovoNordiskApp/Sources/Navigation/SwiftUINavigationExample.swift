import SwiftUI
import MagnusFeatures
import MagnusDomain

// MARK: - NavigationStack Based Navigation (Alternative approach)
struct SwiftUINavigationExample: View {
    @State private var navigationPath = NavigationPath()
    @State private var selectedTab: BottomMenuTab = .start
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            TabView(selection: $selectedTab) {
                // Events Tab
                // EventsNavigationView()
                //     .tabItem {
                //         FAIcon(.calendar, type: .light)
                //         Text("Wydarzenia")
                //     }
                //     .tag(BottomMenuTab.events)
                
                // Materials Tab  
                MaterialsNavigationView()
                    .tabItem {
                        FAIcon(.fileAlt, type: .light)
                        Text("Materiały")
                    }
                    .tag(BottomMenuTab.materials)
                
                // News Tab
                NewsNavigationView()
                    .tabItem {
                        FAIcon(.newspaper, type: .light)
                        Text("Aktualności")
                    }
                    .tag(BottomMenuTab.news)
            }
        }
    }
}


// MARK: - Materials Navigation with NavigationStack
struct MaterialsNavigationView: View {
    @State private var materials: [Material] = MaterialMockData.sampleMaterials
    
    var body: some View {
        List(materials) { material in
            NavigationLink(value: material) { // ✨ Przekazujemy cały obiekt Material
                MaterialRowView(material: material)
            }
        }
        .navigationTitle("Materiały")
        .navigationDestination(for: Material.self) { material in // ✨ Odbieramy Material
            MaterialDetailSwiftUIView(material: material) // ✨ Przekazujemy do detail view
        }
    }
}

// MARK: - News Navigation with NavigationStack
struct NewsNavigationView: View {
    @State private var newsItems: [NewsItem] = NewsItemMockGenerator.createMany(count: 5)
    
    var body: some View {
        List(newsItems) { newsItem in
            NavigationLink(value: newsItem) { // ✨ Przekazujemy cały obiekt NewsItem
                NewsRowView(newsItem: newsItem)
            }
        }
        .navigationTitle("Aktualności")
        .navigationDestination(for: NewsItem.self) { newsItem in // ✨ Odbieramy NewsItem
            NewsDetailSwiftUIView(newsItem: newsItem) // ✨ Przekazujemy do detail view
        }
    }
}

// MARK: - Simple Row Views
struct EventRowView: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.title).font(.headline)
            Text(event.formattedDate).font(.caption).foregroundColor(.secondary)
        }
    }
}

struct MaterialRowView: View {
    let material: Material
    
    var body: some View {
        HStack {
            FAIcon(material.type.icon, type: .light, size: 20, color: .blue)
            VStack(alignment: .leading) {
                Text(material.title).font(.headline)
                Text(material.type.displayName).font(.caption).foregroundColor(.secondary)
            }
        }
    }
}

struct NewsRowView: View {
    let newsItem: NewsItem
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(newsItem.title).font(.headline)
            Text(newsItem.formattedPublishDate).font(.caption).foregroundColor(.secondary)
        }
    }
}

// MARK: - SwiftUI Detail Views (receive full objects)
struct EventDetailSwiftUIView: View {
    let event: Event // ✨ Odbieramy cały obiekt!
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(event.title).font(.title).bold()
                Text(event.description)
                Text("Lokalizacja: \(event.location)")
                Text("Data: \(event.formattedDateRange)")
            }
            .padding()
        }
        .navigationTitle("Szczegóły")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MaterialDetailSwiftUIView: View {
    let material: Material // ✨ Odbieramy cały obiekt!
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(material.title).font(.title).bold()
                Text(material.description)
                Text("Typ: \(material.type.displayName)")
                if let fileSize = material.fileSize {
                    Text("Rozmiar: \(fileSize)")
                }
            }
            .padding()
        }
        .navigationTitle("Szczegóły")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NewsDetailSwiftUIView: View {
    let newsItem: NewsItem // ✨ Odbieramy cały obiekt!
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(newsItem.title).font(.title).bold()
                //Text(newsItem.summary)
                Text("Data: \(newsItem.formattedPublishDate)")
            }
            .padding()
        }
        .navigationTitle("Szczegóły")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SwiftUINavigationExample()
} 
