import SwiftUI

struct NovoNordiskContentView: View {
    var body: some View {
        TabView {
            // Home tab
            NavigationView {
                VStack(spacing: 20) {
                    Text(LocalizedStrings.appTitle)
                        .font(.novoNordiskTitle)
                        .foregroundColor(Color("NovoNordiskBlue"))

                    Text(LocalizedStrings.welcomeMessage)
                        .font(.novoNordiskBody)
                        .foregroundColor(.gray)

                    NovoNordiskButton(title: LocalizedStrings.loginUserButton, style: .primary) {
                        print("Login user button tapped")
                    }

                    Spacer()
                }
                .padding()
            }
            .tabItem {
                FAIcon(.home, type: .light)
                Text(LocalizedStrings.tabHome)
            }
            
            // Buttons examples
            ButtonExamplesView()
                .tabItem {
                    FAIcon(.bell, type: .light)
                    Text(LocalizedStrings.tabButtons)
                }
            
            // Text boxes examples
            TextBoxExamplesView()
                .tabItem {
                    FAIcon(.calendar, type: .light)
                    Text(LocalizedStrings.tabTextBoxes)
                }
            
            // Radio buttons examples
            RadioButtonExamplesView()
                .tabItem {
                    FAIcon(.chartLine, type: .light)
                    Text(LocalizedStrings.tabRadioButtons)
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
