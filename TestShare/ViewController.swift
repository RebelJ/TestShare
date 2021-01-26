//
//  ViewController.swift
//  TestShare
//
//  Created by Jean-Baptiste Revel on 06/01/2021.
//

//import SideMenu
import UIKit
  
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning();
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(!isUserLoggedIn){
            self.performSegue(withIdentifier: "loginView", sender: self);
        }
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: AnyObject) {
        
        UserDefaults.standard.set(false, forKey: "isUserLoggedin");
        UserDefaults.standard.synchronize();
        
        self.performSegue(withIdentifier: "loginView", sender: self);
        
    }
    


}

