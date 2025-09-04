public struct AcademyCategoryArticle: Identifiable, Equatable, Decodable, Hashable {
    public let id: String
    public let name: String
    public let file_type: FileTypeEnum
    public let link: String
    public let publication_date: String

    public init(id: String, name: String, file_type: FileTypeEnum, link: String, publication_date: String) {
        self.id = id
        self.name = name
        self.file_type = file_type
        self.link = link
        self.publication_date = publication_date
    }
}
