import SwiftUI

// MARK: - NovoNordiskRadioButtonList
struct NovoNordiskRadioButtonList<T: Hashable & Identifiable>: View {
    let title: String?
    let options: [T]
    let optionTitle: (T) -> String
    let optionSubtitle: ((T) -> String?)?
    @Binding var selectedOption: T?
    let style: NovoNordiskRadioButtonStyle
    let isEnabled: Bool
    
    init(
        title: String? = nil,
        options: [T],
        selectedOption: Binding<T?>,
        optionTitle: @escaping (T) -> String,
        optionSubtitle: ((T) -> String?)? = nil,
        style: NovoNordiskRadioButtonStyle = .standard,
        isEnabled: Bool = true
    ) {
        self.title = title
        self.options = options
        self._selectedOption = selectedOption
        self.optionTitle = optionTitle
        self.optionSubtitle = optionSubtitle
        self.style = style
        self.isEnabled = isEnabled
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: style.spacing) {
            if let title = title {
                Text(title)
                    .font(style.titleFont)
                    .foregroundColor(Color("NovoNordiskBlue"))
                    .padding(.bottom, 5)
            }
            
            VStack(spacing: style.itemSpacing) {
                ForEach(options, id: \.id) { option in
                    radioButtonRow(for: option)
                }
            }
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
    
    private func radioButtonRow(for option: T) -> some View {
        Button(action: {
            if isEnabled {
                selectedOption = option
            }
        }) {
            HStack(spacing: style.radioButtonSpacing) {
                // Radio Button
                ZStack {
                    Circle()
                        .stroke(
                            isSelected(option) ? Color("NovoNordiskBlue") : Color("NovoNordiskBlue").opacity(0.3),
                            lineWidth: style.radioButtonBorderWidth
                        )
                        .frame(width: style.radioButtonSize, height: style.radioButtonSize)
                    
                    if isSelected(option) {
                        Circle()
                            .fill(Color("NovoNordiskBlue"))
                            .frame(width: style.radioButtonInnerSize, height: style.radioButtonInnerSize)
                    }
                }
                
                // Content
                VStack(alignment: .leading, spacing: 2) {
                    Text(optionTitle(option))
                        .font(style.optionFont)
                        .foregroundColor(style.optionTextColor)
                        .multilineTextAlignment(.leading)
                    
                    if let subtitle = optionSubtitle?(option) {
                        Text(subtitle)
                            .font(style.subtitleFont)
                            .foregroundColor(style.subtitleTextColor)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
            }
            .padding(style.itemPadding)
            .background(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .fill(isSelected(option) ? style.selectedBackgroundColor : style.backgroundColor)
            )
            .overlay(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .stroke(
                        isSelected(option) ? Color("NovoNordiskBlue") : Color.clear,
                        lineWidth: style.borderWidth
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func isSelected(_ option: T) -> Bool {
        return selectedOption?.id == option.id
    }
}

// MARK: - NovoNordiskRadioButtonStyle
enum NovoNordiskRadioButtonStyle {
    case standard
    case compact
    case card
    
    var spacing: CGFloat {
        switch self {
        case .standard, .card:
            return 10
        case .compact:
            return 5
        }
    }
    
    var itemSpacing: CGFloat {
        switch self {
        case .standard:
            return 12
        case .compact:
            return 8
        case .card:
            return 16
        }
    }
    
    var itemPadding: EdgeInsets {
        switch self {
        case .standard:
            return EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        case .compact:
            return EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        case .card:
            return EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .standard, .compact:
            return 8
        case .card:
            return 12
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .standard, .compact:
            return Color.clear
        case .card:
            return Color("NovoNordiskBlue").opacity(0.02)
        }
    }
    
    var selectedBackgroundColor: Color {
        switch self {
        case .standard, .compact:
            return Color("NovoNordiskBlue").opacity(0.05)
        case .card:
            return Color("NovoNordiskBlue").opacity(0.1)
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .standard, .compact:
            return 1
        case .card:
            return 1.5
        }
    }
    
    var radioButtonSize: CGFloat {
        switch self {
        case .standard, .card:
            return 20
        case .compact:
            return 16
        }
    }
    
    var radioButtonInnerSize: CGFloat {
        switch self {
        case .standard, .card:
            return 10
        case .compact:
            return 8
        }
    }
    
    var radioButtonBorderWidth: CGFloat {
        return 2
    }
    
    var radioButtonSpacing: CGFloat {
        switch self {
        case .standard, .card:
            return 12
        case .compact:
            return 10
        }
    }
    
    var titleFont: Font {
        return .system(size: 16, weight: .semibold)
    }
    
    var optionFont: Font {
        switch self {
        case .standard, .card:
            return .system(size: 16, weight: .medium)
        case .compact:
            return .system(size: 14, weight: .medium)
        }
    }
    
    var subtitleFont: Font {
        switch self {
        case .standard, .card:
            return .system(size: 14, weight: .regular)
        case .compact:
            return .system(size: 12, weight: .regular)
        }
    }
    
    var optionTextColor: Color {
        return Color.primary
    }
    
    var subtitleTextColor: Color {
        return Color.secondary
    }
}

// MARK: - Sample Data Model
struct RadioOption: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String?
    
    init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: 30) {
            Text("NovoNordisk Radio Button Lists")
                .font(.title2)
                .fontWeight(.bold)
            
            // Standard style
            VStack(alignment: .leading, spacing: 15) {
                Text("Standard Style")
                    .font(.headline)
                    .foregroundColor(Color("NovoNordiskBlue"))
                
                NovoNordiskRadioButtonList(
                    title: "Wybierz typ leku",
                    options: [
                        RadioOption(title: "Insulina długodziałająca"),
                        RadioOption(title: "Insulina krótkodziałająca"),
                        RadioOption(title: "Mieszanka insulinowa")
                    ],
                    selectedOption: .constant(nil),
                    optionTitle: { $0.title },
                    style: .standard
                )
            }
            
            // Compact style
            VStack(alignment: .leading, spacing: 15) {
                Text("Compact Style")
                    .font(.headline)
                    .foregroundColor(Color("NovoNordiskBlue"))
                
                NovoNordiskRadioButtonList(
                    title: "Płeć",
                    options: [
                        RadioOption(title: "Mężczyzna"),
                        RadioOption(title: "Kobieta"),
                        RadioOption(title: "Nie chcę podawać")
                    ],
                    selectedOption: .constant(nil),
                    optionTitle: { $0.title },
                    style: .compact
                )
            }
            
            // Card style with subtitles
            VStack(alignment: .leading, spacing: 15) {
                Text("Card Style with Descriptions")
                    .font(.headline)
                    .foregroundColor(Color("NovoNordiskBlue"))
                
                NovoNordiskRadioButtonList(
                    title: "Rodzaj cukrzycy",
                    options: [
                        RadioOption(title: "Typ 1", subtitle: "Insulinozależna, zwykle rozwija się w młodym wieku"),
                        RadioOption(title: "Typ 2", subtitle: "Nieinsulinozależna, związana ze stylem życia"),
                        RadioOption(title: "Ciążowa", subtitle: "Występuje podczas ciąży")
                    ],
                    selectedOption: .constant(nil),
                    optionTitle: { $0.title },
                    optionSubtitle: { $0.subtitle },
                    style: .card
                )
            }
            
            Spacer()
        }
        .padding()
    }
} 
