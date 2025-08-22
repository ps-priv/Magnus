public struct NewsAttachment: Hashable, Encodable {
    public let title: String
    public let type: FileTypeEnum
    public let content: String    
    public let url: String

    public init(title: String, type: FileTypeEnum, content: String, url: String) {
        self.title = title
        self.type = type
        self.content = content
        self.url = url
    }
}

public extension NewsAttachment {
    static func fromLink(title: String, url: String) -> NewsAttachment {
        return NewsAttachment(title: title, type: FileTypeEnum.link, content: "", url: url)
    }

    static func fromSharepoint(title: String, url: String) -> NewsAttachment {
        return NewsAttachment(title: title, type: FileTypeEnum.sharepoint, content: "", url: url)
    }

    static func fromPdf(title: String, content: String) -> NewsAttachment {
        return NewsAttachment(title: title, type: FileTypeEnum.pdf, content: content, url: "")
    }

    static func fromDocx(title: String, content: String) -> NewsAttachment {
        return NewsAttachment(title: title, type: FileTypeEnum.docx, content: content, url: "")
    }
}