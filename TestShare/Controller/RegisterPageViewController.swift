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
    
    @IBOutlet weak var userNumeroTextField: UITextField!
    
    @IBOutlet weak var userAdressTextField: UITextField!
    
    @IBOutlet weak var userCodePostalTextField: UITextField!
    
    @IBOutlet weak var userPaysTextField: UITextField!
    
    @IBOutlet weak var userBatimentTextField: UITextField!
    
    @IBOutlet weak var userRegionTextField: UITextField!
    
    @IBOutlet weak var userTelTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func registerButtonTapped(_ sender: AnyObject) {
        
        
        let resultValue="";
       
        
        
        let userEmail = userEmailTextField.text;
        let userPassword = userPasswordTextField.text;
        let userRepeatPassword = userRepeatPasswordTextField.text;
       
        let userFirstName = userFirstNameTextFiled.text;
        let userName = userNameTextField.text;
        let userNumero = userNumeroTextField.text;
        let userAdress = userAdressTextField.text;
        let userCodePostal = userCodePostalTextField.text;
        let userPays = userPaysTextField.text;
        let userBatiment = userBatimentTextField.text;
        let userRegion = userRegionTextField.text;
        let userTel = userTelTextField.text;
        
        
        if((userPassword ?? "").isEmpty ||  (userRepeatPassword ?? "").isEmpty ||  (userEmail ?? "").isEmpty ||  (userFirstName ?? "").isEmpty ||  (userName ?? "").isEmpty ||  (userNumero ?? "").isEmpty ||  (userAdress ?? "").isEmpty ||  (userCodePostal ?? "").isEmpty ||  (userPays ?? "").isEmpty ){
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
        request.httpBody = parameters.percentEncoded()!
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
                        print(error!);
                        print(uid!);
                        
                        var isUserRegistered:Bool = false;
                        
                        if(error == false){ isUserRegistered = true; }
                        
                        var messageToDisplay = jsonResultReg["message"] as? [String];
                        if(!isUserRegistered)
                        {
                            messageToDisplay = jsonResultReg["message"] as? [String];
                        }
                    
                        
                        DispatchQueue.global(qos: .background).async {
                            // Background Thread
                            DispatchQueue.main.async {
                                // Run UI Updates
                                var myAlert = UIAlertController(title:"Alert",message: messageToDisplay as? String, preferredStyle: UIAlertController.Style.alert);
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
        
        
        /*
//        Store data
        UserDefaults.standard.set(userEmail , forKey:"userEmail");
        UserDefaults.standard.set(userPassword , forKey:"userPassword");
        UserDefaults.standard.synchronize();
        
        
        
//        Diplay confirmation message
        
        
        var  myAlert = UIAlertController(title: "Alert", message: "Registration is successful, Thanks you", preferredStyle: UIAlertController.Style.alert);
        let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default){ action in
            self.dismiss(animated: true, completion:nil);
        }
        
        myAlert.addAction(okAction);
        self.present(myAlert, animated:true, completion:nil);
        */
        
    }
    
    
    func displayMyAlertMessage(userMessage: String )
    {
        var  myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertController.Style.alert);
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil);
        
        myAlert.addAction(okAction);
        
        self.present(myAlert, animated:true, completion:nil);
        
        
    }

}
