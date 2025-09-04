// import Foundation
// #if canImport(UIKit)
// import UIKit
// #endif
// import OneSignalFramework
// import MagnusDomain

// /// Centralized OneSignal handling: foreground presentation & open actions
// enum OneSignalService {
//     /// Configure foreground display and opened handlers
//     static func configureHandlers() {
//         // When a notification arrives in foreground, decide whether to show it
//         OneSignal.Notifications.addForegroundLifecycleListener(OSNotificationForegroundLifecycleListener(willShow: { notification in
//             // To prevent displaying a notification, call notification.preventDefault()
//             // To display it, let the logic continue
//         }))

//         // Handle when the user opens a notification
//         OneSignal.Notifications.addClickListener({ event in
//             // Try to open deep link if present
//             if let urlString = event.notification.launchURL, let url = URL(string: urlString) {
//                 #if canImport(UIKit)
//                 DispatchQueue.main.async { UIApplication.shared.open(url) }
//                 #endif
//             }
//         })
//     }

//     // MARK: - Helper API

//     /// Assign external user id for targeting
//     static func setExternalUserId(_ id: String) {
//         OneSignal.login(id)
//     }

//     /// Remove previously set external user id
//     static func removeExternalUserId() {
//         OneSignal.logout()
//     }

//     /// Set tags for segmentation
//     static func setTags(_ tags: [String: String]) {
//         OneSignal.User.addTags(tags)
//     }

//     /// Remove one or more tags
//     static func removeTags(_ keys: [String]) {
//         OneSignal.User.removeTags(keys)
//     }
// }
