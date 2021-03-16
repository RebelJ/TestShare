//
//  RegisterPageViewController.swift
//  TestShare
//
//  Created by Jean-Baptiste Revel on 25/01/2021.
//

import Foundation
import UIKit

class RegisterPageViewController: UIViewController {
   
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var userRepeatPasswordTextField: UITextField!
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    
    @IBOutlet weak var userFirstNameTextFiled: UITextField!
    
    @IBOutlet weak var userNameTextField: UITextField!
    
   
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    @IBAction func userRegisteredButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }

    @IBAction func registerButtonTapped(_ sender: AnyObject) {
        
        
        let resultValue="";
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        let userRepeatPassword = userRepeatPasswordTextField.text;
        
        let userFirstName = userFirstNameTextFiled.text;
        let userName = userNameTextField.text;
     
        
        
        if((userPassword ?? "").isEmpty ||  (userRepeatPassword ?? "").isEmpty ||  (userEmail ?? "").isEmpty ||  (userFirstName ?? "").isEmpty ||  (userName ?? "").isEmpty){
            displayMyAlertMessage(userMessage: "All Field are required");
            return;
            
        }
        
        
        if (userPassword != userRepeatPassword){
            displayMyAlertMessage(userMessage: "Password do not match");
            return;
            
        }
        
        
        //Send user data to server
        let url = URL(string: "http://www.popdb-france.fr/register.php")
        var request : URLRequest = URLRequest(url: url!)
        
        
            let parameters : [String : String] = [
                "firstName" : userFirstName!,
                "name" : userName!,
                "email": userEmail!,
                "password": userPassword!,
                
            ]
        
     
        request.httpMethod = "POST";
        request.httpBody = parameters.percentEncoded()
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
        
            
            do {
                if let jsonResultReg = try JSONSerialization.jsonObject(with: data!, options: [])as? NSDictionary{
                    print(jsonResultReg)
                    
                    if let personDictionary = jsonResultReg as? NSDictionary{
                
                        let error = personDictionary["error"] as? Bool;
                        let uid = personDictionary["uid"] as? String;
                        let error_msg = personDictionary["error_msg"];
            
//                        print(error!);
                     //   print(uid!);
                        
                        var isUserRegistered:Bool = false;
                        var titleToDisplay = "Well Done"
                        var messageToDisplay = "Registration is successful, Thanks you" ;
                        
                        
                        if(error == false){
                            isUserRegistered = true;
                        }
                        
                        
                        if(!isUserRegistered)
                        {
                            messageToDisplay = error_msg as! String;
                            titleToDisplay = "Warning"
                            
                            
                        }
                        
                        DispatchQueue.global(qos: .background).async {
                            // Background Thread
                            DispatchQueue.main.async {
                    
                                    // Run UI Updates
                                    let myAlert = UIAlertController(title: titleToDisplay,message: messageToDisplay as? String, preferredStyle: UIAlertController.Style.alert);
                                    
                                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){ action in
                                        if(isUserRegistered){ self.dismiss(animated: true, completion: nil);}
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
        
    }
    
    
    func displayMyAlertMessage(userMessage: String )
    {
        var  myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertController.Style.alert);
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated:true, completion:nil);
        
        
    }

}
