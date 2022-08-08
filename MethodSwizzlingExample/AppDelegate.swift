//
//  AppDelegate.swift
//  MethodSwizzlingExample
//
//  Created by Данил Албутов on 08.08.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {        
        configureRemoteNotifications(application: application)
        PushNotificationService.shared.configure()
        return true
    }
    
    private func configureRemoteNotifications(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: authOptions) { _, _ in
            }
        
        application.registerForRemoteNotifications()
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        print("willpresent() from AppDelegate")
        
        guard let text = notification.request.content.userInfo["userInfo"] else {
            return
        }
        
        print(text)
        
        completionHandler([.banner, .badge, .sound])
    }
    
}

