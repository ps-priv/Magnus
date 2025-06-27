import Foundation

// MARK: - Password Validation Helper

public struct PasswordValidator {
    
    // MARK: - Validation Methods
    
    /// Validates if password meets basic requirements
    /// - Parameter password: Password to validate
    /// - Returns: True if password is valid
    public static func isValid(_ password: String) -> Bool {
        return password.count >= 6 &&
               containsLowercase(password) &&
               containsUppercase(password) &&
               containsDigit(password)
    }
    
    /// Validates if password meets strong requirements
    /// - Parameter password: Password to validate
    /// - Returns: True if password is strong
    public static func isStrong(_ password: String) -> Bool {
        return password.count >= 8 &&
               containsLowercase(password) &&
               containsUppercase(password) &&
               containsDigit(password) &&
               containsSpecialCharacter(password)
    }
    
    /// Validates if password meets very strong requirements
    /// - Parameter password: Password to validate
    /// - Returns: True if password is very strong
    public static func isVeryStrong(_ password: String) -> Bool {
        return password.count >= 12 &&
               containsLowercase(password) &&
               containsUppercase(password) &&
               containsDigit(password) &&
               containsSpecialCharacter(password) &&
               !containsCommonPatterns(password)
    }
    
    // MARK: - Character Validation
    
    /// Checks if password contains lowercase letters
    /// - Parameter password: Password to check
    /// - Returns: True if contains lowercase letters
    public static func containsLowercase(_ password: String) -> Bool {
        return password.range(of: "[a-z]", options: .regularExpression) != nil
    }
    
    /// Checks if password contains uppercase letters
    /// - Parameter password: Password to check
    /// - Returns: True if contains uppercase letters
    public static func containsUppercase(_ password: String) -> Bool {
        return password.range(of: "[A-Z]", options: .regularExpression) != nil
    }
    
    /// Checks if password contains digits
    /// - Parameter password: Password to check
    /// - Returns: True if contains digits
    public static func containsDigit(_ password: String) -> Bool {
        return password.range(of: "[0-9]", options: .regularExpression) != nil
    }
    
    /// Checks if password contains special characters
    /// - Parameter password: Password to check
    /// - Returns: True if contains special characters
    public static func containsSpecialCharacter(_ password: String) -> Bool {
        let specialCharacters = "!@#$%^&*()_+-=[]{}|;:,.<>?"
        return password.rangeOfCharacter(from: CharacterSet(charactersIn: specialCharacters)) != nil
    }
    
    /// Checks if password contains common weak patterns
    /// - Parameter password: Password to check
    /// - Returns: True if contains common patterns
    public static func containsCommonPatterns(_ password: String) -> Bool {
        let commonPatterns = [
            "123456", "password", "qwerty", "abc123", "letmein",
            "welcome", "monkey", "dragon", "master", "login"
        ]
        
        let lowercasePassword = password.lowercased()
        return commonPatterns.contains { lowercasePassword.contains($0) }
    }
    
    // MARK: - Length Validation
    
    /// Validates password length
    /// - Parameters:
    ///   - password: Password to validate
    ///   - minLength: Minimum required length
    ///   - maxLength: Maximum allowed length
    /// - Returns: True if length is valid
    public static func hasValidLength(_ password: String, minLength: Int = 6, maxLength: Int = 128) -> Bool {
        return password.count >= minLength && password.count <= maxLength
    }
    
    // MARK: - Password Strength Assessment
    
    /// Calculates password strength score (0-100)
    /// - Parameter password: Password to evaluate
    /// - Returns: Strength score from 0 to 100
    public static func strengthScore(_ password: String) -> Int {
        var score = 0
        
        // Length scoring
        if password.count >= 6 { score += 10 }
        if password.count >= 8 { score += 10 }
        if password.count >= 12 { score += 10 }
        if password.count >= 16 { score += 10 }
        
        // Character variety scoring
        if containsLowercase(password) { score += 10 }
        if containsUppercase(password) { score += 10 }
        if containsDigit(password) { score += 10 }
        if containsSpecialCharacter(password) { score += 15 }
        
        // Penalty for common patterns
        if containsCommonPatterns(password) { score -= 20 }
        
        // Ensure score is within bounds
        return max(0, min(100, score))
    }
    
    /// Gets password strength level
    /// - Parameter password: Password to evaluate
    /// - Returns: PasswordStrength enum
    public static func strengthLevel(_ password: String) -> PasswordStrength {
        let score = strengthScore(password)
        
        switch score {
        case 0...25:
            return .veryWeak
        case 26...50:
            return .weak
        case 51...75:
            return .medium
        case 76...90:
            return .strong
        case 91...100:
            return .veryStrong
        default:
            return .veryWeak
        }
    }
}

// MARK: - Password Strength Enum

public enum PasswordStrength: Int, CaseIterable {
    case veryWeak = 0
    case weak = 1
    case medium = 2
    case strong = 3
    case veryStrong = 4
    
    public var description: String {
        switch self {
        case .veryWeak:
            return "Very Weak"
        case .weak:
            return "Weak"
        case .medium:
            return "Medium"
        case .strong:
            return "Strong"
        case .veryStrong:
            return "Very Strong"
        }
    }
    
    public var color: String {
        switch self {
        case .veryWeak:
            return "#FF0000" // Red
        case .weak:
            return "#FF6600" // Orange
        case .medium:
            return "#FFCC00" // Yellow
        case .strong:
            return "#66CC00" // Light Green
        case .veryStrong:
            return "#00CC00" // Green
        }
    }
}

// MARK: - Password Validation Errors

public enum PasswordValidationError: Error, LocalizedError {
    case tooShort(minLength: Int)
    case tooLong(maxLength: Int)
    case missingLowercase
    case missingUppercase
    case missingDigit
    case missingSpecialCharacter
    case containsCommonPattern
    case tooWeak
    
    public var errorDescription: String? {
        switch self {
        case .tooShort(let minLength):
            return "Password must be at least \(minLength) characters long"
        case .tooLong(let maxLength):
            return "Password must be no more than \(maxLength) characters long"
        case .missingLowercase:
            return "Password must contain at least one lowercase letter"
        case .missingUppercase:
            return "Password must contain at least one uppercase letter"
        case .missingDigit:
            return "Password must contain at least one number"
        case .missingSpecialCharacter:
            return "Password must contain at least one special character"
        case .containsCommonPattern:
            return "Password contains common patterns and is not secure"
        case .tooWeak:
            return "Password is too weak. Please choose a stronger password"
        }
    }
}

// MARK: - Advanced Password Validator

public struct AdvancedPasswordValidator {
    
    /// Validates password with detailed error reporting
    /// - Parameters:
    ///   - password: Password to validate
    ///   - level: Required strength level
    /// - Throws: PasswordValidationError with specific issue
    public static func validate(_ password: String, requiredLevel: PasswordStrength = .medium) throws {
        
        // Length validation
        guard password.count >= 6 else {
            throw PasswordValidationError.tooShort(minLength: 6)
        }
        
        guard password.count <= 128 else {
            throw PasswordValidationError.tooLong(maxLength: 128)
        }
        
        // Character requirements based on level
        switch requiredLevel {
        case .veryWeak:
            // No additional requirements
            break
            
        case .weak:
            guard PasswordValidator.containsLowercase(password) || PasswordValidator.containsUppercase(password) else {
                throw PasswordValidationError.missingLowercase
            }
            
        case .medium:
            guard PasswordValidator.containsLowercase(password) else {
                throw PasswordValidationError.missingLowercase
            }
            guard PasswordValidator.containsUppercase(password) else {
                throw PasswordValidationError.missingUppercase
            }
            guard PasswordValidator.containsDigit(password) else {
                throw PasswordValidationError.missingDigit
            }
            
        case .strong:
            guard PasswordValidator.containsLowercase(password) else {
                throw PasswordValidationError.missingLowercase
            }
            guard PasswordValidator.containsUppercase(password) else {
                throw PasswordValidationError.missingUppercase
            }
            guard PasswordValidator.containsDigit(password) else {
                throw PasswordValidationError.missingDigit
            }
            guard PasswordValidator.containsSpecialCharacter(password) else {
                throw PasswordValidationError.missingSpecialCharacter
            }
            
        case .veryStrong:
            guard PasswordValidator.containsLowercase(password) else {
                throw PasswordValidationError.missingLowercase
            }
            guard PasswordValidator.containsUppercase(password) else {
                throw PasswordValidationError.missingUppercase
            }
            guard PasswordValidator.containsDigit(password) else {
                throw PasswordValidationError.missingDigit
            }
            guard PasswordValidator.containsSpecialCharacter(password) else {
                throw PasswordValidationError.missingSpecialCharacter
            }
            guard !PasswordValidator.containsCommonPatterns(password) else {
                throw PasswordValidationError.containsCommonPattern
            }
        }
        
        // Check if meets required strength level
        let actualLevel = PasswordValidator.strengthLevel(password)
        guard actualLevel.rawValue >= requiredLevel.rawValue else {
            throw PasswordValidationError.tooWeak
        }
    }
}

// MARK: - String Extension

public extension String {
    
    /// Convenience property to check if string is valid password
    var isValidPassword: Bool {
        return PasswordValidator.isValid(self)
    }
    
    /// Convenience property to check if string is strong password
    var isStrongPassword: Bool {
        return PasswordValidator.isStrong(self)
    }
    
    /// Convenience property to get password strength score
    var passwordStrengthScore: Int {
        return PasswordValidator.strengthScore(self)
    }
    
    /// Convenience property to get password strength level
    var passwordStrengthLevel: PasswordStrength {
        return PasswordValidator.strengthLevel(self)
    }
    
    /// Convenience property to check if password contains lowercase
    var hasLowercase: Bool {
        return PasswordValidator.containsLowercase(self)
    }
    
    /// Convenience property to check if password contains uppercase
    var hasUppercase: Bool {
        return PasswordValidator.containsUppercase(self)
    }
    
    /// Convenience property to check if password contains digits
    var hasDigits: Bool {
        return PasswordValidator.containsDigit(self)
    }
    
    /// Convenience property to check if password contains special characters
    var hasSpecialCharacters: Bool {
        return PasswordValidator.containsSpecialCharacter(self)
    }
} 