import SwiftUI

extension Font {
    
    // MARK: - OpenSans Font Family
    
    /// OpenSans Regular czcionka z różnymi rozmiarami
    static func openSansRegular(size: CGFloat) -> Font {
        return .custom("OpenSans-Regular", size: size)
    }
    
    /// OpenSans Light czcionka z różnymi rozmiarami  
    static func openSansLight(size: CGFloat) -> Font {
        return .custom("OpenSans-Light", size: size)
    }
    
    /// OpenSans Bold czcionka z różnymi rozmiarami
    static func openSansBold(size: CGFloat) -> Font {
        return .custom("OpenSans-Bold", size: size)
    }
    
    // MARK: - NovoNordisk Default Typography Styles
    
    /// Główny tytuł aplikacji - duży, pogrubiony
    static var novoNordiskTitle: Font {
        return openSansBold(size: 36)
    }
    
    /// Nagłówek sekcji
    static var novoNordiskHeadline: Font {
        return openSansRegular(size: 20)
    }
    
    /// Tekst podstawowy w aplikacji
    static var novoNordiskBody: Font {
        return openSansRegular(size: 16)
    }
    
    /// Mały tekst, opisy, podpisy
    static var novoNordiskCaption: Font {
        return openSansLight(size: 16)
    }
    
    /// Pogrubiony tekst opisowy (np. etykiety pól)
    static var novoNordiskCaptionBold: Font {
        return openSansBold(size: 16)
    }
    
    /// Tekst na przyciskach
    static var novoNordiskButton: Font {
        return openSansBold(size: 18)
    }

        /// Tekst na przyciskach
    static var novoNordiskLinkButton: Font {
        return openSansRegular(size: 18)
    }
    
    /// Bardzo mały tekst, podpisy, helper text
    static var novoNordiskFootnote: Font {
        return openSansLight(size: 12)
    }
    
    static var novoNordiskSectionTitle: Font {
        return openSansRegular(size: 19)
    }

    static var novoNordiskAuthorName: Font {
        return openSansLight(size: 13)
    }

    static var novoNordiskAuthorGroups: Font {
        return openSansLight(size: 11)
    }

    static var novoNordiskSmallText: Font {
        return openSansLight(size: 12)
    }
}

// MARK: - NovoNordisk Typography Environment

struct NovoNordiskFontKey: EnvironmentKey {
    static let defaultValue: Font = .novoNordiskBody
}

extension EnvironmentValues {
    var novoNordiskFont: Font {
        get { self[NovoNordiskFontKey.self] }
        set { self[NovoNordiskFontKey.self] = newValue }
    }
}

// MARK: - View Modifier for Default Typography

struct NovoNordiskTypographyModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .environment(\.novoNordiskFont, .novoNordiskBody)
            .font(.novoNordiskBody)
    }
}

extension View {
    /// Stosuje domyślną typografię NovoNordisk do widoku
    func novoNordiskTypography() -> some View {
        modifier(NovoNordiskTypographyModifier())
    }
} 
