import SwiftUI
import Kingfisher
import MagnusApplication
import MagnusDomain

struct EventCardView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    let event: ConferenceEvent
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    // Image section - 60% of screen height
                    ZStack(alignment: .bottom) {
                        KFImage(URL(string: event.image))
                            .placeholder {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .overlay(
                                        VStack {
                                            ProgressView()
                                                .scaleEffect(1.2)
                                                .tint(.novoNordiskBlue)
                                            FAIcon(.calendar, type: .light, size: 18, color: .gray)
                                                .padding(.top, 8)
                                        }
                                    )
                            }
                            .resizable()
                            .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.6)
                        .clipped()
                        .overlay(
                            QrCodeButtonView(action: {
                                navigationManager.navigateToEventQrCode(event: event)
                            })
                            .padding(.top, 12)
                            .padding(.trailing, 12),
                            alignment: .topTrailing
                        )

                        HStack {
                            Spacer()
                            Button(action: {}) {
                                HStack {
                                    FAIcon(.circle_play, type: .light, size: 15, color: .novoNordiskOrangeRed)
                                    Text(LocalizedStrings.eventAvailableTransmission)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.black.opacity(0.4))
                                .cornerRadius(16)
                                .shadow(radius: 2)
                            }
                            Spacer()
                        }
                        .padding(.bottom, 12)
                    }

                    VStack(alignment: .leading) {
                        Text(event.name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.novoNordiskTextGrey)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 3)

                        HStack {
                            Text(PublishedDateHelper.formatDateRangeForEvent(event.date_from, event.date_to, LocalizedStrings.months, dateFormat: "yyyy-MM-dd"))
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.novoNordiskBlue)
                                .padding(.bottom, 3)

                            EventStatusView(date_from: event.date_from, date_to: event.date_to)
                            Spacer()

                            // if event.IsOnline {
                            //     EventInProgressView()
                            //     Spacer()
                            // }
                        }

                        Text(event.description)
                            .font(.body)
                            .foregroundColor(.novoNordiskTextGrey)


                        HStack {
                            EventSeatsInfoView(seats: event.seats)
                                .padding(.trailing, 10)
                            Spacer()
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .frame(maxHeight: .infinity)
    }
}