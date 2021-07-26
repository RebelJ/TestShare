//
//  NSCustomPersistentContainer.swift
//  TestShare
//
//  Created by Jean-Baptiste Revel on 18/03/2021.
//

import Foundation
import CoreData

class NSCustomPersistentContainer: NSPersistentContainer {
    
    override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.POP.TestShare")
        storeURL = storeURL?.appendingPathComponent("PopDB.sqlite")
        return storeURL!
    }

}

extension NSPersistentContainer {
    // Configure change event handling from external processes.
    func observeAppExtensionDataChanges() {
        DarwinNotificationCenter.shared.addObserver(self, for: .didSaveManagedObjectContextLocally, using: { [weak self] (_) in
            // Since the viewContext is our root context that's directly connected to the persistent store, we need to update our viewContext.
            self?.viewContext.perform {
                self?.viewContextDidSaveLocally()
            }
        })
    }
}

extension NSPersistentContainer {
    /// Called when a certain managed object context has been saved from an external process. It should also be called on the context's queue.
    func viewContextDidSaveLocally() {
        // `refreshAllObjects` only refreshes objects from which the cache is invalid. With a staleness intervall of -1 the cache never invalidates.
        // We set the `stalenessInterval` to 0 to make sure that changes in the app extension get processed correctly.
        viewContext.stalenessInterval = 0
        viewContext.refreshAllObjects()
        viewContext.stalenessInterval = -1
    }
}
