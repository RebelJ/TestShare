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
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        
        
        guard
          let items = extensionContext?.inputItems as? [NSExtensionItem],
          let itemAttachment = items.first,
          let attachments = itemAttachment.attachments
        else { return }
        
      //  var itemIdx = 0

        // Reset the counter and the argument list for invoking the app:
    //  m_invokeArgs = nil
  //    let m_inputItemCount = items.count
        // Iterate through the attached files
        for inputItem in attachments {
            // Check if we are sharing a Image
            if inputItem.hasItemConformingToTypeIdentifier(kUTTypeJPEG as String) {
                // Load it, so we can get the path to it
                inputItem.loadItem(forTypeIdentifier: kUTTypeJPEG as String, options: nil,
                                   completionHandler: { [self] url, error in
                     
                        if nil != error {
                            if let error = error {
                                print("There was an error retrieving the attachments: \(error)")
                            }
                            return
                        }
                            passSelectedItemsToApp(data : url as! URL);
                                    
                            // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
                           
                                    self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        
                            });
               
        
            }/*else if inputItem.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                // Load it, so we can get the path to it
                inputItem.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil,
                                   completionHandler: { [self] url, error in
                     
                        if nil != error {
                            if let error = error {
                                print("There was an error retrieving the attachments: \(error)")
                            }
                            return
                        }
                            passSelectedItemsToApp(data : url as! URL);
                                    
                            // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
                           
                                    self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        
                            });
               
        
            }else if inputItem.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
                // Load it, so we can get the path to it
                inputItem.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil,
                                   completionHandler: { [self] url, error in
                     
                        if nil != error {
                            if let error = error {
                                print("There was an error retrieving the attachments: \(error)")
                            }
                            return
                        }
                            passSelectedItemsToApp(data : url as! URL);
                                    
                            // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
                           
                                    self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        
                            });
               
        
            }*/
        }
         
    }
            
    
           func passSelectedItemsToApp(data: URL) {
 
                    
            var imgData: UIImage?
            var url : String = ""
    
        
            url = data.path
            imgData = UIImage(contentsOfFile: url)
                    
        
                //UserID from local storage
                idUser =   UserDefaults.standard.string(forKey: "userId");
                if  (idUser == nil){
                    let incomingUser = UserDefaults(suiteName: "group.POP.TestShare")
                    idUser = incomingUser!.string(forKey: "userId");
                    if(idUser == nil) {
                        let managedContext = self.persistentContainer.viewContext
                        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
                            fetch.predicate = nil
                            do {
                              let result = try managedContext.fetch(fetch)
                              for data in result as! [NSManagedObject] {
                                idUser  = data.value(forKey: "id") as! String
                              }
                            } catch {
                              print("Failed")
                            }
                    }
                }
                    
                    print (idUser)
                    
                            if (idUser == nil){
                                
                                DispatchQueue.main.async {
                                    self.showToast(message: "Connectez-vous pour utiliser POP");
                                    }
                                    
                              
                                
                       
                    }

                               
                    let parameters : [String : String] = [
                        "idUser": idUser!,
                        /*"filename": filePath!*/]


                self.imageUploadRequest(uploadImage: imgData as? UIImage, param : parameters, path: url)
                       
        
       
     }
    
    
    func addImagePath(toArgumentList imagePath: String?) {
        assert(nil != imagePath)

        // The list of arguments we will pass to the AIR app when we invoke it.
        // It will be a comma-separated list of file paths: /path/to/image1.jpg,/path/to/image2.jpg
        if nil == m_invokeArgs {
            m_invokeArgs = imagePath
        } else {
            m_invokeArgs = "\(m_invokeArgs),\(imagePath ?? "")"
        }
    }
    
    

    func saveImage(
        toAppGroupFolder image: UIImage?,
        imageIndex: Int,
        pathIm: String
    ) -> String? {
        assert(nil != image)
        
        let alertView = UIAlertController(title: "Export", message: " ", preferredStyle: .alert)
           
        
        let jpegData = image?.jpegData(compressionQuality: 1.0)

        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: APP_SHARE_GROUP)
        let documentsPath = containerURL?.path

        // Note that we aren't using massively unique names for the files in this example:
        let fileName = "image\(imageIndex).jpg"

        let filePath = URL(fileURLWithPath: documentsPath ?? "").appendingPathComponent(fileName).path
        if let jpegData = jpegData {
            NSData(data: jpegData).write(toFile: filePath, atomically: true)
        }
        
        
        
        let managedContext = persistentContainer.viewContext
        
        //Store objet image
        let imageStore: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "Image", into: managedContext)
        imageStore.setValue(imageIndex, forKey: "id")
        imageStore.setValue(jpegData, forKey: "url")
        
        do {
           try managedContext.save()
            
            DispatchQueue.main.async {
                
                self.showToast(message: "Image enregistrée")
            }
            
          } catch {
            
            DispatchQueue.main.async {
                self.showToast(message: "Erreur contactez le développeur")
            }
            
            
        }
        
        
        let managedContext2 = persistentContainer.viewContext
        var tables :[Int] = []
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
//            let predicate = NSPredicate(format: "id = %d", 131) // Specify your condition here
        // Or for integer value
        // let predicate = NSPredicate(format: "age > %d", argumentArray: [10])
            fetch.predicate = nil
            do {
              let result = try managedContext2.fetch(fetch)
              for data in result as! [NSManagedObject] {
                let idImage = data.value(forKey: "id") as! Int
                tables.append(idImage)
                if tables.count == 24
                {
                    imageUploadPellicule(table : tables, userId: idUser)
                }
               
              
              }
            } catch {
              print("Failed")
            }

        return filePath
    
        }


    func imageUploadRequest(uploadImage: UIImage?, param: [String:String]?, path : String) {

        //Send user data to server
        let url = URL(string: "http://www.popdb-france.fr/Include/DB_Upload.php")
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "POST"

        let boundary = generateBoundaryString()

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")


        request.httpBody = createBodyWithParameters(parameters : param, filePathKey: "test", imageDataKey: uploadImage as? UIImage, boundary: boundary) as Data

        //myActivityIndicator.startAnimating();

        let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                    
                    if error != nil {
                        print("error=\(error)")
                        return
                    }
            do {
                    
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: [])as? NSDictionary{
                        print("json value \(jsonResult)")
                        
                       
                    
                    if let idImage = jsonResult["idImage"] as? Int{
                        print(idImage)
                        
                        
                        
                        // so we temporary copy them to a folder which both the extension and the app can access:
                        let filePath = self.saveImage(toAppGroupFolder: uploadImage as? UIImage, imageIndex: idImage, pathIm : path)
                        self.addImagePath(toArgumentList: filePath)

                    

                    //var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err)

                    DispatchQueue.global(qos: .background).async {
                        // Background Thread
                        DispatchQueue.main.async {
                            // Run UI Updates
                            var myAlert = UIAlertController(title:"Alert",message: "oyoyoyooy" as? String, preferredStyle: UIAlertController.Style.alert);
                            let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default){ action in
                                self.dismiss(animated: true, completion: nil);
                            }
                            myAlert.addAction(okAction);
                            self.present(myAlert, animated: true, completion: nil);
                        }
                    } 

                    }

                }
            } catch let error {
                   //Perform the error handling here
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
        print("task resume")
        


    }


    func imageUploadPellicule(table: [Int]?,userId : String? ) {
    

        //Send user data to server
        let url = URL(string: "http://www.popdb-france.fr/Include/API_Fuji.php")
        var request : URLRequest = URLRequest(url: url!)
       
       
        
        let parameters : [String : String] = [
            "idUser": userId!,
            "table": "\(table!)"]
        
        
        request.httpMethod = "POST";
        request.httpBody = parameters.percentEncoded()
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: [])as? NSDictionary{
                    
                    
                    print(jsonResult)
                     
                    if let personDictionary = jsonResult as? NSDictionary{
                
                            let error = personDictionary["error"] as? Bool;
                            print(error!);
                            let error_msg = personDictionary["error_msg"];
                        
                           if(error == false)
                           {
                            
                            
                            if let userId = jsonResult["uid"] as? String{
                                print(userId)
                    
                                DispatchQueue.main.async{
                                    self.dismiss(animated: true, completion: nil);
                                }
                         
                            
                           }
                    }
                     else if (error != false){
                        
                        let msg = personDictionary["msg"];
                        
                        DispatchQueue.main.async {
                            self.showToast(message: "En impression \(msg)")
                        }
                        
                       
                        
                        DispatchQueue.global(qos: .background).async {
                            // Background Thread
                            DispatchQueue.main.async {
                    
                                    // Run UI Updates
                                    let myAlert = UIAlertController(title: "Alert",message: error_msg as? String, preferredStyle: UIAlertController.Style.alert);
                                    
                                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){ action in
//                                                self.dismiss(animated: true, completion: nil);
                                    }
                                 myAlert.addAction(okAction);
                                    self.present(myAlert, animated: true, completion: nil);
                            }
                        }
                        
                    }
                }
                }
               
            } catch let error {
                   //Perform the error handling here
                print("Failed to load: \(error.localizedDescription)")
                
                
            }
            

        }
        task.resume()
    }
    
    
    
    
    
    
    func createBodyWithParameters(parameters: [String: String]? , filePathKey: String?, imageDataKey: UIImage?, boundary: String) -> NSData {
        let body = NSMutableData();

        
        let boundaryPrefix = "--\(boundary)\r\n"
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }

        let contentType = "image/jpg"

        let imageData = imageDataKey?.jpegData(compressionQuality: 1)
        
         
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"filename\" ; filename=\"\(filePathKey)\"\r\n")
        body.appendString("Content-Type: \(contentType)\r\n\r\n")
        body.append(imageData!)
        body.appendString("\r\n")

        body.appendString(boundaryPrefix)

        return body
    }

    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    

    func addImagePath(ToArgumentList imagePath: NSString?)
    {
        assert( nil != imagePath );

        // The list of arguments we will pass to the AIR app when we invoke it.
        // It will be a comma-separated list of file paths: /path/to/image1.jpg,/path/to/image2.jpg
        if ( nil == m_invokeArgs)
        {
            m_invokeArgs = imagePath as String?;
        }
        else
        {
            m_invokeArgs = NSString(format: "%,@%@,%@", m_invokeArgs as! CVarArg, imagePath as! CVarArg) as String ;
        }
    }

    
    // MARK: - Core Data stack
        lazy var persistentContainer: NSPersistentContainer = {
            /*
             The persistent container for the application. This implementation
             creates and returns a container, having loaded the store for the
             application to it. This property is optional since there are legitimate
             error conditions that could cause the creation of the store to fail.
             */
            let container = NSCustomPersistentContainer(name: "PopDB")
            
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

        func someOtherFunction() {
          // get the managed context
          let managedContext = self.persistentContainer.viewContext
          // have fun
        }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 7.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }


        

}


extension NSPersistentContainer {
    // Configure change event handling from external processes.
    func observeAppExtensionDataChanges() {
        DarwinNotificationCenter.shared.addObserver(self, for: .didSaveManagedObjectContextExternally, using: { [weak self] (_) in
            // Since the viewContext is our root context that's directly connected to the persistent store, we need to update our viewContext.
            self?.viewContext.perform {
                self?.viewContextDidSaveExternally()
            }
        })
    }
}

extension NSPersistentContainer {
    /// Called when a certain managed object context has been saved from an external process. It should also be called on the context's queue.
    func viewContextDidSaveExternally() {
        // `refreshAllObjects` only refreshes objects from which the cache is invalid. With a staleness intervall of -1 the cache never invalidates.
        // We set the `stalenessInterval` to 0 to make sure that changes in the app extension get processed correctly.
        viewContext.stalenessInterval = 0
        viewContext.refreshAllObjects()
        viewContext.stalenessInterval = -1
    }
}



extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
    
}
extension NSMutableData {

         func appendString(_ string: String) {

            if let data = string.data(using: .utf8) {
                append(data)
            }
        }
}


public extension URL {

    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}


extension DarwinNotification.Name {
    private static let appIsExtension = Bundle.main.bundlePath.hasSuffix(".appex")

    /// The relevant DarwinNotification name to observe when the managed object context has been saved in an external process.
    static var didSaveManagedObjectContextExternally: DarwinNotification.Name {
        if appIsExtension {
            return appDidSaveManagedObjectContext
        } else {
            return extensionDidSaveManagedObjectContext
        }
    }

    /// The notification to post when a managed object context has been saved and stored to the persistent store.
    static var didSaveManagedObjectContextLocally: DarwinNotification.Name {
        if appIsExtension {
            return extensionDidSaveManagedObjectContext
        } else {
            return appDidSaveManagedObjectContext
        }
    }

    /// Notification to be posted when the shared Core Data database has been saved to disk from an extension. Posting this notification between processes can help us fetching new changes when needed.
    private static var extensionDidSaveManagedObjectContext: DarwinNotification.Name {
        return DarwinNotification.Name("group.POP.TestShare.extension-did-save")
    }

    /// Notification to be posted when the shared Core Data database has been saved to disk from the app. Posting this notification between processes can help us fetching new changes when needed.
    private static var appDidSaveManagedObjectContext: DarwinNotification.Name {
        return DarwinNotification.Name("group.POP.TestShare.app-did-save")
    }
}


