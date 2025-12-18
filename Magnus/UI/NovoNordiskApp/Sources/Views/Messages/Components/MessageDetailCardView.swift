import Kingfisher
import MagnusDomain
import MagnusFeatures
import SwiftUI

struct MessageDetailCardView: View {
    let message: ConferenceMessageDetails

    init(message: ConferenceMessageDetails) {
        self.message = message
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
                // Only show image if picture is not nil
                if let pictureUrl = message.picture, !pictureUrl.isEmpty {
                    KFImage(URL(string: pictureUrl))
                        .placeholder {
                            Rectangle().fill(Color.gray.opacity(0.3))
                                .overlay(
                                    VStack {
                                        ProgressView()
                                            .scaleEffect(1.2)
                                            .tint(.novoNordiskBlue)
                                        FAIcon(.newspaper, type: .light, size: 40, color: .gray)
                                            .padding(.top, 8)
                                    }
                                )
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 190)
                        .clipped()
                        .cornerRadius(12)
                }

                VStack(alignment: .leading) {
                    Text(message.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.novoNordiskTextGrey)
                        .font(.system(size: 19))

                    HStack {
                        Text(message.publish_date)
                            .font(.subheadline)
                            .foregroundColor(Color.novoNordiskBlue)

                        Text("|")
                            .font(.subheadline)
                            .foregroundColor(Color.novoNordiskBlue)

                        Text(message.publish_time)
                            .font(.subheadline)
                            .foregroundColor(Color.novoNordiskBlue)

                        Spacer()
                    }

                    // Text(message.message)
                    //     .font(.body)
                    //     .foregroundColor(Color.novoNordiskTextGrey)
                    //     .padding(.horizontal, 16)
                    //     .padding(.vertical, 8)

                    Text(makeLinksClickable(message.message))
                        .font(.body)
                        .foregroundColor(Color.novoNordiskTextGrey)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                }
                .padding(16)
            }
            .background(Color.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(25)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white, lineWidth: 3)
        )
    }

    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "pl_PL")
        outputFormatter.dateFormat = "d MMMM yyyy"

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }

        return dateString
    }

    private func formatDateWithTime(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "pl_PL")
        outputFormatter.dateFormat = "d MMMM yyyy"

        if let date = inputFormatter.date(from: dateString) {
            let formattedDate = outputFormatter.string(from: date)

            // Add simulated time for presentation
            let hour = Int.random(in: 8...17)
            let minute = Int.random(in: 0...59)
            return "\(formattedDate) | \(String(format: "%02d:%02d", hour, minute))"
        }

        return dateString
    }

    func makeLinksClickable(_ text: String) -> AttributedString {
        var attributedString = AttributedString(text)
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(
            in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        matches?.forEach { match in
            if let url = match.url,
                let range = Range(match.range, in: attributedString)
            {
                attributedString[range].link = url
            }
        }
        return attributedString
    }
}

#Preview("MessageDetailCardView") {
    let message = ConferenceMessageDetails(
        id:
            "eyJpZCI6MSwidG9rZW4iOiIxOHxQSDh3QThDdjZqcTNvbTVKUGo0YnNLcmhrUmZHVmdDQ0pTdDRCZkR5OWZiYTAyZDAifQ==",
        title: "Test 1",
        message:
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor i",
        publish_date: "2025-06-22",
        publish_time: "16:00:00",
        picture: "https://nncv2-dev.serwik.pl/images/th-4109958356.jpeg",
        event_id:
            "eyJpZCI6MSwidG9rZW4iOiIxOHxQSDh3QThDdjZqcTNvbTVKUGo0YnNLcmhrUmZHVmdDQ0pTdDRCZkR5OWZiYTAyZDAifQ==",
        material_id: nil,
        academy_material_id: nil,
        is_read: true
    )

    VStack {
        MessageDetailCardView(message: message)
    }
    .padding(20)
    .background(Color.novoNordiskBackgroundGrey)
}
