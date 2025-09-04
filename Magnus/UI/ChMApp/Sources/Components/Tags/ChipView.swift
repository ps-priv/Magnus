import SwiftUI

struct ChipView: View {
    private static let prefix: String = "#"

    @Binding var chips: [String]
    //@State var chips: [String] = []
    let placeholder: String

    init(chips: Binding<[String]>, placeholder: String) {
        self._chips = chips
        self.placeholder = placeholder
    }

    @State private var inputText = ""

    var body: some View {
        VStack {
            HStack {
                TextField(placeholder, text: $inputText)
                    .novoNordiskChipViewStyle()


                Button(action: {
                    addChip()
                }) {
                    HStack {
                        Text(LocalizedStrings.newsAddTagsButton)
                            .font(.novoNordiskMiddleText)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 16)
                    .background(Color.novoNordiskBlue)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.novoNordiskTextGrey, lineWidth: 1)
                    )
                  .cornerRadius(8)
                }
            }

            FlowLayout(spacing: 8, rowSpacing: 8) {
                ForEach(chips, id: \.self) { chip in
                    Chip(text: chip) { text in
                        chips.removeAll(where: { $0 == text })
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

        }
    }

    private func addChip() {

        if inputText.isEmpty {
            return
        }

        if !inputText.hasPrefix(ChipView.prefix) {
            inputText = ChipView.prefix + inputText
        }

        if chips.contains(inputText) {
            return
        }

        if inputText.count < 3 {
            return
        }

        inputText = inputText.replacingOccurrences(of: " ", with: "")
        
        chips.append(inputText)
        inputText = ""
    }
}

extension View {
    public func novoNordiskChipViewStyle(isEnabled: Bool = true) -> some View {
        self
            .font(.novoNordiskBody)
            .foregroundColor(isEnabled ? Color("NovoNordiskBlue") : Color.novoNordiskTextGrey)
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .background(isEnabled ? Color.white : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isEnabled ? Color("NovoNordiskBlue") : Color.novoNordiskGrey, lineWidth: 1.5
                    )
            )
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}

// MARK: - Wrapping Flow Layout (iOS 16+)
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    var rowSpacing: CGFloat = 8

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        let maxWidth = proposal.width ?? .infinity

        var currentX: CGFloat = 0
        var currentRowHeight: CGFloat = 0
        var totalHeight: CGFloat = 0

        for subview in subviews {
            let subSize = subview.sizeThatFits(.unspecified)

            if currentX > 0 && currentX + subSize.width > maxWidth {
                // wrap
                totalHeight += currentRowHeight + rowSpacing
                currentX = 0
                currentRowHeight = 0
            }

            currentRowHeight = max(currentRowHeight, subSize.height)
            currentX += subSize.width + spacing
        }

        totalHeight += currentRowHeight

        // If width is unspecified, use the accumulated width; otherwise respect proposed width
        let resolvedWidth: CGFloat
        if maxWidth.isInfinite {
            // compute the longest line width roughly
            var lineX: CGFloat = 0
            var maxLineWidth: CGFloat = 0
            for subview in subviews {
                let subSize = subview.sizeThatFits(.unspecified)
                if lineX > 0 && lineX + subSize.width > maxLineWidth {
                    maxLineWidth = max(maxLineWidth, lineX - spacing)
                    lineX = 0
                }
                lineX += subSize.width + spacing
                maxLineWidth = max(maxLineWidth, lineX - spacing)
            }
            resolvedWidth = maxLineWidth
        } else {
            resolvedWidth = maxWidth
        }

        return CGSize(width: resolvedWidth, height: totalHeight)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        var x = bounds.minX
        var y = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let subSize = subview.sizeThatFits(.unspecified)

            if x > bounds.minX && x + subSize.width > bounds.maxX {
                // wrap
                x = bounds.minX
                y += rowHeight + rowSpacing
                rowHeight = 0
            }

            subview.place(
                at: CGPoint(x: x, y: y),
                proposal: ProposedViewSize(width: subSize.width, height: subSize.height)
            )

            x += subSize.width + spacing
            rowHeight = max(rowHeight, subSize.height)
        }
    }
}

#Preview {
    @State @Previewable var chips: [String] = ["#Kardiologia"]

    VStack {
        ChipView(chips: $chips, placeholder: "#Dodaj tag")
    }
    .padding(20)
}
