import FloatingButton
import MagnusFeatures
import SwiftUI

struct NewsEditView: View {
    let newsId: String
    @EnvironmentObject private var navigationManager: NavigationManager
    @StateObject private var viewModel: NewsEditViewModel
    @State private var isOpen: Bool = false
    @State private var showSaveConfirmation: Bool = false
    @State private var showDeleteConfirmation: Bool = false

    init(newsId: String) {
        self.newsId = newsId
        _viewModel = StateObject(wrappedValue: NewsEditViewModel(id: newsId))
    }

    var body: some View {
        ZStack {
            ScrollView {
                if viewModel.isLoading {
                    LoadingIndicator()
                } else {
                    VStack {
                        NewsEditCardView(
                            saveAction: {

                            },
                            cancelAction: {
                                navigationManager.navigate(to: .newsList)
                            },
                            deleteAction: {
                                showDeleteConfirmation = true
                            },
                            publishAction: {
                                showSaveConfirmation = true

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
                                await viewModel.saveChanges()
                                if !viewModel.hasError {
                                    try? await Task.sleep(nanoseconds: 2_000_000_000)
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
                    .novoNordiskAlert(
                        isPresented: $showDeleteConfirmation,
                        title: LocalizedStrings.newsDeleteConfirmationMessage,
                        message: nil,
                        icon: .delete,
                        primaryTitle: LocalizedStrings.deleteButton,
                        primaryStyle: .destructive,
                        primaryAction: {
                            Task {
                                await viewModel.deleteNews()
                                if !viewModel.hasError {
                                    try? await Task.sleep(nanoseconds: 2_000_000_000)
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
                    showDeleteConfirmation = true
                }) {
                    FAIcon(
                        .delete,
                        type: .light,
                        size: 20,
                        color: Color.white
                    )
                    .frame(width: 50, height: 50)
                    .background(Color.novoNordiskOrange)
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
