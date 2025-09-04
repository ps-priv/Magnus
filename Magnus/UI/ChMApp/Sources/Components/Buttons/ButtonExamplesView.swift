import SwiftUI

struct ButtonExamplesView: View {
    @State private var showAlert = false
    @State private var counter = 0
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("NovoNordisk Button Examples")
                .font(.title2)
                .fontWeight(.bold)
            
            // 1. Prosty alert
            NovoNordiskButton(title: "Pokaż Alert", style: .primary) {
                showAlert = true
            }
            
            // 2. Zwiększ licznik
            NovoNordiskButton(title: "Licznik: \(counter)", style: .secondary) {
                counter += 1
            }
            
            // 3. Async akcja (np. sieć)
            NovoNordiskButton(
                title: isLoading ? "Ładowanie..." : "Zaloguj się",
                style: .primary,
                isEnabled: !isLoading
            ) {
                performLogin()
            }
            
            // 4. Nawigacja
            NovoNordiskButton(title: "Przejdź dalej", style: .outline) {
                navigateToNextScreen()
            }
            
            // 5. Akcja niebezpieczna
            NovoNordiskButton(title: "Usuń konto", style: .danger) {
                deleteAccount()
            }
            
            Spacer()
        }
        .padding()
        .alert("Alert!", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text("Przycisk został kliknięty!")
        }
    }
    
    // MARK: - Actions
    private func performLogin() {
        isLoading = true
        
        // Symulacja zapytania sieciowego
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            print("Logowanie zakończone!")
        }
    }
    
    private func navigateToNextScreen() {
        print("Nawigacja do następnego ekranu")
        // Tutaj możesz dodać logikę nawigacji
    }
    
    private func deleteAccount() {
        print("⚠️ Usuwanie konta...")
        // Tutaj logika usuwania konta
    }
}

#Preview {
    ButtonExamplesView()
} 