import SwiftUI
import MagnusFeatures
import MagnusDomain

struct MessagesListView: View {
    @StateObject private var viewModel: MessagesListViewModel
    @EnvironmentObject var navigationManager: NavigationManager

    init() {
        _viewModel = StateObject(wrappedValue: MessagesListViewModel())
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingIndicator()
            } else if viewModel.messages.isEmpty {
                MessagesListEmptyView()
            } else {
                MessagesListCardView(messages: viewModel.messages)
            } 
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.novoNordiskBackgroundGrey)
        // .toast(isPresented: $viewModel.showToast, message: viewModel.errorMessage)
    }
}