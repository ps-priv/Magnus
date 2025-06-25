public struct CurrentUser {
    public let id: String
    public let email: String
    public let firstname: String
    public let lastname: String
    public let phone: String
    public let address: String
    public let city: String
    public let postalCode: String
    public let pesel: String
    
    public init(id: String, email: String, firstname: String, lastname: String, phone: String, address: String, city: String, postalCode: String, pesel: String) {
        self.id = id
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
        self.phone = phone
        self.address = address
        self.city = city
        self.postalCode = postalCode
        self.pesel = pesel
    }
}