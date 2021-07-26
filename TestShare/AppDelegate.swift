//
//  AppDelegate.swift
//  TestShare
//
//  Created by Jean-Baptiste Revel on 06/01/2021.
//

import UIKit
import CoreData

@main
@available(iOS 13.0, *)

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
          if let scheme = url.scheme, scheme.caseInsensitiveCompare("ShareExtension") == .orderedSame, let page = url.host {
            var parameters: [String: String] = [:]
            URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                parameters[$0.name] = $0.value
            }

            
              for parameter in parameters where parameter.key.caseInsensitiveCompare("url") == .orderedSame {
                  UserDefaults().set(parameter.value, forKey: "incomingURL")
              }
          }

          return true
      }
    
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
//            if let scheme = url.scheme,
//                scheme.caseInsensitiveCompare("ShareExtension") == .orderedSame,
//                let page = url.host {
//
//                var parameters: [String: String] = [:]
//                URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
//                    parameters[$0.name] = $0.value
//                }
//
//                print("redirect(to: \(page), with: \(parameters))")
//            }
//
//            return true
//        }
    
    
    
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
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

    
    lazy var persistentContainer: NSPersistentContainer = {
           let container = NSCustomPersistentContainer(name: "PopDB")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()
    
    
//
//    lazy var persistentContainer: NSPersistentContainer = {
//           /*
//            The persistent container for the application. This implementation
//            creates and returns a container, having loaded the store for the
//            application to it. This property is optional since there are legitimate
//            error conditions that could cause the creation of the store to fail.
//            */
//           // Change from NSPersistentContainer to your custom class
//           let container = NSCustomPersistentContainer(name: "PopDB")
//
//
//
//
//                container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//                    if let error = error as NSError? {
//                        // Replace this implementation with code to handle the error appropriately.
//                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//
//                        /*
//                         Typical reasons for an error here include:
//                         * The parent directory does not exist, cannot be created, or disallows writing.
//                         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                         * The device is out of space.
//                         * The store could not be migrated to the current model version.
//                         Check the error message to determine what the actual problem was.
//                         */
//                        fatalError("Unresolved error \(error), \(error.userInfo)")
//                    }
//                })
//                return container
//            }()
//
//
//
//
//
//
    static var persistentContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    static var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

