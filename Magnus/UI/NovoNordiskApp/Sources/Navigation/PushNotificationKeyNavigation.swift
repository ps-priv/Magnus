import Foundation
import SwiftUI


public struct PushNotificationKeyNavigation {
    private let navigationManager = NavigationManager.shared
    
    public func performCheck(key: String, value: String) {
        print("[PushNotificationKeyNavigation] - Uruchomienie performCheck")
        print("[PushNotificationKeyNavigation] - Key: \(key), Value: \(value)")
        print("[PushNotificationKeyNavigation] - NavigationManager: \(navigationManager)")

        DispatchQueue.main.async {
            if key == "msg" && value == "0" {
                //nawigacja do .messages
                navigationManager.navigateToMessagesList()
            }

            if key == "msg" && value != "0" {
                //nawigacja do .messageDetail
                navigationManager.navigateToMessageDetail(messageId: value)
            }

            if key == "mtr_n" && value == "0" {
                //otwiera materialy i rozwija menu z materialami
                navigationManager.navigateToMaterials()
            }

            if key == "mtr" && value == "0" {
                //otwiera liste z materialami
                navigationManager.navigateToMaterials()
            }

            if key == "evn" && !value.isEmpty {
                //nawigacja do eventu, gdzie value to event id
                navigationManager.navigateToEventDetail(eventId: value)
            }
        }
    }
}