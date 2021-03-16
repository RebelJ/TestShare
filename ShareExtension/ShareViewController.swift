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
//import TestShare



class ShareViewController: SLComposeServiceViewController {
    
    let m_inputItemCount = 0 // Keeps track of the number of attachments we have opened asynchronously.
    var m_invokeArgs: String? = nil // A string to be passed to your AIR app with information about the attachments.
    let APP_SHARE_GROUP = "group.POP.TestShare"
    let APP_SHARE_URL_SCHEME = "schemename"
//    let APP_SHARE_URL_SCHEME = "schemename"
//    let m_oldAlpha: CGFloat = 1.0 // Keeps the original transparency of the Post dialog for when we want to hide it.
    
    
    private let typeText = String(kUTTypeText)
    private let typeURL = String(kUTTypeURL)
    private var appURLString = "TestShare://home?url="
    private let groupName = "group.POP.TestShare"
    private let urlDefaultName = "incomingURL"
   // private var idImage = 0
    /*
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
        passSelectedItemsToApp();
        
        // Get the all encompasing object that holds whatever was shared. If not, dismiss view.
              guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
                  let itemProvider = extensionItem.attachments?.first else {
                      self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                      return
                    }
        
                     // Check if object is of type image/jpeg
                    if itemProvider.hasItemConformingToTypeIdentifier("public.jpeg") {
                         handleIncomingImage(itemProvider: itemProvider)
                     } else {
                         print("Error: No image found")
                         self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                     }
            
     }
    
    
        private func handleIncomingImage(itemProvider: NSItemProvider) {
            
            
            itemProvider.loadItem(forTypeIdentifier: "public.jpeg", options: nil) { (item, error) in
            if let error = error {
                print("URL-Error: \(error.localizedDescription)")
            }

            if let url = item as? NSURL, let urlString = url.absoluteString {
                self.saveURLString(urlString)
               //self.appURLString += urlString
            }

              self.openMainApp()
            }
        }
        private func openMainApp() {
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: { _ in
                guard let url = URL(string: self.appURLString) else { return }
                _ = self.openImage(url)
            })
        }
    
    
        private func saveURLString(_ urlString: String) {
            UserDefaults(suiteName: self.groupName)?.set(urlString, forKey: self.urlDefaultName)
        }
    
    
    */
    
    //  Function must be named exactly like this so a selector can be found by the compiler!
    //  Anyway - it's another selector in another instance that would be "performed" instead.
    @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
    
    

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        
                passSelectedItemsToApp();
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    
    
     private func passSelectedItemsToApp() {
        
        guard
          let items = extensionContext?.inputItems as? [NSExtensionItem],
          let itemAttachment = items.first,
          let attachments = itemAttachment.attachments
        else { return }
        
        var itemIdx = 0

        // Reset the counter and the argument list for invoking the app:
    //  m_invokeArgs = nil
  //    let m_inputItemCount = items.count
        // Iterate through the attached files
        for inputItem in attachments {
            // Check if we are sharing a Image
            if inputItem.hasItemConformingToTypeIdentifier("public.jpeg") {
                // Load it, so we can get the path to it
               inputItem.loadItem(forTypeIdentifier: "public.jpeg", options: nil,
                        completionHandler: { data, error in
                     
                        if nil != error {
                            if let error = error {
                                print("There was an error retrieving the attachments: \(error)")
                            }
                            return
                        }
                        var imgData: UIImage?
            
                        if let someUrl = data as? URL {
                            imgData = UIImage(contentsOfFile: someUrl.path)
                        } else if let someUrl = data as? NSData? {
                            imgData = UIImage(data: someUrl as! Data)
                        }
                        
                        
                        
                         //   let userUIDStorage = UserDefaults(suiteName: "group.POP.TestShare")
                           // if let Userid = userUIDStorage?.string(forKey: "userId") {
                               
                       
                            let Userid = "test"

                               
                                let parameters : [String : String] = [
                                    "idUser": Userid,
                                    /*"filename": filePath!*/]
            

                            self.imageUploadRequest(uploadImage: imgData as? UIImage, param : parameters)
                                                 
//                                let idStoreImage = UserDefaults.standard.integer(forKey: "idImage")
                        
                                
                          //      UserDefaults(suiteName: "group.POP.TestShare")?.removeObject(forKey: "userId")
                                
                          //  }
                            
                        // If we have reached the last attachment, it's time to hand control to the app:
                        itemIdx += 1
                            if itemIdx >= attachments.count {
                            print("done")
//                            self.invokeApp(self.m_invokeArgs)
                        }
                            //imgData = nil
                    })
            }
        }
        
       
     }
    /*
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }*/
    
    
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
        imageIndex: Int
    ) -> String? {
        assert(nil != image)
        
        let alertView = UIAlertController(title: "Export", message: " ", preferredStyle: .alert)
           

//       try! ImageStore.store(image: image!, name: "yes")
//      ImageStore.retrieve(imageNamed: "yes")
        
        let jpegData = image?.jpegData(compressionQuality: 1.0)

        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: APP_SHARE_GROUP)
        let documentsPath = containerURL?.path

        // Note that we aren't using massively unique names for the files in this example:
        let fileName = "image\(imageIndex).jpg"

        let filePath = URL(fileURLWithPath: documentsPath ?? "").appendingPathComponent(fileName).path
        if let jpegData = jpegData {
            NSData(data: jpegData).write(toFile: filePath, atomically: true)
        }
        
        
        UserDefaults.standard.set(filePath, forKey: "url");
        UserDefaults.standard.synchronize();
        

        // -- Store image url to NSUserDefaults
        // Boucle d'enregistrement image
        if let defaults = UserDefaults(suiteName: "group.POP.TestShare"){
            defaults.set(filePath as? String, forKey: "url")
            defaults.synchronize()
        }
        
        
        //CoreData storage
        let persistentContainer = NSPersistentContainer(name: "Collect")
        let storeURL = URL.storeURL(for: "group.POP.TestShare", databaseName: "Fleur")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        persistentContainer.persistentStoreDescriptions = [storeDescription]
        
       
       
        
//        do {
//                       let jsonData : Data = try JSONSerialization.data(
//                           withJSONObject: [
//                               "action" : "incoming-files"
//                               ],
//                           options: JSONSerialization.WritingOptions.init(rawValue: 0))
//                       let jsonString = (NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                       let result = self.openURL(URL(string: "TestShare://POP.TestShare?\(jsonString!)")!)
//                   } catch {
//                       alertView.message = "Error: \(error.localizedDescription)"
//                   }

        return filePath
    
        }


    func imageUploadRequest(uploadImage: UIImage?, param: [String:String]?) {

        //Send user data to server
        let url = URL(string: "http://www.popdb-france.fr/Include/DB_Upload.php")
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "POST"

        let boundary = generateBoundaryString()

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

      //  let imageData = uploadImage?.jpegData(compressionQuality: 1.0)
        
        
      //  if(imageData==nil)  { return; }
        

        request.httpBody = createBodyWithParameters(parameters : param, filePathKey: "test", imageDataKey: uploadImage as? UIImage, boundary: boundary) as Data

        //myActivityIndicator.startAnimating();

        let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                    
                    if error != nil {
                        print("error=\(error)")
                        return
                    }
            do {
//                    // You can print out response object
//                    print("******* response = \(response!)")
//
//                    print(data!.count)
//                    // you can use data here
//
//                    // Print out reponse body
//                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//                    print("****** response data = \(responseString!)")

//                    let json =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
                    
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: [])as? NSDictionary{
                        print("json value \(jsonResult)")
                    
                    if let idImage = jsonResult["idImage"] as? Int{
                        print(idImage)
                        
//                        UserDefaults.standard.set(idImage, forKey: "idImage");
//                        UserDefaults.standard.synchronize();
                        
                        
                        // so we temporary copy them to a folder which both the extension and the app can access:
                        let filePath = self.saveImage(toAppGroupFolder: uploadImage as? UIImage, imageIndex: idImage)
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

    
           
   /* func invokeApp(_ invokeArgs: String?) {
        // Prepare the URL request
        // this will use the custom url scheme of your app
        // and the paths to the photos you want to share:
        let urlString = "\(APP_SHARE_URL_SCHEME)://\((nil == invokeArgs ? "" : invokeArgs) ?? "")"
        let url = URL(string: urlString)

        let className = "UIApplication"
        if NSClassFromString(className) != nil {
           let object = NSClassFromString(className)?.perform(#selector(UIApplication.shared))
             object?.perform(#selector(UIApplication.openURL(_:)), with: url)
        }

        // Now let the host app know we are done, so that it unblocks its UI:
        super.didSelectPost()
    }*/
    /*
            #if HIDE_POST_DIALOG
            func configurationItems() -> [Any]! {
                // Comment out this whole function if you want the Post dialog to show.
                passSelectedItemsToApp()

                // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
                return []
            }

            #endif
            
           
            
            
            #ifdef HIDE_POST_DIALOG
            - ( void ) willMoveToParentViewController: ( UIViewController * ) parent
            {
                // This is called at the point where the Post dialog is about to be shown.
                // Make it transparent, so we don't see it, but first remember how transparent it was originally:

                m_oldAlpha = [ self.view alpha ];
                [ self.view setAlpha: 0.0 ];
            }
            #endif

            #ifdef HIDE_POST_DIALOG
            - ( void ) didMoveToParentViewController: ( UIViewController * ) parent
            {
                // Restore the original transparency:
                [ self.view setAlpha: m_oldAlpha ];
            }
            #endif
            #ifdef HIDE_POST_DIALOG
            - ( id ) init
            {
                if ( self = [ super init ] )
                {
                    // Subscribe to the notification which will tell us when the keyboard is about to pop up:
                    [ [ NSNotificationCenter defaultCenter ] addObserver: self selector: @selector( keyboardWillShow: ) name: UIKeyboardWillShowNotification    object: nil ];
                }

                return self;
            }
            #endif
            #ifdef HIDE_POST_DIALOG
            - ( void ) keyboardWillShow: ( NSNotification * ) note
            {
                // Dismiss the keyboard before it has had a chance to show up:
                [ self.view endEditing: true ];
            }
            #endif
            @end
        */
        

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

