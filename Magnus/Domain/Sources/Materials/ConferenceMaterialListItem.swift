public struct ConferenceMaterialListItem: Identifiable, Hashable, Decodable{
    public let id: String
    public let name: String
    public let file_type: FileTypeEnum
    public let link: String
    public let publication_date: String
    public let type: MaterialTypeEnum 
    public let event_title: String?
    public let date_from: String?
    public let date_to: String?

    public init(
        id: String,
        name: String,
        file_type: FileTypeEnum,
        link: String,
        publication_date: String,
        type: MaterialTypeEnum,
        event_title: String?,
        date_from: String?,
        date_to: String?
    ) {
        self.id = id
        self.name = name
        self.file_type = file_type
        self.link = link
        self.publication_date = publication_date
        self.type = type
        self.event_title = event_title
        self.date_from = date_from
        self.date_to = date_to
    }
}