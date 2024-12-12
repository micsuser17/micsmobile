//
//  MicsPushNotificationHandler.swift
//  LocalPushNotification
//
//  Created by mohan-13582 on 10/12/24.
//

import Foundation
import UIKit

public protocol MyPushNotificationSDKDelegate: AnyObject {
    func didReceiveDeepLink(_ url: URL)
}

class MicsPushNotificationHandler{

    var appID: String?

    public static let shared = MicsPushNotificationHandler()
    public weak var delegate: MyPushNotificationSDKDelegate?

    private init() {}

    public func initialize(appID: String) {
        print("MICSSDK initialized with App ID: \(appID)");
    }

    public func HandleNotificationReceive(_ userInfo: [AnyHashable: Any]) {
        print("Push notification received in sdk: \(userInfo)")
        //comes here while receiving mics push notification

    }

    public func HandleNotificationClick(_ userInfo: [AnyHashable: Any]) -> Bool {
        //comes here on-clicking the push notification
         print("Notification clicked and recived in SDK: \(userInfo)")
         let a = userInfo["custom-data"]
        print("custom data : \(a)")
        
        // Extract data from the notification payload
        if let deepLink = userInfo["deep_link"] as? String, let url = URL(string: deepLink) {
             if let delegate = delegate {
                // Notify delegate if it exists
                delegate.didReceiveDeepLink(url)
            } else {
                // Default behavior
                openDeepLink(deepLink)
            }
        } else if let actionUrl = userInfo["action_url"] as? String, let url = URL(string: actionUrl) {
            // Open the web URL as a fallback
            UIApplication.shared.open(url)
        } else {
            print("No links found in notification payload.")
        }
        return true
    }
    // Open a deep link URL
    func openDeepLink(_ urlString: String) {
        // Convert the string to a URL
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            print("Invalid URL string.")
            return
        }

        // Check if the URL can be opened
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { success in
                    if success {
                        print("Deep link successfully opened.")
                    } else {
                        print("Failed to open deep link.")
                    }
                }
            } else {
                print("Cannot open the deep link. Ensure the URL is supported and valid.")
            }
    }


    public func HandleNotificationCTAClick() {
        //comes here on-clicking the push notification
    }


}

extension AppDelegate: MyPushNotificationSDKDelegate {
    func didReceiveDeepLink(_ url: URL) {
        print("Deep link received: \(url)")
        
        // Example: Navigate to a specific screen
        //navigateToDeepLink(url)
    }
}

