import SwiftUI
import UIKit
import Foundation

struct ClickableTextView: View {
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(textComponents, id: \.id) { component in
                if component.isURL {
                    Button(action: {
                        if let url = URL(string: component.text) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text(component.text)
                            .foregroundColor(.blue)
                            .underline()
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Text(component.text)
                }
            }
        }
    }
    
    private var textComponents: [TextComponent] {
        var components: [TextComponent] = []
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) ?? []
        
        var lastIndex = text.startIndex
        
        for match in matches {
            if let range = Range(match.range, in: text) {
                // Add text before URL
                if lastIndex < range.lowerBound {
                    let beforeText = String(text[lastIndex..<range.lowerBound])
                    if !beforeText.isEmpty {
                        components.append(TextComponent(text: beforeText, isURL: false))
                    }
                }
                
                // Add URL
                let urlText = String(text[range])
                components.append(TextComponent(text: urlText, isURL: true))
                
                lastIndex = range.upperBound
            }
        }
        
        // Add remaining text after last URL
        if lastIndex < text.endIndex {
            let remainingText = String(text[lastIndex...])
            if !remainingText.isEmpty {
                components.append(TextComponent(text: remainingText, isURL: false))
            }
        }
        
        // If no URLs found, return the entire text as one component
        if components.isEmpty {
            components.append(TextComponent(text: text, isURL: false))
        }
        
        return components
    }
}

struct TextComponent {
    let id = UUID()
    let text: String
    let isURL: Bool
}