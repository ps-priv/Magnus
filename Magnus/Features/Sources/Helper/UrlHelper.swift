import Foundation

public enum UrlHelper {
    static func isValidURL(_ string: String, allowedSchemes: Set<String> = ["http", "https"]) -> Bool {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty,
              let components = URLComponents(string: trimmed),
              let scheme = components.scheme?.lowercased(),
              allowedSchemes.contains(scheme),
              let host = components.host, !host.isEmpty
        else {
            return false
        }
        return true
    }
}

public extension String {
    var isValidUrl: Bool { UrlHelper.isValidURL(self) }
}