//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Jean-Baptiste Revel on 06/01/2021.
//

import UIKit
import Social
import MobileCoreServices



class ShareViewController: SLComposeServiceViewController {
    
    let m_inputItemCount = 0 // Keeps track of the number of attachments we have opened asynchronously.
    var m_invokeArgs: String? = nil // A string to be passed to your AIR app with information about the attachments.
    let APP_SHARE_GROUP = "group.POP.TestShare.ShareExtension"
    let APP_SHARE_URL_SCHEME = "schemename"
    let m_oldAlpha: CGFloat = 1.0 // Keeps the original transparency of the Post dialog for when we want to hide it.
    

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
        
        /*
        
        var imageFound = false
      //  for item: AnyObject in extensionContext?.inputItems {
            let item = extensionContext?.inputItems as? [NSExtensionItem]
            let inputItem = item as! NSExtensionItem
            for provider: AnyObject in inputItem.attachments! {
                let itemProvider = provider as! NSItemProvider
                if itemProvider.hasItemConformingToTypeIdentifier("public.jpeg") {
                    // This is an image. We'll load it, then place it in our image view.
                    itemProvider.loadItem(forTypeIdentifier: "public.jpeg", options: nil, completionHandler: { (image, error) in
                        OperationQueue.main.addOperation {
                            
                            var imgData: Data!
                                                        if let url = item as? URL{
                                                            imgData = try! Data(contentsOf: url)
                                                        }


                        if let strongImageView = weakImageView {

                               if let imageURL = image as? NSURL{

                             strongImageView.image = UIImage(data:NSData(contentsOfURL: imageURL)!)

                                }else{

                                  strongImageView.image = image as? UIImage
                                }

                            }


                        }
                    })

                    imageFound = true
                    break
                }
            }

            if (imageFound) {
                // We only handle one image, so stop looking for more.
                break
            }
      //  }*/
        
        
        
        
        guard
          let items = extensionContext?.inputItems as? [NSExtensionItem],
          let itemAttachment = items.first,
          let attachments = itemAttachment.attachments
        else { return }

        // Reset the counter and the argument list for invoking the app:
      m_invokeArgs = nil
      let m_inputItemCount = items.count
        

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
                            
                         /*   var imgData: Data!
                            if let url = item as? URL{
                                let imgData = try! Data(contentsOf: url)
                            }
                            */
                            
                            var imgData: UIImage?
                            if let someUrl = data as? URL {
                                do {
                                  // a ends up being nil in both of these cases
                                    imgData = UIImage(contentsOfFile: someUrl.path)
                                //  let a = NSData(contentsOfFile: someUrl.absoluteString)
                                 //   imgData = UIImage(data: a as! Data)
                                  // let a = try Data(contentsOf: someUrl)
                                  // image = UIImage(contentsOfFile: someUrl.absoluteString)
                                } catch {
                                    print(error)
                                }
                            }
                            
                          /*  var image: UIImage?
                                   if item is NSURL {
                                    let im = item as! NSURL
                                    
                                    let dataim = try? UIImage(data: NSData(contentsOf: im as! URL) as Data)!
                                    //   let data = try? Data(contentsOf: item!)
                                       image = UIImage(data: dataim as! Data)!
                                   }
                            
                                   if let image = image {
                                       DispatchQueue.main.async {
                                           // image here
                                       }
                                   }
                            */
                        var itemIdx = 0

                        // The app won't be able to access the images by path directly in the Camera Roll folder,
                        // so we temporary copy them to a folder which both the extension and the app can access:
                        let filePath = self.saveImage(toAppGroupFolder: imgData as? UIImage, imageIndex: itemIdx)

                        // Now add the path to the list of arguments we'll pass to the app:
                      //  self.addImagePath(toArgumentList: filePath)
                            let iud = "testiud"
                            let parameters : [String : String] = [
                                "uid": iud,
                                "filename": filePath!]
                            
                        self.imageUploadRequest(uploadImage: imgData as? UIImage, param : parameters)
                            
                        // If we have reached the last attachment, it's time to hand control to the app:
                        itemIdx += 1
                        if itemIdx >= m_inputItemCount {
                          //  invokeApp(m_invokeArgs)
                        }
                            
                            
                    })
            }
        }
        
       
     }
    
    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
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
/*
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
*/
        func saveImage(
            toAppGroupFolder image: UIImage?,
            imageIndex: Int
        ) -> String? {
     //       assert(nil != image)

            let jpegData = image?.jpegData(compressionQuality: 1.0)

            let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: APP_SHARE_GROUP)
            let documentsPath = containerURL?.path

            // Note that we aren't using massively unique names for the files in this example:
            let fileName = "image\(imageIndex).jpg"

            let filePath = URL(fileURLWithPath: documentsPath ?? "").appendingPathComponent(fileName).path
            if let jpegData = jpegData {
                NSData(data: jpegData).write(toFile: filePath, atomically: true)
            }

            //Mahantesh -- Store image url to NSUserDefaults

            var defaults = UserDefaults(suiteName: "group.com.schemename.nameofyourshareappgroup")
            defaults?.set(filePath, forKey: "url")
            defaults?.synchronize()

            return filePath
        }

       
        func invokeApp(_ invokeArgs: String?) {
            // Prepare the URL request
            // this will use the custom url scheme of your app
            // and the paths to the photos you want to share:
            let urlString = "\(APP_SHARE_URL_SCHEME)://\((nil == invokeArgs ? "" : invokeArgs) ?? "")"
            let url = URL(string: urlString)

            let className = "UIApplication"
            if NSClassFromString(className) != nil {
               // let object = NSClassFromString(className)?.perform(#selector(UIApplication.shared))
               // object?.perform(#selector(UIApplication.openURL(_:)), with: url)
            }

            // Now let the host app know we are done, so that it unblocks its UI:
            super.didSelectPost()
        }
    
        #if HIDE_POST_DIALOG
        func configurationItems() -> [Any]! {
            // Comment out this whole function if you want the Post dialog to show.
            passSelectedItemsToApp()

            // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
            return []
        }

        #endif
        
        
     
        
        
        /*
        
        
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
    
    
    
    
    func imageUploadRequest(uploadImage: UIImage?, param: [String:String]?) {

        //Send user data to server
        let url = URL(string: "http://www.popdb-france.fr/Include/DB_Upload.php")
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "POST"

        let boundary = generateBoundaryString()

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let imageData = uploadImage?.jpegData(compressionQuality: 1.0)
        
        
      //  if(imageData==nil)  { return; }

        request.httpBody = createBodyWithParameters(parameters : param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data

        //myActivityIndicator.startAnimating();

        let task = URLSession.shared.dataTask(with: request) {
                (data, response, error) -> Void in
            do {
                
                if let data = data {

                    // You can print out response object
                    print("******* response = \(response!)")

                    print(data.count)
                    // you can use data here

                    // Print out reponse body
                    let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                    print("****** response data = \(responseString!)")

                    let json =  try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary

                    print("json value \(json)")

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
                
            } catch let error {
                   //Perform the error handling here
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
        print("task resume")


    }


    func createBodyWithParameters(parameters: [String: String]? , filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();

        
        let boundaryPrefix = "--\(boundary)\r\n"
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(boundaryPrefix)
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }

        let filename = "user-profile.jpg"

        let mimetype = "image/jpg"

        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString("\r\n")

        body.appendString(boundaryPrefix)

        return body
    }

    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

}

extension NSMutableData {

    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
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

