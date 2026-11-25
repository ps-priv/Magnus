import MagnusDomain
import SwiftUI
import UIKit

struct NewsAddCardView: View {

    @EnvironmentObject private var navigationManager: NavigationManager
    @State private var showSaveConfirmation: Bool = false
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""

    @Binding public var tags: [String]
    @Binding public var selectedGroups: [NewsGroup]
    @Binding public var attachments: [NewsAttachment]

    @Binding public var title: String
    @Binding public var content: String
    @Binding public var image: Data?
    @Binding public var allowComments: Bool

    @FocusState private var isFocusedTitle: Bool
    @FocusState private var isFocusedContent: Bool

    public var canSendNews: Bool

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
        allowComments: Binding<Bool>,
        canSendNews: Bool
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
        self._allowComments = allowComments
        self.canSendNews = canSendNews
    }

    var body: some View {
        VStack(spacing: 20) {
            // HStack {
            //     PublishButton(
            //         action: {
            //             showSaveConfirmation = true
            //         }, isDisabled: !canSendNews)
            //     Spacer()
            //     WhiteButton(
            //         title: LocalizedStrings.cancelButton,
            //         action: cancelAction,
            //         isDisabled: !canSendNews)

            //     //DeleteButton(action: deleteAction)
            // }
        
            SelectAndDisplayImage(
                imageData: $image,
                onImageSelected: {
                    image = $0
                }
            )
            
            
            VStack(alignment: .leading) {
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

//            SelectAndDisplayImage(
//                imageData: $image,
//                onImageSelected: {
//                    image = $0
//                }
//            )

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


            NovoNordiskCheckbox(
                title: LocalizedStrings.allowComments,
                isChecked: $allowComments,
                //style: .regular
            )


            VStack(alignment: .leading) {
                Text(LocalizedStrings.newsAddTags)
                    .font(.novoNordiskRegularText)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskTextGrey)
            }
            .frame(maxWidth: .infinity, alignment: .leading)



            ChipView(chips: $tags, placeholder: "#Tag")

            AudienceSettings(selectedGroups: $selectedGroups, availableGroups: availableGroups)

            // HStack {
            //     PublishButton(
            //         action: {
            //             showSaveConfirmation = true
            //         }, isDisabled: !canSendNews)
            //     Spacer()
            //     WhiteButton(
            //         title: LocalizedStrings.cancelButton,
            //         action: cancelAction,
            //         isDisabled: !canSendNews)

            //     //DeleteButton(action: deleteAction)
            // }
            // .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding()
        // .novoNordiskAlert(
        //     isPresented: $showSaveConfirmation,
        //     title: LocalizedStrings.newsSaveConfirmationMessage,
        //     message: nil,
        //     icon: .save,
        //     primaryTitle: LocalizedStrings.saveButton,
        //     primaryStyle: .destructive,
        //     primaryAction: {
        //         publishAction()
        //         showToast = true
        //         toastMessage = LocalizedStrings.newsSaveMessage
        //         // DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        //         //     navigationManager.navigateToTabRoot(.news)
        //         // }
        //     },
        //     secondaryTitle: LocalizedStrings.cancelButton,
        //     secondaryStyle: .cancel,
        //     secondaryAction: {
        //         // Cancel tapped
        //     }
        // )
        //.toast(isPresented: $showToast, message: toastMessage)
    }
}

#Preview {
    VStack {
        NewsAddCardView(
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
            allowComments: .constant(true),
            canSendNews: false)
    }
    .padding()
    .background(Color.novoNordiskBackgroundGrey)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}

// MARK: - Keyboard helpers
private extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
