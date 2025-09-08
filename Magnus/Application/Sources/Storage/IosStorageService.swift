import Foundation   
import Security
import MagnusDomain



public class IosStorageService: MagnusStorageService {

    private let userDefaults: UserDefaults
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    
    // MARK: - Initialization
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.jsonEncoder = JSONEncoder()
        self.jsonDecoder = JSONDecoder()
    }

    public func saveEventDetails(_ eventDetails: ConferenceEventDetails) throws {
        do {
            let data = try jsonEncoder.encode(eventDetails)
            userDefaults.set(data, forKey: MagnusStorageKey.eventDetails.rawValue)
        } catch {
            throw MagnusStorageError.encodingFailed
        }
    }
    
    public func getEventDetails() throws -> ConferenceEventDetails? {
        guard let data = userDefaults.data(forKey: MagnusStorageKey.eventDetails.rawValue) else {
            return nil
        }
        
        do {
            return try jsonDecoder.decode(ConferenceEventDetails.self, from: data)
        } catch {
            throw MagnusStorageError.decodingFailed
        }
    }       

    public func saveNewsRequest(news: AddNewsRequest) throws {
        do {
            let data = try jsonEncoder.encode(news)
            userDefaults.set(data, forKey: MagnusStorageKey.addNews.rawValue)
        } catch {
            throw MagnusStorageError.encodingFailed
        }
    }

    public func getNewsRequest() throws -> AddNewsRequest? {
        guard let data = userDefaults.data(forKey: MagnusStorageKey.addNews.rawValue) else {
            return nil
        }
        
        do {
            return try jsonDecoder.decode(AddNewsRequest.self, from: data)
        } catch {
            throw MagnusStorageError.decodingFailed
        }
    }

    public func getAgendaItem() throws -> ConferenceEventAgendaContent? {
        guard let data = userDefaults.data(forKey: MagnusStorageKey.agendaItem.rawValue) else {
            return nil
        }
        
        do {
            return try jsonDecoder.decode(ConferenceEventAgendaContent.self, from: data)
        } catch {
            throw MagnusStorageError.decodingFailed
        }
    }

    public func saveAgendaItem(agendaItem: ConferenceEventAgendaContent) throws {
        do {
            let data = try jsonEncoder.encode(agendaItem)
            userDefaults.set(data, forKey: MagnusStorageKey.agendaItem.rawValue)
        } catch {
            throw MagnusStorageError.encodingFailed
        }
    }

    public func getLocation() throws -> ConferenceEventLocation? {
        guard let data = userDefaults.data(forKey: MagnusStorageKey.location.rawValue) else {
            return nil
        }
        
        do {
            return try jsonDecoder.decode(ConferenceEventLocation.self, from: data)
        } catch {
            throw MagnusStorageError.decodingFailed
        }
    }

    public func saveLocation(location: ConferenceEventLocation) throws {
        do {
            let data = try jsonEncoder.encode(location)
            userDefaults.set(data, forKey: MagnusStorageKey.location.rawValue)
        } catch {
            throw MagnusStorageError.encodingFailed
        }
    }
}

private extension IosStorageService {
    
    func saveToKeychain(key: String, value: String) throws {
        // Delete existing item first
        try? removeFromKeychain(key: key)
        
        let data = value.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw MagnusStorageError.keychainError(status)
        }
    }
    
    func getFromKeychain(key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecItemNotFound {
            return nil
        }
        
        guard status == errSecSuccess else {
            throw MagnusStorageError.keychainError(status)
        }
        
        guard let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            throw MagnusStorageError.invalidData
        }
        
        return string
    }
    
    func removeFromKeychain(key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        // errSecItemNotFound is OK - means item was already deleted
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw MagnusStorageError.keychainError(status)
        }
    }
} 
    

