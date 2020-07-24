//
//MARK:  AppDelegate.swift
//  NatureAlarmClock
//
//  Created by Владислав on 20.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import YandexMobileMetrica

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    //MARK:- Did Finish Launching With Options
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { granted, error in
//            if !granted {
//                print("not granted")
//            }
//        })
        
        // Initializing the AppMetrica SDK.
        let configuration = YMMYandexMetricaConfiguration.init(apiKey: "b9af720f-2fbe-4527-bb28-27454f8c1095")
        YMMYandexMetrica.activate(with: configuration!)
        
        let savedSleepAlarm = SavedAlarms.general.getAlarm(.sleep)
        let savedWakeAlarm = SavedAlarms.general.getAlarm(.wakeUp)
        print(savedWakeAlarm)
        Globals.sleepAlarm = CurrentAlarm(savedSleepAlarm)
        Globals.sleepAlarm.isSwitchedOn = false
        Globals.wakeUpAlarm = CurrentAlarm(savedWakeAlarm)
        
//        Globals.alarms[.sleep] = CurrentAlarm(savedSleepAlarm)
//        Globals.alarms[.wakeUp] = CurrentAlarm(savedWakeAlarm)
        
        return true
    }
        
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Application did enter background. Saving Alarms Data...")
        SavedAlarms.general.saveAlarm(.sleep, alarm: Globals.alarm(.sleep).savedAlarm)
        SavedAlarms.general.saveAlarm(.wakeUp, alarm: Globals.alarm(.wakeUp).savedAlarm)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("App will terminate. Saving Alarms Data")
        SavedAlarms.general.saveAlarm(.sleep, alarm: Globals.alarm(.sleep).savedAlarm)
        SavedAlarms.general.saveAlarm(.wakeUp, alarm: Globals.alarm(.wakeUp).savedAlarm)
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "NatureAlarmClock")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


//MARK:- User Notifications Delegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let id = response.notification.request.identifier
        print("Received notification with ID = \(id)")
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let id = notification.request.identifier
        print("Received notification with ID = \(id)")
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()

        completionHandler([.sound, .alert])
    }
}
