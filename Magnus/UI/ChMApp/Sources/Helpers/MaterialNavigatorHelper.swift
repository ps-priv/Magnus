import SwiftUI
import Foundation
import MagnusDomain

public class MaterialNavigatorHelper {
    
    public static func navigateToMaterial(link: String, fileType: FileTypeEnum) {
        if link.isEmpty {
            return
        }

        if fileType == FileTypeEnum.pdf {
            if let url = URL(string: link) {
                UIApplication.shared.open(url)
            }
        }

        if fileType == FileTypeEnum.docx {
            if let url = URL(string: link) {
                UIApplication.shared.open(url)
            }
         }

        if fileType == FileTypeEnum.link {
            if let url = URL(string: link) {
                UIApplication.shared.open(url)
            }
        }

        if fileType == FileTypeEnum.sharepoint {
            if let url = URL(string: link) {
                UIApplication.shared.open(url)
            }
        }
    }

    public static func navigateToMaterial(material: ConferenceMaterialListItem) {
        navigateToMaterial(link: material.link, fileType: material.file_type)
    }

    public static func navigateToMaterialItem(material: MaterialItem) {
        navigateToMaterial(link: material.link ?? "", fileType: material.file_type)
    }

    public static func navigateToMaterialUrl(link: String, fileType: FileTypeEnum) {
        navigateToMaterial(link: link, fileType: fileType)
    }
}
