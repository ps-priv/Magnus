
import Foundation

public enum MagnusStorageError: Error, LocalizedError {
    case keyNotFound
    case invalidData
    case encodingFailed
    case decodingFailed
    case keychainError(OSStatus)
    case userDefaultsError
    
    public var errorDescription: String? {
        switch self {
        case .keyNotFound:
            return "Storage key not found"
        case .invalidData:
            return "Invalid data format"
        case .encodingFailed:
            return "Failed to encode data"
        case .decodingFailed:
            return "Failed to decode data"
        case .keychainError(let status):
            return "Keychain error: \(status)"
        case .userDefaultsError:
            return "UserDefaults error"
        }
    }
}