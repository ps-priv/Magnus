import SwiftUI
import MagnusDomain
import MagnusFeatures
import MagnusApplication

struct ReadListForNews: View {
    let read: [ReadBy]

    var body: some View {
            LazyVStack(alignment: .leading) {
                ForEach(read, id: \.self) { read in
                    ReadRowItemView(read: read)
                        .padding(.vertical, 4)
                }
            }
    }
}