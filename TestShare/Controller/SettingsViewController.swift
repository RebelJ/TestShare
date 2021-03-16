//
//  SettingsViewController.swift
//  TestShare
//
//  Created by Jean-Baptiste Revel on 27/01/2021.
//

import UIKit

class SettingsViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
       
        
        view.backgroundColor = .white
        //self.displayUserInfo.text = "bitch"
        // Do any additional setup after loading the view.
        
        /*     let controller = storyboard!.instantiateViewController(withIdentifier: "SettingsIdView")
        
        
        //add as a childviewcontroller
         addChild(controller)

         // Add the child's View as a subview
        self.view.addSubview(controller.view)
        controller.view.frame = view.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

         // tell the childviewcontroller it's contained in it's parent
        controller.didMove(toParent: self)
     

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsController: UIViewController = storyboard.instantiateViewController(withIdentifier: "SettingsIdView") as UIViewController

        //add as a childviewcontroller
         addChild(settingsController)

         // Add the child's View as a subview
         self.view.addSubview(settingsController.view)
        settingsController.view.frame = view.bounds
        settingsController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

         // tell the childviewcontroller it's contained in it's parent
        settingsController.didMove(toParent: self)
        
         */
        let txtField: UITextField = UITextField(frame: CGRect(x: 250, y: 250, width: 100.00, height: 30.00));
        self.view.addSubview(txtField)
        txtField.borderStyle = UITextField.BorderStyle.line
        txtField.text = "myString"
        txtField.backgroundColor = .red
        
    
        
       
        
        let logoutButton = UIButton(type: UIButton.ButtonType.system) as UIButton
        logoutButton.frame = CGRect(x: 100, y: 350, width: 100.00, height: 30.00)
       // let logoutButton: UIButton = UIButton(frame: CGRect(x: 100, y: 350, width: 100.00, height: 30.00));
        self.view.addSubview(logoutButton)
       // txtField.borderStyle = UIButton.BorderStyle.line
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(SettingsViewController.logoutButtonTapped), for: UIControl.Event.touchUpInside)
        logoutButton.backgroundColor = .red
    
         
          
    }

    
    
    
    
    @objc func logoutButtonTapped(sender: UIButton!) {
      
          UserDefaults.standard.set(false, forKey: "isUserLoggedin");
          UserDefaults.standard.synchronize();

          performSegue(withIdentifier: "loginView", sender: self);
        
      //  let image = HomeViewController.retrieve(imageNamed: "yes")
        
       // let image = UIImage(named: imageName)
       // let imageView = UIImageView(image: image!)
        
        
//        imageView.frame = CGRect(x: 100, y: 100, width: 100, height: 200)
//        self.view.addSubview(imageView)
//
        
      }
    
}
