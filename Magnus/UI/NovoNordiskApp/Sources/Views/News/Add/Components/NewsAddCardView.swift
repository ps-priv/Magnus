import SwiftUI  

struct NewsAddCardView: View {
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                PublishButton(action: {
                    print("PublishButton Tapped")
                })
                WhiteButton(title: LocalizedStrings.saveButton, action: {
                    print("Cancel Button Tapped")
                })
                WhiteButton(title: LocalizedStrings.cancelButton, action: {
                    print("Save Button Tapped")
                })
                Spacer()
                DeleteButton(action: {
                    print("Delete Button Tapped")
                })
            }
            NovoNordiskTextBox(
                placeholder: LocalizedStrings.newsAddTitle,
                text: .constant("")
            )
            VStack (alignment: .leading) {
                Text(LocalizedStrings.newsAddAttachments)
                .font(.novoNordiskRegularText)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskTextGrey)
                HStack {
                    AttachmentFromDevice(action: {
                        print("AttachmentFromDevice Tapped")
                    })
                    Spacer()
                    AttachmentFromLink(action: {
                        print("AttachmentFromLink Tapped")
                    })
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack {
                Text(LocalizedStrings.newsAddContent)
                .font(.novoNordiskRegularText)
                .fontWeight(.bold)
                .foregroundColor(Color.novoNordiskTextGrey)

                NovoNordiskTextBox(
                    placeholder: LocalizedStrings.newsAddTitle,
                    text: .constant("")
                )
            }            
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
}

#Preview {
    VStack {
        NewsAddCardView()
    }
    .padding()
    .background(Color.novoNordiskBackgroundGrey)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
