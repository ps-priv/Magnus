import Foundation
import SwiftUI


public struct PushNotificationKeyNavigation {
    @StateObject private var navigationManager = NavigationManager()
    
    public func performCheck(t  key: String, value: String) {

        print("[PushNotificationKeyNavigation] Key: \(key), Value: \(value)")

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

        if key == "even" && !value.isEmpty {
            //nawigacja do eventu, gdzie value to event id
            navigationManager.navigateToEventDetail(eventId: value)
        }
    }
}