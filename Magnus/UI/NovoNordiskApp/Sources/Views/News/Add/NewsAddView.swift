import FloatingButton
import MagnusFeatures
import SwiftUI

struct NewsAddView: View {

    @StateObject private var viewModel: NewsAddViewModel = NewsAddViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    @State private var isOpen: Bool = false
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""
    @State private var showSaveConfirmation: Bool = false

    var body: some View {
        ZStack {
            ScrollView {
                if viewModel.isLoading {
                    LoadingIndicator()
                } else {
                    VStack {
                        NewsAddCardView(
                            saveAction: {
                                Task {
                                    await viewModel.saveNewsRequest()
                                }
                            },
                            cancelAction: {
                                navigationManager.navigate(to: .newsList)
                            },
                            deleteAction: {
                                navigationManager.navigate(to: .newsList)
                            },
                            publishAction: {
                                Task {
                                    await viewModel.sendNews()
                                    if !viewModel.hasError {
                                        await MainActor.run {
                                            navigationManager.navigate(to: .newsList)
                                        }
                                    }
                                }
                            },
                            availableGroups: viewModel.groups,
                            tags: $viewModel.tags,
                            selectedGroups: $viewModel.selectedGroups,
                            attachments: $viewModel.attachments,
                            title: $viewModel.title,
                            content: $viewModel.content,
                            image: $viewModel.image,
                            allowComments: $viewModel.allowComments,
                            canSendNews: viewModel.canSendNews)

                        // Add some bottom padding to ensure content doesn't get hidden behind the floating button
                        Spacer()
                            .frame(height: 100)
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .padding(.vertical, 20)
            .padding(.horizontal, 16)
            .background(Color.novoNordiskBackgroundGrey)
            .ignoresSafeArea(.keyboard)
            .keyboardAdaptiveMedium()
            .dismissKeyboardOnTap()

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    floatingButtonSection
                }
                .padding(.trailing, 16)
                .padding(.bottom, 20)
            }
        }
        .alert(isPresented: $showToast) {
            Alert(
                title: Text(LocalizedStrings.error),
                message: Text(toastMessage),
                dismissButton: .default(Text(LocalizedStrings.ok))
            )
        }
        .novoNordiskAlert(
            isPresented: $showSaveConfirmation,
            title: LocalizedStrings.newsSaveConfirmationMessage,
            message: nil,
            icon: .save,
            primaryTitle: LocalizedStrings.saveButton,
            primaryStyle: .destructive,
            primaryAction: {
                Task {
                    await viewModel.sendNews()

                    if !viewModel.hasError {
                        await MainActor.run {
                            navigationManager.navigate(to: .newsList)
                        }
                    }
                }
            },
            secondaryTitle: LocalizedStrings.cancelButton,
            secondaryStyle: .cancel,
            secondaryAction: {
                // Cancel tapped
            }
        )
        // .toast(isPresented: $viewModel.showToast, message: viewModel.message)
    }

    private var textButtons: [AnyView] {
        [
            AnyView(
                Button(action: {
                    navigationManager.navigate(to: .newsList)
                }) {
                    FAIcon(
                        .back,
                        type: .light,
                        size: 20,
                        color: Color.white
                    )
                    .frame(width: 50, height: 50)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .padding(.trailing, 5)
                }),
            AnyView(
                Button(action: {
                    showSaveConfirmation = true
                }) {
                    FAIcon(
                        .save,
                        type: .light,
                        size: 20,
                        color: Color.white
                    )
                    .frame(width: 50, height: 50)
                    .background(viewModel.canSendNews ? Color.green : Color.gray)
                    .clipShape(Circle())
                    .padding(.trailing, 5)
                }
                .disabled(!viewModel.canSendNews)
            ),
        ]
    }

    @ViewBuilder
    private var floatingButtonSection: some View {
        let mainButton = AnyView(
            Button(action: {
                isOpen.toggle()
            }) {
                FAIcon(
                    .ellipsisVertical,
                    type: .regular,
                    size: 20,
                    color: Color.white
                )
                .frame(width: 60, height: 60)
                .background(Color.novoNordiskOrangeRed)
                .clipShape(Circle())
            }
        )

        let menu1 = FloatingButton(
            mainButtonView: mainButton, buttons: textButtons, isOpen: $isOpen
        )
        .straight()
        .direction(.top)
        .alignment(.right)
        .spacing(10)
        .animation(.spring())

        menu1
    }
}
