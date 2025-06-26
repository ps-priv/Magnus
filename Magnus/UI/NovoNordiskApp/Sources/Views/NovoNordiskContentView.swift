import SwiftUI

struct NovoNordiskContentView: View {

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Novo Nordisk App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
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
