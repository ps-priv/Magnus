import MagnusDomain
import MagnusFeatures
import SwiftUI

struct AgendaAssessmentView: View {

    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var viewModel: AgendaAssessmentViewModel
    @State private var didReturn = false

    init(agendaContentId: String) {
        _viewModel = StateObject(wrappedValue: AgendaAssessmentViewModel(agendaContentId: agendaContentId))
    }

    init(viewModel: AgendaAssessmentViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            title
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.novoNordiskBackgroundGrey)
    }

    private var title: some View {
        HStack {
            Text(LocalizedStrings.agendaAssessmentScreenTitle)
                .font(.novoNordiskSectionTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskBlue)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            Spacer()
        }
        .background(Color.novoNordiskLighGreyForPanelBackground)
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isSubmitted {
            AgendaAssessmentThankYouView(onReturn: returnToDashboard)
        } else {
            AgendaAssessmentFormView(
                assessment: viewModel.assessment,
                description: $viewModel.description,
                isSubmitting: viewModel.isSubmitting,
                errorMessage: viewModel.hasError ? LocalizedStrings.agendaAssessmentError : nil,
                onSelectStar: viewModel.selectStar,
                onSubmit: { Task { await viewModel.submit() } }
            )
        }
    }

    private func returnToDashboard() {
        guard !didReturn else { return }
        didReturn = true
        navigationManager.navigateToTabRoot(.start)
    }
}

#Preview("Sukces") {
    AgendaAssessmentView(viewModel: AgendaAssessmentViewModel(
        agendaContentId: "preview",
        agendaAssessmentService: AgendaAssessmentServiceMock()
    ))
    .environmentObject(NavigationManager.shared)
}

#Preview("Błąd wysyłania") {
    AgendaAssessmentView(viewModel: AgendaAssessmentViewModel(
        agendaContentId: "preview",
        agendaAssessmentService: AgendaAssessmentServiceMock(error: URLError(.notConnectedToInternet))
    ))
    .environmentObject(NavigationManager.shared)
}
