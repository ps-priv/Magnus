import Foundation
import MagnusDomain
import MagnusFeatures


extension FileTypeEnum {
    var fontAwesomeIcon: String {
        switch self {
        case .pdf:
            return FontAwesome.Icon.filePdf.rawValue
        case .docx:
            return FontAwesome.Icon.fileWord.rawValue
        case .sharepoint:
            return FontAwesome.Icon.fileUrl.rawValue
        case .link:
            return FontAwesome.Icon.fileUrl.rawValue
        }
    }
}

class FileTypeConverter {
    
    public static func getIcon(from fileType: FileTypeEnum) -> FontAwesome.Icon {
        
        switch fileType {
            case .pdf:
                return FontAwesome.Icon.filePdf
            case .docx:
                return FontAwesome.Icon.fileWord
            case .link:
                return FontAwesome.Icon.fileUrl
            case .sharepoint:
                return FontAwesome.Icon.fileUrl
            // default:
            //     return FontAwesome.Icon.file
        }
    }
}
