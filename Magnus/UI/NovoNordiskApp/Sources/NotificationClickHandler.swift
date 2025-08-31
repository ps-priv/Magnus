import OneSignalFramework
import Foundation

public class NotificationClickHandler: NSObject, OSNotificationClickListener {
    public func onClick(event: OSNotificationClickEvent) {
        print("[OneSignal] Notification clicked: \(event.notification)")

        if let additionalData = event.notification.additionalData {
            print("[OneSignal] Additional data: \(additionalData)")
            
            for (key, value) in additionalData {
                print("[OneSignal] Key: \(key), Value: \(value)")
                PushNotificationKeyNavigation().performCheck(t: key as! String, value: value as! String)
                break
            }
        }
    }
}
