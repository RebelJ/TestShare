//
//  NSCustomPersistentContainer.swift
//  ShareExtension
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



