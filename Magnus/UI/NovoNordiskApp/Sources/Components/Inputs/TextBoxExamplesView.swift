import SwiftUI

struct TextBoxExamplesView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("NovoNordisk TextBox Examples")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                // Formularz logowania
                VStack(alignment: .leading, spacing: 15) {
                    Text("Logowanie")
                        .font(.headline)
                        .foregroundColor(Color("NovoNordiskBlue"))
                    
                    NovoNordiskTextBox(
                        placeholder: "wprowadź email",
                        text: $email,
                        style: .withTitle("Email")
                    )
                    
                    NovoNordiskTextBox(
                        placeholder: "wprowadź hasło",
                        text: $password,
                        style: .withTitle("Hasło"),
                        isSecure: true
                    )
                    
                    NovoNordiskButton(title: "Zaloguj się", style: .primary) {
                        performLogin()
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                
                // Formularz rejestracji
                VStack(alignment: .leading, spacing: 15) {
                    Text("Rejestracja")
                        .font(.headline)
                        .foregroundColor(Color("NovoNordiskBlue"))
                    
                    NovoNordiskTextBox(
                        placeholder: "Jan",
                        text: $firstName,
                        style: .withTitle("Imię")
                    )
                    
                    NovoNordiskTextBox(
                        placeholder: "Kowalski",
                        text: $lastName,
                        style: .withTitle("Nazwisko")
                    )
                    
                    NovoNordiskTextBox(
                        placeholder: "+48 123 456 789",
                        text: $phoneNumber,
                        style: .complete(
                            title: "Numer telefonu",
                            helperText: "Format: +48 xxx xxx xxx"
                        )
                    )
                    
                    NovoNordiskTextBox(
                        placeholder: "minimum 8 znaków",
                        text: $confirmPassword,
                        style: .complete(
                            title: "Potwierdź hasło",
                            helperText: passwordValidationMessage
                        ),
                        isSecure: true
                    )
                    
                    NovoNordiskButton(title: "Zarejestruj się", style: .primary) {
                        performRegistration()
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
        }
    }
    
    // MARK: - Computed Properties
    private var passwordValidationMessage: String {
        if confirmPassword.isEmpty {
            return "Hasła muszą być identyczne"
        } else if confirmPassword == password {
            return "✅ Hasła są zgodne"
        } else {
            return "❌ Hasła się różnią"
        }
    }
    
    // MARK: - Actions
    private func performLogin() {
        print("Logowanie: \(email)")
    }
    
    private func performRegistration() {
        print("Rejestracja: \(firstName) \(lastName), \(email)")
    }
}

#Preview {
    TextBoxExamplesView()
} 