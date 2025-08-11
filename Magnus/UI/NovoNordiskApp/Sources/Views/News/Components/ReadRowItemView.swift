import SwiftUI
import MagnusDomain
import MagnusFeatures
import MagnusApplication

struct ReadRowItemView: View {
    let read: ReadBy    

    init(read: ReadBy) {
        self.read = read
    }
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    FAIcon(
                        FontAwesome.Icon.userCircle,    
                        type: .thin,
                        size: 25,
                        color: Color.novoNordiskBlue
                    )
                    VStack(alignment: .leading) {
                        Text(read.author.name)
                            .font(.novoNordiskAuthorName)
                        Text(read.author.groups)
                            .font(.novoNordiskAuthorGroups)
                            .foregroundColor(Color.novoNordiskBlue)
                    }
                }
                Spacer()
                FAIcon(
                    FontAwesome.Icon.eye,    
                    type: .thin,
                    size: 25,
                    color: Color.novoNordiskBlue
                )
            }
        }
    }
}

#Preview {
    let read: ReadBy = ReadBy(author: Author(id: "1", name: "Joanna Skarżyńska-Kotyńska", groups: "Kardiologia, Badania i rozwój"))
    VStack {
        ReadRowItemView(read: read)
    }
    .background(Color.white)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}