import SwiftUI
import MagnusFeatures
import MagnusDomain

struct MessagesListView: View {
    @StateObject private var viewModel = MessagesListViewModel()
    @State private var loadTask: Task<Void, Never>?
    @EnvironmentObject var navigationManager: NavigationManager
    
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
        .onAppear {
            loadTask?.cancel()
            loadTask = Task { @MainActor in
                viewModel.loadData()
            }
        }
        .onDisappear {
            loadTask?.cancel()
            loadTask = nil
        }
        // .toast(isPresented: $viewModel.showToast, message: viewModel.errorMessage)
    }
}