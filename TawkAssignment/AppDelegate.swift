//
//  AppDelegate.swift
//  TawkAssignment
//
//  Created by Rajveer Kaur on 01/09/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    let handle = Handler()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        CoreDataStack.sharedInstance.applicationDocumentsDirectory()
        
        ///Network
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveConnection(_:)), name: .didReceiveConnection, object: nil)
        handle.start()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
}

extension AppDelegate {
    @objc func onDidReceiveConnection(_ notification:Notification) {
        // Do stuff
        if Utility.isInternetAvailable(){
             print("network available")
         }else{
             print("network is not available")
         }
    }
}
