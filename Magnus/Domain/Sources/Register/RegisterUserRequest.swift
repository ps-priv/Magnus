import Foundation

public struct RegisterUserRequest : Codable {
    public let email: String
    public let password: String
    public let firstName: String
    public let lastName: String
    public let department: String
    public let npwz: String
    public let address: String
    public let postalCode: String
    public let city: String
    public let pesel: String
    public let nip: String
    public let companyName: String
    public let taxOffice: String
    public let marketing: Bool
    public let rdo: Bool
    public let policy: Bool

    public init(from user: RegisterUserRequest?) {
        self.email = user?.email ?? ""
        self.password = user?.password ?? ""
        self.firstName = user?.firstName ?? ""
        self.lastName = user?.lastName ?? ""
        self.department = user?.department ?? ""
        self.npwz = user?.npwz ?? ""
        self.address = user?.address ?? ""
        self.postalCode = user?.postalCode ?? ""
        self.city = user?.city ?? ""
        self.pesel = user?.pesel ?? ""
        self.nip = user?.nip ?? ""
        self.companyName = user?.companyName ?? ""
        self.taxOffice = user?.taxOffice ?? ""
        self.marketing = user?.marketing ?? false
        self.rdo = user?.rdo ?? false
        self.policy = user?.policy ?? false
    }


    public init(email: String, password: String, firstName: String, lastName: String, department: String, npwz: String, address: String, postalCode: String, city: String, pesel: String, nip: String, companyName: String, taxOffice: String, marketing: Bool, rdo: Bool, policy: Bool) {
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.department = department    
        self.npwz = npwz
        self.address = address
        self.postalCode = postalCode
        self.city = city
        self.pesel = pesel
        self.nip = nip
        self.companyName = companyName
        self.taxOffice = taxOffice
        self.marketing = marketing
        self.rdo = rdo
        self.policy = policy
    }
}   