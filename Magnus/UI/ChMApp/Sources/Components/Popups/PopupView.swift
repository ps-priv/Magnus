import SwiftUI

struct PopupContent: View {
    @Binding var a: Bool

    var body: some View {
        VStack {
            Button("Switch a") {
                a.toggle()
            }
            a ? Text("on").foregroundStyle(.green) : Text("off").foregroundStyle(.red)
        }
    }
}

