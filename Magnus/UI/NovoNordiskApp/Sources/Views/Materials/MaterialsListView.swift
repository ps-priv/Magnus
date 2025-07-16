import SwiftUI

struct MaterialsListView: View {
    @State private var materials: [Material] = MaterialMockData.sampleMaterials
    @State private var searchText = ""
    @State private var selectedType: MaterialType? = nil
    @EnvironmentObject var navigationManager: NavigationManager
    
    var filteredMaterials: [Material] {
        var filtered = materials
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { material in
                material.title.localizedCaseInsensitiveContains(searchText) ||
                material.description.localizedCaseInsensitiveContains(searchText) ||
                material.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        // Filter by type
        if let selectedType = selectedType {
            filtered = filtered.filter { $0.type == selectedType }
        }
        
        return filtered
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search and filter section
            VStack(spacing: 12) {
                searchBar
                filterSection
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Materials List
            if filteredMaterials.isEmpty {
                emptyStateView
            } else {
                materialsList
            }
        }
        .background(Color(.systemGray6))
    }
    
    @ViewBuilder
    private var searchBar: some View {
        HStack {
            FAIcon(.search, type: .light, size: 16, color: .gray)
            
            TextField("Szukaj materiałów...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    @ViewBuilder
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // All types button
                FilterChip(
                    title: "Wszystkie",
                    isSelected: selectedType == nil
                ) {
                    selectedType = nil
                }
                
                // Type filter chips
                ForEach(MaterialType.allCases, id: \.self) { type in
                    FilterChip(
                        title: type.displayName,
                        isSelected: selectedType == type
                    ) {
                        selectedType = selectedType == type ? nil : type
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var materialsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredMaterials) { material in
                    MaterialCardView(material: material) {
                        navigationManager.navigateToMaterialDetail(materialId: material.id)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
    
    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            FAIcon(.fileAlt, type: .light, size: 60, color: .gray)
            
            Text("Brak materiałów")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            Text("Nie znaleziono materiałów spełniających kryteria wyszukiwania")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .novoNordiskBlue)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.novoNordiskBlue : Color.white)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.novoNordiskBlue, lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Material Card View
struct MaterialCardView: View {
    let material: Material
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Material icon and type
                VStack(spacing: 8) {
                    FAIcon(
                        material.type.icon,
                        type: .light,
                        size: 32,
                        color: .novoNordiskBlue
                    )
                    .frame(width: 50, height: 50)
                    .background(Color.novoNordiskBlue.opacity(0.1))
                    .cornerRadius(8)
                    
                    Text(material.type.displayName)
                        .font(.caption2)
                        .foregroundColor(.novoNordiskBlue)
                        .fontWeight(.medium)
                }
                
                // Material info
                VStack(alignment: .leading, spacing: 8) {
                    Text(material.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(material.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    // Tags
                    if !material.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 4) {
                                ForEach(material.tags.prefix(3), id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption2)
                                        .foregroundColor(.novoNordiskBlue)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.novoNordiskBlue.opacity(0.1))
                                        .cornerRadius(4)
                                }
                            }
                        }
                    }
                    
                    // Bottom info
                    HStack {
                        HStack(spacing: 4) {
                            FAIcon(.check, type: .light, size: 12, color: .gray)
                            Text("\(material.downloadCount)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text(material.formattedPublishDate)
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        if let fileSize = material.fileSize {
                            Text("• \(fileSize)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Mock Data
struct MaterialMockData {
    static let sampleMaterials: [Material] = [
        Material(
            id: "1",
            title: "Przewodnik po nowoczesnych technologiach CGM",
            description: "Kompletny przewodnik po systemach ciągłego monitorowania glukozy. Dowiedz się jak skutecznie wykorzystywać dane CGM w praktyce klinicznej.",
            type: .pdf,
            fileUrl: "https://example.com/cgm-guide.pdf",
            thumbnailUrl: nil,
            fileSize: "2.4 MB",
            downloadCount: 1247,
            publishDate: Calendar.current.date(byAdding: .day, value: -14, to: Date())!,
            tags: ["CGM", "Technologie", "Diabetologia", "Przewodnik"]
        ),
        Material(
            id: "2",
            title: "Webinar: Insulinoterapia w praktyce",
            description: "Nagranie z webinaru dotyczącego nowoczesnych metod insulinoterapii. Praktyczne wskazówki dla lekarzy prowadzących pacjentów z cukrzycą.",
            type: .video,
            fileUrl: "https://example.com/insulin-therapy.mp4",
            thumbnailUrl: "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=400",
            fileSize: "156 MB",
            downloadCount: 892,
            publishDate: Calendar.current.date(byAdding: .day, value: -7, to: Date())!,
            tags: ["Insulina", "Webinar", "Terapia", "Praktyka"]
        ),
        Material(
            id: "3",
            title: "Prezentacja: Leczenie otyłości - nowe możliwości",
            description: "Najnowsze osiągnięcia w farmakoterapii otyłości. Przegląd nowych leków i ich zastosowania w praktyce klinicznej.",
            type: .presentation,
            fileUrl: "https://example.com/obesity-treatment.pptx",
            thumbnailUrl: nil,
            fileSize: "8.7 MB",
            downloadCount: 634,
            publishDate: Calendar.current.date(byAdding: .day, value: -21, to: Date())!,
            tags: ["Otyłość", "Farmakoterapia", "Prezentacja", "Leczenie"]
        ),
        Material(
            id: "4",
            title: "Protokół badania klinicznego STEP",
            description: "Szczegółowy protokół badania klinicznego STEP dotyczącego skuteczności semaglutidu w leczeniu otyłości.",
            type: .document,
            fileUrl: "https://example.com/step-protocol.docx",
            thumbnailUrl: nil,
            fileSize: "1.2 MB",
            downloadCount: 456,
            publishDate: Calendar.current.date(byAdding: .day, value: -35, to: Date())!,
            tags: ["Badanie", "STEP", "Semaglutyd", "Protokół"]
        ),
        Material(
            id: "5",
            title: "Infografika: Algorytm leczenia cukrzycy typu 2",
            description: "Przejrzysty schemat postępowania w leczeniu cukrzycy typu 2 zgodnie z najnowszymi wytycznymi.",
            type: .image,
            fileUrl: "https://example.com/t2dm-algorithm.png",
            thumbnailUrl: "https://images.unsplash.com/photo-1559757175-0f3e5b0b2a55?w=400",
            fileSize: "890 KB",
            downloadCount: 1123,
            publishDate: Calendar.current.date(byAdding: .day, value: -42, to: Date())!,
            tags: ["Algorytm", "Cukrzyca", "Wytyczne", "Infografika"]
        )
    ]
}

#Preview {
    MaterialsListView()
        .environmentObject(NavigationManager())
} 
