
public struct NewsMaterialToNewsAttachmentConverter {
    public static func convert(newsMaterial: NewsMaterial) -> NewsAttachment {
        return NewsAttachment(
            title: newsMaterial.title,
            type: newsMaterial.file_type, 
            content: newsMaterial.link, 
            url: newsMaterial.link)
    }

    public static func convert(newsMaterials: [NewsMaterial]) -> [NewsAttachment] {
        return newsMaterials.map { convert(newsMaterial: $0) }
    }
}