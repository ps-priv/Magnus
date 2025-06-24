import Foundation

public struct User {
    public let id: String
    public let email: String
    public let firstname: String
    public let lastname: String
    
    public init(id: String, email: String, firstname: String, lastname: String) {
        self.id = id
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
    }
}

// MARK: - Convenience Properties
extension User {
    public var fullName: String {
        return "\(firstname) \(lastname)"
    }
}

// MARK: - Equatable
extension User: Equatable {
    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Hashable
extension User: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Identifiable
extension User: Identifiable {
    public var identifier: String { id }
} 