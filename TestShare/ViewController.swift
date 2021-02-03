//
//  ViewController.swift
//  TestShare
//
//  Created by Jean-Baptiste Revel on 06/01/2021.
//

import SideMenu
import UIKit
  
class ViewController: UIViewController, MenuControllerDelegate {
   
    private let settingsController = SettingsViewController()
    private let infoController = InfoViewController()
    
    private var sideMenu: SideMenuNavigationController?
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        let menu = MenuController(with: SideMenuItem.allCases)
        menu.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
    } 
    
    override func addChild(_ childController: UIViewController) {
        addChild(settingsController)
        addChild(infoController)
        
        view.addSubview(settingsController.view)
        view.addSubview(infoController.view)
        
        settingsController.view.frame = view.bounds
        infoController.view.frame = view.bounds
        
        settingsController.didMove(toParent: self)
        infoController.didMove(toParent: self)
        
        settingsController.view.isHidden = true
        infoController.view.isHidden = true
    }
    
    
    @IBAction func didTapMenuButton(){
         
        present(sideMenu!, animated: true)
        
    }
    
    func didSelectMenuItem(named: SideMenuItem) {
        sideMenu?.dismiss(animated: true, completion: nil)
            title = named.rawValue
            
            switch named{
            case .home :
                settingsController.view.isHidden = true
                infoController.view.isHidden = true
            case .info :
                settingsController.view.isHidden = true
                infoController.view.isHidden = false
            case .settings:
                settingsController.view.isHidden = false
                infoController.view.isHidden = true
            }
        
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
