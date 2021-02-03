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
                            
                            var imgData: UIImage?
                            if let someUrl = data as? URL {
                                do {
                                    imgData = UIImage(contentsOfFile: someUrl.path)
                                } catch {
                                    print(error)
                                }
                            }
                            
                         
                        var itemIdx = 0

                        // The app won't be able to access the images by path directly in the Camera Roll folder,
                        // so we temporary copy them to a folder which both the extension and the app can access:
                        let filePath = self.saveImage(toAppGroupFolder: imgData as? UIImage, imageIndex: itemIdx)

                        // Now add the path to the list of arguments we'll pass to the app:
                      //  self.addImagePath(toArgumentList: filePath)
                            let idUser = "testiud"
                            
                            let userUIDStorage = UserDefaults.standard.string(forKey: "userId")
                            let parameters : [String : String] = [
                                "idUser": userUIDStorage!,
                                /*"filename": filePath!*/]
                            
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

        func saveImage(
            toAppGroupFolder image: UIImage?,
            imageIndex: Int
        ) -> String? {
            assert(nil != image)

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


    func imageUploadRequest(uploadImage: UIImage?, param: [String:String]?) {

        //Send user data to server
        let url = URL(string: "http://www.popdb-france.fr/Include/DB_Upload.php")
        var request : URLRequest = URLRequest(url: url!)
        request.httpMethod = "POST"

        let boundary = generateBoundaryString()

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

      //  let imageData = uploadImage?.jpegData(compressionQuality: 1.0)
        
        
      //  if(imageData==nil)  { return; }

        request.httpBody = createBodyWithParameters(parameters : param, filePathKey: "file", imageDataKey: uploadImage as? UIImage, boundary: boundary) as Data

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

