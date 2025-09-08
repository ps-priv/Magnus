import MagnusDomain
import SwiftUI

struct NewsEditCardView: View {
    @EnvironmentObject private var navigationManager: NavigationManager
    @State private var showSaveConfirmation: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""

    @Binding public var tags: [String]
    @Binding public var selectedGroups: [NewsGroup]
    @Binding public var attachments: [NewsAttachment]

    @Binding public var title: String
    @Binding public var content: String
    @Binding public var image: Data?

    @FocusState private var isFocusedTitle: Bool    
    @FocusState private var isFocusedContent: Bool

    public var canSendNews: Bool = false

    let saveAction: () -> Void
    let cancelAction: () -> Void
    let deleteAction: () -> Void
    let publishAction: () -> Void

    var availableGroups: [NewsGroup] = []

    init(
        saveAction: @escaping () -> Void,
        cancelAction: @escaping () -> Void,
        deleteAction: @escaping () -> Void,
        publishAction: @escaping () -> Void,
        availableGroups: [NewsGroup],
        tags: Binding<[String]>,
        selectedGroups: Binding<[NewsGroup]>,
        attachments: Binding<[NewsAttachment]>,
        title: Binding<String>,
        content: Binding<String>,
        image: Binding<Data?>,
        canSendNews: Bool = false
    ) {
        self.saveAction = saveAction
        self.cancelAction = cancelAction
        self.deleteAction = deleteAction
        self.publishAction = publishAction
        self.availableGroups = availableGroups
        self._tags = tags
        self._selectedGroups = selectedGroups
        self._attachments = attachments
        self._title = title
        self._content = content
        self._image = image
        self.canSendNews = canSendNews
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                PublishButton(action: {
                    showSaveConfirmation = true
                }, isDisabled: !canSendNews)
                // WhiteButton(
                //     title: LocalizedStrings.saveButton,
                //     action: saveAction,
                //     isDisabled: !canSendNews)
                WhiteButton(
                    title: LocalizedStrings.cancelButton,
                    action: cancelAction,
                    isDisabled: !canSendNews)
                Spacer()
                DeleteButton(action: {
                    showDeleteConfirmation = true
                })
            }
            VStack(alignment: .leading)  {
                Text(LocalizedStrings.newsAddTitle)
                    .font(.novoNordiskRegularText)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskTextGrey)
                NovoNordiskTextBox(
                    placeholder: LocalizedStrings.newsAddTitle,
                    text: $title
                )
                .focused($isFocusedTitle)
            }
            // .toolbar {
            //     ToolbarItemGroup(placement: .keyboard) {
            //         Spacer()
            //         Button(LocalizedStrings.endEditingButton) { isFocusedTitle = false }
            //         .background(Color.novoNordiskBlue)
            //         .foregroundColor(.white)
            //         .cornerRadius(8)
            //     }
            // }

            SelectAndDisplayImage(
                imageData: $image,
                onImageSelected: {
                    image = $0
                }
            )

            AttachmentsManager(attachments: $attachments)

            VStack(alignment: .leading) {
                Text(LocalizedStrings.newsAddContent)
                    .font(.novoNordiskRegularText)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskTextGrey)

                NovoNordiskTextArea(
                    placeholder: LocalizedStrings.newsAddContent,
                    text: $content
                )
                .focused($isFocusedContent)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading) {
                Text(LocalizedStrings.newsAddTags)
                    .font(.novoNordiskRegularText)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            ChipView(chips: $tags, placeholder: "#Tag")

            AudienceSettings(selectedGroups: $selectedGroups, availableGroups: availableGroups)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
        // .toolbar {
        //     ToolbarItemGroup(placement: .keyboard) {
        //         Spacer()
        //         Button(LocalizedStrings.endEditingButton) { 
        //             isFocusedContent = false
        //             isFocusedTitle = false 
        //         }
        //         .background(Color.novoNordiskBlue)
        //         .foregroundColor(.white)
        //         .cornerRadius(8)
        //     }
        // }
        .novoNordiskAlert(
            isPresented: $showDeleteConfirmation,
            title: LocalizedStrings.newsDeleteConfirmationMessage,
            message: nil,
            icon: .delete,
            primaryTitle: LocalizedStrings.deleteButton,
            primaryStyle: .destructive,
            primaryAction: {
                deleteAction()
                showToast = true
                toastMessage = LocalizedStrings.newsDeletedMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    navigationManager.navigateToTabRoot(.news)
                }
            },
            secondaryTitle: LocalizedStrings.cancelButton,
            secondaryStyle: .cancel,
            secondaryAction: {
                // Cancel tapped
            }
        )
        .novoNordiskAlert(
            isPresented: $showSaveConfirmation,
            title: LocalizedStrings.newsSaveConfirmationMessage,
            message: nil,
            icon: .save,
            primaryTitle: LocalizedStrings.saveButton,
            primaryStyle: .destructive,
            primaryAction: {
                publishAction()
                showToast = true
                toastMessage = LocalizedStrings.newsSaveMessage
                // DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                //     navigationManager.navigateToTabRoot(.news)
                // }
            },
            secondaryTitle: LocalizedStrings.cancelButton,
            secondaryStyle: .cancel,
            secondaryAction: {
                // Cancel tapped
            }
        )
        .toast(isPresented: $showToast, message: toastMessage)
    }
}

#Preview {
    VStack {
        NewsEditCardView(
            saveAction: {},
            cancelAction: {},
            deleteAction: {},
            publishAction: {},
            availableGroups: [],
            tags: .constant([]),
            selectedGroups: .constant([]),
            attachments: .constant([]),
            title: .constant(""),
            content: .constant(""),
            image: .constant(nil),
            canSendNews: false)
    }
    .padding()
    .background(Color.novoNordiskBackgroundGrey)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}