import SwiftUI

struct NovoNordiskContentView: View {
    @State private var welcome = "Kliknij przycisk aby zalogować się"

    var body: some View {
        TabView {
            // Home tab
            NavigationView {
                VStack(spacing: 20) {
                    Text("Novo Nordisk App")
                        .font(.novoNordiskTitle)
                        .foregroundColor(Color("NovoNordiskBlue"))

                    Text(welcome)
                        .font(.novoNordiskBody)
                        .foregroundColor(.gray)

                    NovoNordiskButton(title: "Zaloguj uzytkownika", style: .primary) {
                        print("Zaloguj uzytkownika")
                    }

                    Spacer()
                }
                .padding()
            }
            .tabItem {
                FAIcon(.home, type: .light)
                Text("Home")
            }
            
            // Buttons examples
            ButtonExamplesView()
                .tabItem {
                    FAIcon(.bell, type: .light)
                    Text("Buttons")
                }
            
            // Text boxes examples
            TextBoxExamplesView()
                .tabItem {
                    FAIcon(.calendar, type: .light)
                    Text("Text Boxes")
                }
            
            // Radio buttons examples
            RadioButtonExamplesView()
                .tabItem {
                    FAIcon(.chartLine, type: .light)
                    Text("Radio Buttons")
                }
                
        }
        .accentColor(Color("NovoNordiskBlue"))
    }
}

struct NovoNordiskContentView_Previews: PreviewProvider {
    static var previews: some View {
        NovoNordiskContentView()
    }
}
