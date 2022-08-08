//
//  PushNotificationService.swift
//  MethodSwizzlingExample
//
//  Created by Данил Албутов on 08.08.2022.
//

import Foundation
import NotificationCenter

typealias OriginalImplementationMethodType = @convention(c) (AnyObject, Selector, UNUserNotificationCenter, UNNotification, @escaping (UNNotificationPresentationOptions) -> Void) -> Void

class PushNotificationService {
    
    static let shared = PushNotificationService()
    static var originalMethodImplementation: OriginalImplementationMethodType?
    
    func configure() {
        swizzleWillPresentRemoteNotification()
    }
    
    @objc dynamic func customWillPresent(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        PushNotificationService.callOriginalMethod(center,
                                                   willPresent: notification,
                                                   withCompletionHandler: completionHandler)
        
        print("willPresent() from Service")
        
        guard let text = notification.request.content.userInfo["userInfo"] else {
            return
        }
        
        let modifiedText = "modified: \(text)"
        
        print(modifiedText)
    }
    
    class func callOriginalMethod(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification,
                                  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard let UnUserNotificationCenterClass = object_getClass(UNUserNotificationCenter.current().delegate) else {
            return
        }
        
        let originalSelector = #selector(
            UNUserNotificationCenter.current().delegate?.userNotificationCenter(_:willPresent:withCompletionHandler:)
        )
        
        if let originalMethod = PushNotificationService.originalMethodImplementation {
            originalMethod(UnUserNotificationCenterClass, originalSelector, center, notification, completionHandler)
        }
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
        
        saveMethod(method: originalMethod)
                
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
    private func saveMethod(method: Method) {
        let originalImplementation = method_getImplementation(method)
        
        guard let originalMethodImplementation = unsafeBitCast(
            originalImplementation,
            to: OriginalImplementationMethodType?.self
        ) else { return }
        
        PushNotificationService.originalMethodImplementation = originalMethodImplementation
    }
    
}
