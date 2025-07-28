import Foundation
import MagnusApplication
import MagnusDomain
import MagnusFeatures


extension ConferenceMaterialType {
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

class ConferenceMaterialTypeConverter {
    
    public static func getIcon(from materialType: ConferenceMaterialType) -> FontAwesome.Icon {
        
        switch materialType {
            case .pdf:
                return FontAwesome.Icon.filePdf
            case .docx:
                return FontAwesome.Icon.fileWord
            case .link:
                return FontAwesome.Icon.fileUrl
            case .sharepoint:
                return FontAwesome.Icon.fileUrl
            default:
                return FontAwesome.Icon.file
        }
    }
}
