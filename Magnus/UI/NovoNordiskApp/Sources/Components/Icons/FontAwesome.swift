import SwiftUI

// MARK: - FontAwesome Helper

enum FontAwesome {
    // MARK: - Font Names

    enum FontType: String {
        case light = "FontAwesome6Pro-Light"
        case regular = "FontAwesome6Pro-Regular"
        case solid = "FontAwesome6Pro-Solid"
        case thin = "FontAwesome6Pro-Thin"
        case brands = "FontAwesome6Brands-Regular"

        var fontName: String {
            return rawValue
        }
    }

    // MARK: - Common Icons

    enum Icon: String {
        // NovoNordisk Icons
        case questionCircle = "\u{f059}"
        case signIn = "\u{f090}"

        // Navigation
        case home = "\u{f015}"
        case back = "\u{f060}"
        case forward = "\u{f061}"
        case menu = "\u{f0c9}"
        case close = "\u{f00d}"
        case settings = "\u{f013}"
        case signOut = "\u{f08b}"
        case wifi = "\u{f1eb}"

        // User
        case user = "\u{f007}"
        case userCircle = "\u{f2bd}"
        case users = "\u{f0c0}"
        case userPlus = "\u{f234}"
        case user_clock = "\u{f4fd}"
        case user_doctor = "\u{f0f0}"

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
        case circle_check = "\u{f058}"
        case exclamation = "\u{f12a}"
        case exclamationTriangle = "\u{f071}"
        case question = "\u{f128}"
        case info = "\u{f129}"

        // Medical/Health (dla NovoNordisk)
        case heart = "\u{f004}"
        case pills = "\u{f484}"
        case syringe = "\u{f48e}"
        case stethoscope = "\u{f0f1}"

        // Data
        case chartLine = "\u{f201}"
        case chartBar = "\u{f080}"
        case calendar = "\u{f073}"
        case clock = "\u{f017}"

        // Bottom Menu Icons
        case newspaper = "\u{f1ea}"
        case fileAlt = "\u{f15c}"
        case graduationCap = "\u{f19d}"

        // QR Code
        case qrcode = "\u{f029}"

        case lock = "\u{f023}"

        // Circle Icons
        case circle_information = "\u{f05a}"
        case circle_arrow_right = "\u{f0a9}"
        case circle_arrow_left = "\u{f0a8}"
        case circle_play = "\u{f144}"

        // documents
        case file = "\u{f15b}"
        case fileUrl = "\u{f0ac}"
        case filePdf = "\u{f1c1}"
        case fileWord = "\u{f1c2}"
        case fileExcel = "\u{f1c3}"
        case filePowerpoint = "\u{f1c4}"
        case fileImage = "\u{f1c5}"
        case fileAudio = "\u{f1c7}"
        case fileChartColumn = "\u{f659}"

        // top bar buttons
        case box_archive = "\u{f187}"

        //news stats icons
        case eye = "\u{f06e}"
        case comment = "\u{f075}"
        case smile = "\u{f118}"

        //bookmark
        case bookmark = "\u{f02e}"

        //edit
        case ellipsisVertical = "\u{f142}"


        //reactions
        case thumbsUp = "\u{f164}"
        case thumbsDown = "\u{f165}"
        case clappingHands = "\u{e1a8}"
        case lightBulb = "\u{f0eb}"
        case handHoldingHeart = "\u{f4be}"

        var unicode: String {
            return rawValue
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
                    FAIcon(.user_doctor, size: 24)
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
                    // FAIcon(.times, size: 24, color: .red)
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
