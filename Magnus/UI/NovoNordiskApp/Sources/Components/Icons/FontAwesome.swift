import SwiftUI

// MARK: - FontAwesome Helper
struct FontAwesome {
    
    // MARK: - Font Names
    enum FontType: String {
        case light = "FontAwesome6Pro-Light"
        case regular = "FontAwesome6Pro-Regular"        
        case solid = "FontAwesome6Pro-Solid"
        case thin = "FontAwesome6Pro-Thin"
        case brands = "FontAwesome6Brands-Regular"

        var fontName: String {
            return self.rawValue
        }
    }
    
    // MARK: - Common Icons
    enum Icon: String {
        // Navigation
        case home = "\u{f015}"
        case back = "\u{f060}"
        case forward = "\u{f061}"
        case menu = "\u{f0c9}"
        case close = "\u{f00d}"
        
        // User
        case user = "\u{f007}"
        case userCircle = "\u{f2bd}"
        case users = "\u{f0c0}"
        case userPlus = "\u{f234}"
        
        // Communication
        case email = "\u{f0e0}"
        case phone = "\u{f095}"
        case message = "\u{f27a}"
        case bell = "\u{f0f3}"
        
        // Actions
        case edit = "\u{f044}"
        case delete = "\u{f1f8}"
        case save = "\u{f0c7}"
        case search = "\u{f002}"
        case filter = "\u{f0b0}"
        case sort = "\u{f0dc}"
        
        // Status
        case check = "\u{f00c}"
       // case times = "\u{f00d}"
        case exclamation = "\u{f12a}"
        case question = "\u{f128}"
        case info = "\u{f129}"
        
        // Medical/Health (dla NovoNordisk)
        case heart = "\u{f004}"
        case medical = "\u{f0f0}"
        case pills = "\u{f484}"
        case syringe = "\u{f48e}"
        case stethoscope = "\u{f0f1}"
        
        // Data
        case chartLine = "\u{f201}"
        case chartBar = "\u{f080}"
        case calendar = "\u{f073}"
        case clock = "\u{f017}"
        
        var unicode: String {
            return self.rawValue
        }
    }
    
    // MARK: - Create Icon View
    static func icon(
        _ icon: Icon, 
        type: FontType = .light, 
        size: CGFloat = 16, 
        color: Color = Color("NovoNordiskBlue")
    ) -> some View {
        Text(icon.unicode)
            .font(.custom(type.fontName, size: size))
            .foregroundColor(color)
    }
    
    // MARK: - Font Loading Test
    static func testFonts() {
        print("=== Font Awesome Loading Test ===")
        for fontType in [FontType.solid, .regular, .light, .thin, .brands] {
            let font = UIFont(name: fontType.fontName, size: 16)
            if font != nil {
                print("✅ \(fontType.fontName) - LOADED")
            } else {
                print("❌ \(fontType.fontName) - FAILED")
            }
        }
        print("================================")
    }
}

// MARK: - Convenience View
struct FAIcon: View {
    let icon: FontAwesome.Icon
    let type: FontAwesome.FontType
    let size: CGFloat
    let color: Color
    
    init(
        _ icon: FontAwesome.Icon,
        type: FontAwesome.FontType = .light,
        size: CGFloat = 16,
        color: Color = Color("NovoNordiskBlue")
    ) {
        self.icon = icon
        self.type = type
        self.size = size
        self.color = color
    }
    
    var body: some View {
        FontAwesome.icon(icon, type: type, size: size, color: color)
            .onAppear {
                // Test font loading only once
                if icon == .home {
                    FontAwesome.testFonts()
                }
            }
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 20) {
            Text("Font Awesome Icons Test")
                .font(.title2)
                .fontWeight(.bold)
            
            // Font Loading Test
            VStack(spacing: 10) {
                Text("Font Test - Should show icons, not question marks")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                HStack(spacing: 15) {
                    FAIcon(.home, type: .solid, size: 24)
                    FAIcon(.home, type: .regular, size: 24)
                    FAIcon(.home, type: .light, size: 24)
                    FAIcon(.home, type: .thin, size: 24)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            // Navigation Icons
            VStack(alignment: .leading, spacing: 10) {
                Text("Navigation")
                    .font(.headline)
                    .foregroundColor(Color("NovoNordiskBlue"))
                
                HStack(spacing: 15) {
                    FAIcon(.home, size: 24)
                    FAIcon(.back, size: 24)
                    FAIcon(.forward, size: 24)
                    FAIcon(.menu, size: 24)
                    FAIcon(.close, size: 24)
                }
            }
            
            // User Icons
            VStack(alignment: .leading, spacing: 10) {
                Text("User")
                    .font(.headline)
                    .foregroundColor(Color("NovoNordiskBlue"))
                
                HStack(spacing: 15) {
                    FAIcon(.user, size: 24)
                    FAIcon(.userCircle, size: 24)
                    FAIcon(.users, size: 24)
                    FAIcon(.userPlus, size: 24)
                }
            }
            
            // Medical Icons (NovoNordisk relevant)
            VStack(alignment: .leading, spacing: 10) {
                Text("Medical")
                    .font(.headline)
                    .foregroundColor(Color("NovoNordiskBlue"))
                
                HStack(spacing: 15) {
                    FAIcon(.heart, size: 24, color: .red)
                    FAIcon(.medical, size: 24)
                    FAIcon(.pills, size: 24)
                    FAIcon(.syringe, size: 24)
                    FAIcon(.stethoscope, size: 24)
                }
            }
            
            // Status Icons
            VStack(alignment: .leading, spacing: 10) {
                Text("Status")
                    .font(.headline)
                    .foregroundColor(Color("NovoNordiskBlue"))
                
                HStack(spacing: 15) {
                    FAIcon(.check, size: 24, color: .green)
                    //FAIcon(.times, size: 24, color: .red)
                    FAIcon(.exclamation, size: 24, color: .orange)
                    FAIcon(.question, size: 24)
                    FAIcon(.info, size: 24)
                }
            }
            
            Spacer()
        }
        .padding()
    }
} 
