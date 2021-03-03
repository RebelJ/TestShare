//
//  LoginViewController.swift
//  TestShare
//
//  Created by Jean-Baptiste Revel on 25/01/2021.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginButtonTapped(_ sender: AnyObject) {
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        
        let resultValue="";
        
      
        if((userPassword ?? "").isEmpty ||  (userEmail ?? "").isEmpty){return;}


        //Send user data to server
        let url = URL(string: "http://www.popdb-france.fr/login.php")
        var request : URLRequest = URLRequest(url: url!)
       
        let parameters : [String : String] = [
            "email": userEmail!,
            "password": userPassword!]
        
        
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
                        
                           if(error == false)
                           {
                            if let userId = jsonResult["uid"] as? String{
                                print(userId)
                                //login successful
                                UserDefaults.standard.set(true, forKey: "isUserLoggedIn");
                                UserDefaults.standard.set(userId, forKey: "userId");
                                UserDefaults.standard.synchronize();
                                
                             //   let userStorage = UserDefaults.standard.string(forKey: "userId")
                                DispatchQueue.main.async{
                                    self.dismiss(animated: true, completion: nil);
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
        
        
        
        
        
        
        
       /* let userEmailStored = UserDefaults.standard.string(forKey: "userEmail");
        let userPasswordStored = UserDefaults.standard.string(forKey: "userPassword");
        
        if(userEmailStored == userEmail)
        {
            if(userPasswordStored == userPassword)
            {
                //login successful
                UserDefaults.standard.set(true, forKey: "isUserLoggedin");
                UserDefaults.standard.synchronize();
                self.dismiss(animated: true, completion: nil);
            }
        }
        
        */
        
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
