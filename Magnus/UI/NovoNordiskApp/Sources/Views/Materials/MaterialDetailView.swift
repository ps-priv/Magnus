import SwiftUI
import Kingfisher

struct MaterialDetailView: View {
    let materialId: String
    @State private var material: Material?
    @State private var showingDownloadAlert = false
    @State private var isDownloading = false
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if let material = material {
                    // Hero section with thumbnail or icon
                    heroSection(material: material)
                    
                    // Content
                    VStack(alignment: .leading, spacing: 24) {
                        // Title and type
                        titleSection(material: material)
                        
                        // Description
                        descriptionSection(material: material)
                        
                        // File info
                        fileInfoSection(material: material)
                        
                        // Tags
                        tagsSection(material: material)
                        
                        // Download stats
                        statsSection(material: material)
                        
                        // Action buttons
                        actionButtonsSection(material: material)
                        
                        Spacer(minLength: 32)
                    }
                    .padding(.horizontal)
                    .padding(.top, 24)
                } else {
                    // Loading state
                    loadingView
                }
            }
        }
        .background(Color(.systemGray6))
        .onAppear {
            loadMaterial()
        }
        .alert("Pobieranie materiału", isPresented: $showingDownloadAlert) {
            Button("Anuluj", role: .cancel) { }
            Button("Pobierz") {
                downloadMaterial()
            }
        } message: {
            Text("Czy chcesz pobrać ten materiał na swoje urządzenie?")
        }
    }
    
    @ViewBuilder
    private func heroSection(material: Material) -> some View {
        ZStack {
            // Background
            Rectangle()
                .fill(Color.novoNordiskBlue.opacity(0.1))
                .frame(height: 200)
            
            // Content
            VStack(spacing: 16) {
                // Thumbnail or icon
                if let thumbnailUrl = material.thumbnailUrl {
                    KFImage(URL(string: thumbnailUrl))
                        .placeholder {
                            ZStack {
                                materialIcon(material: material)
                                ProgressView()
                                    .scaleEffect(1.5)
                                    .tint(.novoNordiskBlue)
                            }
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .cornerRadius(12)
                } else {
                    materialIcon(material: material)
                }
                
                Text(material.type.displayName)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.novoNordiskBlue)
            }
        }
    }
    
    @ViewBuilder
    private func materialIcon(material: Material) -> some View {
        FAIcon(
            material.type.icon,
            type: .light,
            size: 60,
            color: .novoNordiskBlue
        )
        .frame(width: 120, height: 120)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    @ViewBuilder
    private func titleSection(material: Material) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(material.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
    }
    
    @ViewBuilder
    private func descriptionSection(material: Material) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Opis")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(material.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    @ViewBuilder
    private func fileInfoSection(material: Material) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Informacje o pliku")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                HStack {
                    FAIcon(.check, type: .light, size: 20, color: .novoNordiskBlue)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Typ pliku")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(material.type.displayName)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.novoNordiskBlue)
                    }
                    Spacer()
                }
                
                if let fileSize = material.fileSize {
                    HStack {
                        FAIcon(.check, type: .light, size: 20, color: .novoNordiskBlue)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Rozmiar pliku")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(fileSize)
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.novoNordiskBlue)
                        }
                        Spacer()
                    }
                }
                
                HStack {
                    FAIcon(.calendar, type: .light, size: 20, color: .novoNordiskBlue)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Data publikacji")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(material.formattedPublishDate)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.novoNordiskBlue)
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    @ViewBuilder
    private func tagsSection(material: Material) -> some View {
        if !material.tags.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Tagi")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 80), spacing: 8)
                ], spacing: 8) {
                    ForEach(material.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.novoNordiskBlue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.novoNordiskBlue.opacity(0.1))
                            .cornerRadius(16)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
    
    @ViewBuilder
    private func statsSection(material: Material) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Statystyki")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            HStack {
                FAIcon(.check, type: .light, size: 20, color: .orange)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Liczba pobrań")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(material.downloadCount)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
    
    @ViewBuilder
    private func actionButtonsSection(material: Material) -> some View {
        VStack(spacing: 12) {
            // Download button
            NovoNordiskButton(
                title: isDownloading ? "Pobieranie..." : "Pobierz materiał",
                style: .primary,
                isEnabled: !isDownloading
            ) {
                showingDownloadAlert = true
            }
            .disabled(isDownloading)
            
            // Share button
            NovoNordiskButton(
                title: "Udostępnij materiał",
                style: .outline
            ) {
                shareMaterial()
            }
            .disabled(isDownloading)
        }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            ProgressView()
                .scaleEffect(1.2)
            
            Text("Ładowanie materiału...")
                .font(.body)
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
    
    private func loadMaterial() {
        // Mock loading material - in real app this would fetch from API
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let foundMaterial = MaterialMockData.sampleMaterials.first(where: { $0.id == materialId }) {
                material = foundMaterial
            } else {
                // Fallback to first material if specific ID not found
                material = MaterialMockData.sampleMaterials.first
            }
        }
    }
    
    private func downloadMaterial() {
        isDownloading = true
        
        // Mock download process
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isDownloading = false
            
            // Update download count
            if var currentMaterial = material {
                currentMaterial = Material(
                    id: currentMaterial.id,
                    title: currentMaterial.title,
                    description: currentMaterial.description,
                    type: currentMaterial.type,
                    fileUrl: currentMaterial.fileUrl,
                    thumbnailUrl: currentMaterial.thumbnailUrl,
                    fileSize: currentMaterial.fileSize,
                    downloadCount: currentMaterial.downloadCount + 1,
                    publishDate: currentMaterial.publishDate,
                    tags: currentMaterial.tags
                )
                material = currentMaterial
            }
            
            // In real app, this would actually download the file
            print("Downloaded material: \(material?.title ?? "Unknown")")
        }
    }
    
    private func shareMaterial() {
        // In real app, this would open share sheet
        print("Sharing material: \(material?.title ?? "Unknown")")
    }
}

#Preview {
    MaterialDetailView(materialId: "1")
        .environmentObject(NavigationManager())
} 
