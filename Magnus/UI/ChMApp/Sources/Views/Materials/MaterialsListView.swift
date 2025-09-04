import SwiftUI
import MagnusFeatures

struct MaterialsListView: View {
    @StateObject private var viewModel: MaterialsListViewModel

    @State private var materialId: String = ""

    init(materialId: String) {
        _viewModel = StateObject(wrappedValue: MaterialsListViewModel())
        self.materialId = materialId
    }
    

    var body: some View {
        Group {
            if viewModel.isLoading {
                LoadingIndicator()
            } else if viewModel.materials.isEmpty {
                MaterialsListEmptyView()
            } else {
                MaterialsListCardView(materials: viewModel.materials, materialId: materialId)
                .padding(.horizontal, 16)
            } 
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.novoNordiskBackgroundGrey)
        .toast(isPresented: $viewModel.showToast, message: viewModel.errorMessage)
    }
}
