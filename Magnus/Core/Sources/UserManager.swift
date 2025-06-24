import Foundation

public class UserManager {
    public static let shared = UserManager()
    
    private init() {}
    
    public func createUser(id: String, email: String, firstname: String, lastname: String) -> User {
        return User(id: id, email: email, firstname: firstname, lastname: lastname)
    }
    
    public func validateUser(_ user: User) -> Bool {
        return !user.id.isEmpty && 
               !user.email.isEmpty && 
               !user.firstname.isEmpty && 
               !user.lastname.isEmpty &&
               user.email.contains("@")
    }
    
    public func formatUserDisplayName(_ user: User) -> String {
        return user.fullName
    }
} 