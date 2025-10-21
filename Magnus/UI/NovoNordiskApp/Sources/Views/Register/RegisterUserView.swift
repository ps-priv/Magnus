import MagnusFeatures
import MagnusDomain
import SwiftUI

struct RegisterUserView: View {
    
    //@StateObject private var viewModel = RegisterUserViewModel()

    private let user: RegisterUserRequest = RegisterUserRequest(from: nil)
    let onRegister: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        ScrollView {
            VStack {
                RegisterUserProfileView(user: user, onRegister: onRegister, onCancel: onCancel)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Color.novoNordiskBackgroundGrey)
        .keyboardResponsive()
    }
}   