import SwiftUI

struct NovoNordiskContentView: View {

    @State private var welcome = "Kliknij przycisk aby zalogować się"

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Novo Nordisk App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)

                Text(welcome)
                    .font(.body)
                    .foregroundColor(.gray)

                NovoNordiskButton(title: "Zaloguj uzytkownika", style: .primary) {
                    print("Zaloguj uzytkownika")
                }

                    Spacer()
            }
            .padding()
            .onAppear {

            }
        }
    }
}

struct NovoNordiskContentView_Previews: PreviewProvider {
    static var previews: some View {
        NovoNordiskContentView()
    }
}
