import MagnusDomain
import SwiftUI

struct NewsAddCardView: View {
    @State public var tags: [String] = []
    @State public var selectedGroups: [NewsGroup] = []
    @State public var attachments: [NewsAttachment] = []

    @State public var title: String = ""
    @State public var content: String = ""
    @State public var image: Data?

    @State public var canSendNews: Bool = false

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
        tags: [String] = [],
        selectedGroups: [NewsGroup] = [],
        attachments: [NewsAttachment] = [],
        title: String = "",
        content: String = "",
        image: Data?,
        canSendNews: Bool = false
    ) {
        self.saveAction = saveAction
        self.cancelAction = cancelAction
        self.deleteAction = deleteAction
        self.publishAction = publishAction
        self.availableGroups = availableGroups
        self.tags = tags
        self.selectedGroups = selectedGroups
        self.attachments = attachments
        self.title = title
        self.content = content
        self.image = image
        self.canSendNews = canSendNews
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                PublishButton(action: publishAction)
                WhiteButton(
                    title: LocalizedStrings.saveButton,
                    action: saveAction,
                    isDisabled: !canSendNews)
                WhiteButton(
                    title: LocalizedStrings.cancelButton,
                    action: cancelAction,
                    isDisabled: !canSendNews)
                Spacer()
                DeleteButton(action: deleteAction)
            }
            NovoNordiskTextBox(
                placeholder: LocalizedStrings.newsAddTitle,
                text: $title
            )

            SelectAndDisplayImage(
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
            tags: [],
            selectedGroups: [],
            attachments: [],
            title: "",
            content: "",
            image: nil,
            canSendNews: false) 
    }
    .padding()
    .background(Color.novoNordiskBackgroundGrey)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}