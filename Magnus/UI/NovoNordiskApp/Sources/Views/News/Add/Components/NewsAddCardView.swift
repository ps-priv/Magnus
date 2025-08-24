import MagnusDomain
import SwiftUI

struct NewsAddCardView: View {
    @Binding public var tags: [String]
    @Binding public var selectedGroups: [NewsGroup]
    @Binding public var attachments: [NewsAttachment]

    @Binding public var title: String
    @Binding public var content: String
    @Binding public var image: Data?

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
            VStack(alignment: .leading)  {
                Text(LocalizedStrings.newsAddTitle)
                    .font(.novoNordiskRegularText)
                    .fontWeight(.bold)
                    .foregroundColor(Color.novoNordiskTextGrey)
                NovoNordiskTextBox(
                    placeholder: LocalizedStrings.newsAddTitle,
                    text: $title
                )
            }

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