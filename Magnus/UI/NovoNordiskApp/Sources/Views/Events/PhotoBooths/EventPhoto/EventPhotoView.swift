import SwiftUI

struct EventPhotoView: View {
    var photoId: String

    init(photoId: String) {
        self.photoId = photoId
    }

    var body: some View {
        Text("Event Photo \(photoId)")
    }
}

