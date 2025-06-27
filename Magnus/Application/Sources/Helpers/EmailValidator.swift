import Foundation

// MARK: - Email Validation Helper

public struct EmailValidator {
    
    // MARK: - Validation Methods
    
    /// Validates if the given string is a valid email address
    /// - Parameter email: String to validate
    /// - Returns: True if email is valid, false otherwise
    public static func isValid(_ email: String) -> Bool {
        return isValidFormat(email) && isValidLength(email)
    }
    
    /// Validates email format using regex
    /// - Parameter email: String to validate
    /// - Returns: True if format is valid
    public static func isValidFormat(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    /// Validates email length constraints
    /// - Parameter email: String to validate
    /// - Returns: True if length is valid
    public static func isValidLength(_ email: String) -> Bool {
        return email.count >= 5 && email.count <= 254 // RFC 5321 limit
    }
    
    /// More strict validation for business emails
    /// - Parameter email: String to validate
    /// - Returns: True if it looks like a business email
    public static func isBusinessEmail(_ email: String) -> Bool {
        guard isValid(email) else { return false }
        
        let commonPersonalDomains = [
            "gmail.com", "yahoo.com", "hotmail.com", "outlook.com",
            "icloud.com", "me.com", "aol.com", "live.com"
        ]
        
        let domain = extractDomain(from: email)
        return !commonPersonalDomains.contains(domain.lowercased())
    }
    
    /// Validates if email belongs to specific domain
    /// - Parameters:
    ///   - email: Email to validate
    ///   - domain: Required domain (e.g. "novonordisk.com")
    /// - Returns: True if email belongs to specified domain
    public static func belongsToDomain(_ email: String, domain: String) -> Bool {
        guard isValid(email) else { return false }
        let emailDomain = extractDomain(from: email)
        return emailDomain.lowercased() == domain.lowercased()
    }
    
    // MARK: - Helper Methods
    
    /// Extracts domain from email address
    /// - Parameter email: Email address
    /// - Returns: Domain part of email
    public static func extractDomain(from email: String) -> String {
        let components = email.components(separatedBy: "@")
        return components.count == 2 ? components[1] : ""
    }
    
    /// Extracts username from email address
    /// - Parameter email: Email address
    /// - Returns: Username part of email
    public static func extractUsername(from email: String) -> String {
        let components = email.components(separatedBy: "@")
        return components.count == 2 ? components[0] : ""
    }
    
    /// Normalizes email by trimming whitespace and converting to lowercase
    /// - Parameter email: Email to normalize
    /// - Returns: Normalized email
    public static func normalize(_ email: String) -> String {
        return email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}

// MARK: - String Extension

public extension String {
    
    /// Convenience property to check if string is valid email
    var isValidEmail: Bool {
        return EmailValidator.isValid(self)
    }
    
    /// Convenience property to check if string is business email
    var isBusinessEmail: Bool {
        return EmailValidator.isBusinessEmail(self)
    }
    
    /// Convenience property to get normalized email
    var normalizedEmail: String {
        return EmailValidator.normalize(self)
    }
    
    /// Convenience method to check if email belongs to domain
    /// - Parameter domain: Domain to check against
    /// - Returns: True if email belongs to domain
    func belongsToEmailDomain(_ domain: String) -> Bool {
        return EmailValidator.belongsToDomain(self, domain: domain)
    }
}

// MARK: - Email Validation Errors

public enum EmailValidationError: Error, LocalizedError {
    case invalidFormat
    case tooShort
    case tooLong
    case invalidDomain
    case notBusinessEmail
    case domainMismatch(expected: String, actual: String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidFormat:
            return "Invalid email format"
        case .tooShort:
            return "Email address is too short"
        case .tooLong:
            return "Email address is too long"
        case .invalidDomain:
            return "Invalid email domain"
        case .notBusinessEmail:
            return "Please use a business email address"
        case .domainMismatch(let expected, let actual):
            return "Email must belong to \(expected) domain, but got \(actual)"
        }
    }
}

// MARK: - Advanced Email Validator

public struct AdvancedEmailValidator {
    
    /// Validates email with detailed error reporting
    /// - Parameter email: Email to validate
    /// - Throws: EmailValidationError with specific issue
    public static func validate(_ email: String) throws {
        let normalizedEmail = EmailValidator.normalize(email)
        
        guard normalizedEmail.count >= 5 else {
            throw EmailValidationError.tooShort
        }
        
        guard normalizedEmail.count <= 254 else {
            throw EmailValidationError.tooLong
        }
        
        guard EmailValidator.isValidFormat(normalizedEmail) else {
            throw EmailValidationError.invalidFormat
        }
    }
    
    /// Validates email for specific domain with detailed error reporting
    /// - Parameters:
    ///   - email: Email to validate
    ///   - requiredDomain: Required domain
    /// - Throws: EmailValidationError with specific issue
    public static func validateForDomain(_ email: String, requiredDomain: String) throws {
        try validate(email)
        
        let domain = EmailValidator.extractDomain(from: email)
        guard domain.lowercased() == requiredDomain.lowercased() else {
            throw EmailValidationError.domainMismatch(expected: requiredDomain, actual: domain)
        }
    }
} 