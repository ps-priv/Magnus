public struct NewsMaterial : Identifiable, Hashable, Decodable {
    public let id: String
    public let title: String
    public let link: String
    public let file_type: FileTypeEnum   

    public init(id: String, title: String, link: String, file_type: FileTypeEnum) {
        self.id = id
        self.title = title
        self.link = link
        self.file_type = file_type
    }
}