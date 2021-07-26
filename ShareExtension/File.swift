
//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Jean-Baptiste Revel on 06/01/2021.
//

import UIKit
import Social
import MobileCoreServices
import CoreData
import Foundation



class ShareViewController: SLComposeServiceViewController {
    
    let m_inputItemCount = 0 // Keeps track of the number of attachments we have opened asynchronously.
    var m_invokeArgs: String? = nil // A string to be passed to your AIR app with information about the attachments.
    let APP_SHARE_GROUP = "group.POP.TestShare"
    let APP_SHARE_URL_SCHEME = "schemename"

    
    private let typeText = String(kUTTypeText)
    private let typeURL = String(kUTTypeURL)
    private var appURLString = "TestShare://home?url="
    private let groupName = "group.POP.TestShare"
    private let urlDefaultName = "incomingURL"
    
    var idUser: String? = nil

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
  
                passSelectedItemsToApp();
  
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    private func passSelectedItemsToApp() {
       
       guard
         let items = extensionContext?.inputItems as? [NSExtensionItem],
         let itemAttachment = items.first,
         let attachments = itemAttachment.attachments
       else { return }
       
       var itemIdx = 0

       // Iterate through the attached files
       for inputItem in attachments {
           // Check if we are sharing a Image
           if inputItem.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
               // Load it, so we can get the path to it
               inputItem.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil,
                                 completionHandler: { [self] data, error in
                    
                       if nil != error {
                           if let error = error {
                               print("There was an error retrieving the attachments: \(error)")
                           }
                           return
                       }
                                   
                                   
                       var imgData: UIImage?
                       var url : String = ""
               
                           //retourne nil
                       if let someUrl = data as? URL  {
                           url = someUrl.path
                           imgData = UIImage(contentsOfFile: url)
                       }

                   })
           }
       }

    }

}
