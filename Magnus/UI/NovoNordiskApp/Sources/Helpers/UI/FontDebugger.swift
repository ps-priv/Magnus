import SwiftUI
import UIKit

struct FontDebugger {
    /// Wypisuje wszystkie dostępne czcionki w systemie
    static func printAllFonts() {
        for family in UIFont.familyNames.sorted() {
            print("Font Family: \(family)")
            for font in UIFont.fontNames(forFamilyName: family) {
                print("  - \(font)")
            }
        }
    }
    
    /// Sprawdza czy określona czcionka jest dostępna
    static func isFontAvailable(_ fontName: String) -> Bool {
        return UIFont(name: fontName, size: 12) != nil
    }
    
    /// Wypisuje informacje o dostępności czcionek OpenSans
    static func checkOpenSansFonts() {
        let openSansFonts = [
            "OpenSans-Light",
            "OpenSans-Regular", 
            "OpenSans-Bold",
            "OpenSans",
            "Open Sans",
            "OpenSans-LightItalic",
            "OpenSans-Italic",
            "OpenSans-BoldItalic"
        ]
        
        print("=== OpenSans Font Availability ===")
        for fontName in openSansFonts {
            let available = isFontAvailable(fontName)
            print("\(fontName): \(available ? "✅ Available" : "❌ Not Available")")
        }
    }
}

// MARK: - Test View for Font Preview
struct FontTestView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Font Test View")
                    .font(.largeTitle)
                    .padding(.bottom)
                
                Group {
                    Text("OpenSans-Light (12pt)")
                        .font(.custom("OpenSans-Light", size: 12))
                    
                    Text("OpenSans-Regular (14pt)")
                        .font(.custom("OpenSans-Regular", size: 14))
                    
                    Text("OpenSans-Bold (14pt)")
                        .font(.custom("OpenSans-Bold", size: 14))
                    
                    Text("novoNordiskCaption")
                        .font(.novoNordiskCaption)
                    
                    Text("novoNordiskCaptionBold")
                        .font(.novoNordiskCaptionBold)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Test Text Box with Bold Title:")
                        .font(.headline)
                    
                    NovoNordiskTextBox(
                        placeholder: "Test input",
                        text: .constant(""),
                        style: .withTitle("Bold Title Test", bold: true)
                    )
                    
                    NovoNordiskTextBox(
                        placeholder: "Test input",
                        text: .constant(""),
                        style: .withTitle("Regular Title Test", bold: false)
                    )
                }
            }
            .padding()
        }
        .onAppear {
            FontDebugger.checkOpenSansFonts()
        }
    }
}

#Preview {
    FontTestView()
} 