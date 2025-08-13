import SwiftUI
import MagnusApplication

struct EventStatusView: View {
    let date_from: String
    let date_to: String
    var status: DateHelper.DateStatus = .unknown

    init(date_from: String, date_to: String) {
        self.date_from = date_from
        self.date_to = date_to
        self.status = DateHelper.getDateStatus(from: date_from, to: date_to)
    }

    var body: some View {
        switch status {
            case .future:
            EmptyView()
            //EventSoonView()
            case .past:
                EmptyView()
                //EventFinishedView()
            case .between:
            EmptyView()
                //EventInProgressView()
            case .unknown:
                EmptyView()
        }
    }
}

#Preview("Future") {
    EventStatusView(date_from: "2025-08-16", date_to: "2025-08-17")
}

#Preview("Past") {
    EventStatusView(date_from: "2024-08-13", date_to: "2024-08-13")
}

#Preview("Between") {
    EventStatusView(date_from: "2025-08-11", date_to: "2025-08-14")
}
