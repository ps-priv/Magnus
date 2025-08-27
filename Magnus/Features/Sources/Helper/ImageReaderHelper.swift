import Foundation

public class ImageReaderHelper {
    
    public static func readImage(from url: String) -> Data? {
        guard let url = URL(string: url) else { return nil }
        return try? Data(contentsOf: url)
    }
}