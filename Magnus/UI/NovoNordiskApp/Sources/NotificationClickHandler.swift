import OneSignalFramework
import Foundation

public class NotificationClickHandler: NSObject, OSNotificationClickListener {
    public func onClick(event: OSNotificationClickEvent) {
        // Handle the notification click event here.
        // For example, you can print the notification content:
        print("[OneSignal] Notification clicked: \(event.notification)")

        // Extract additional data from the notification
        if let additionalData = event.notification.additionalData {
            print("[OneSignal] Additional data: \(additionalData)")
            
            // Handle specific data keys
            for (key, value) in additionalData {
                print("[OneSignal] Key: \(key), Value: \(value)")
            }
        }
        
        // // Extract action buttons if any
        if let actionButtons = event.notification.actionButtons {
            for button in actionButtons {
                print("Action button: \(button.id) - \(button.text )")
            }
        }

    }
}
