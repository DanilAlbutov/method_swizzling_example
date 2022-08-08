//
//  PushNotificationService.swift
//  MethodSwizzlingExample
//
//  Created by Данил Албутов on 08.08.2022.
//

import Foundation
import NotificationCenter
protocol PushNotificationServiceDelegate {
    
}

class PushNotificationService {
    
    static let shared = PushNotificationService()
    
    var delegate: PushNotificationServiceDelegate?
    
    func configure() {
        swizzleWillPresentRemoteNotification()
    }
    
    private func swizzleWillPresentRemoteNotification() {
        guard let UnUserNotificationCenterClass = object_getClass(UNUserNotificationCenter.current().delegate) else { return }
        
        let originalObject = UNUserNotificationCenter.current().delegate
        
        let originalSelector = #selector(originalObject?.userNotificationCenter(_:willPresent:withCompletionHandler:))
        let swizzledSelector = #selector(PushNotificationService.customWillPresent(_:willPresent:withCompletionHandler:))
        
        guard let originalMethod = class_getInstanceMethod(UnUserNotificationCenterClass, originalSelector),
              let swizzledMethod = class_getInstanceMethod(PushNotificationService.self, swizzledSelector)
        else {
            return
        }
        
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    @objc func customWillPresent(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        customWillPresent(center, willPresent: notification, withCompletionHandler: completionHandler)
        
        print("willPresent() from Service")
        
        guard let text = notification.request.content.userInfo["userInfo"] else {
            return
        }
        
        let modifiedText = "modified: \(text)"
        
        print(modifiedText)
    }
    
}
