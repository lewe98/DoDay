//
//  SceneDelegate.swift
//  iTask
//
//  Created by Julian Hermanspahn on 27.05.20.
//  Copyright © 2020 Julian Hermanspahn. All rights reserved.
//

import UIKit
import SwiftUI
import Firebase
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Get the managed object context from the shared persistent container.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Firebase
        FirebaseApp.configure()
        
        // Notifications
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound,. badge]) { (granted, error) in
            if granted {
                print("Notifications duerfen gesendet werden.")
            } else {
                print("Notifications wurden nicht erlaubt.")
            }
        }
        
        let einstellungen = Einstellungen()
        let coreDataFunctions = CoreDataFunctions()
        let firebaseFunctions = FirebaseFunctions(
            einstellungen: einstellungen,
            coreDataFunctions: coreDataFunctions)
       
    
        // hinzufügen von environmentObjects in der Root View (ContentView())
        let contentView = ContentView()
            .environment(\.managedObjectContext, context)
            .environmentObject(firebaseFunctions)
            .environmentObject(coreDataFunctions)

       // Check if registered
       let uuid = UIDevice.current.identifierForVendor?.uuidString
       firebaseFunctions.checkUUID(id: uuid!)
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            // contentView wird als rootView definiert
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

