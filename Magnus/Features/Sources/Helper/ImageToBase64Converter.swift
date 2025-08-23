import UIKit

public enum ImageToBase64Converter {
    // Main entry: from raw Data -> Base64 string (after resize + compression)
    // - maxDimension: longest side after resize
    // - sizeLimitKB: final max size in KB
    // - minQuality: lowest acceptable JPEG quality
    // - step: decrement for quality search
    public static func convert(
        imageData: Data,
        maxDimension: CGFloat = 1280,
        sizeLimitKB: Int = 300,
        minQuality: CGFloat = 0.4,
        step: CGFloat = 0.1
    ) -> String? {
        guard let original = UIImage(data: imageData) else { return nil }
        return convert(
            image: original,
            maxDimension: maxDimension,
            sizeLimitKB: sizeLimitKB,
            minQuality: minQuality,
            step: step
        )
    }

    // Overload for UIImage input
    public static func convert(
        image: UIImage,
        maxDimension: CGFloat = 1280,
        sizeLimitKB: Int = 300,
        minQuality: CGFloat = 0.4,
        step: CGFloat = 0.1
    ) -> String? {
        // 1) Resize keeping aspect ratio
        let resized = resize(image: image, maxDimension: maxDimension)

        // 2) Ensure no alpha for JPEG; flatten if needed
        let flattened = flattenedIfHasAlpha(resized)

        // 3) Compress iteratively to meet size limit
        let limitBytes = max(1, sizeLimitKB) * 1024
        var quality: CGFloat = 0.9
        var bestData: Data? = nil

        while quality >= minQuality {
            if let data = flattened.jpegData(compressionQuality: quality) {
                bestData = data
                if data.count <= limitBytes { break }
            }
            quality -= step
        }

        guard let finalData = bestData else { return nil }
        return finalData.base64EncodedString()
    }

    // MARK: - Helpers

    private static func resize(image: UIImage, maxDimension: CGFloat) -> UIImage {
        guard maxDimension > 0 else { return image }
        let size = image.size
        let maxSide = max(size.width, size.height)
        if maxSide <= maxDimension { return image }

        let scale = maxDimension / maxSide
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1 // produce pixel size equal to newSize (not multiplied by device scale)
        let renderer = UIGraphicsImageRenderer(size: newSize, format: format)

        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    // If image has alpha, flatten onto white background to allow JPEG compression
    private static func flattenedIfHasAlpha(_ image: UIImage) -> UIImage {
        guard imageHasAlpha(image) else { return image }
        let size = image.size
        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = true
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { ctx in
            UIColor.white.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }

    private static func imageHasAlpha(_ image: UIImage) -> Bool {
        guard let cg = image.cgImage else { return false }
        let alphaInfo = cg.alphaInfo
        switch alphaInfo {
        case .first, .last, .premultipliedFirst, .premultipliedLast:
            return true
        default:
            return false
        }
    }
}