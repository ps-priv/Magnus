import SwiftUI

struct ChMContentView: View {

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("ChM App")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
             
                Spacer()
            }
            .padding()
            .navigationTitle("ChM")
            .onAppear {

                
            }
        }
    }
}

struct ChMContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChMContentView()
    }
} 