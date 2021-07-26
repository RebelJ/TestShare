//
//  ProfilViewController.swift
//  TestShare
//
//  Created by Jean-Baptiste Revel on 27/01/2021.
//

import UIKit
import CoreData

@available(iOS 13.0, *)
class ProfilViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
       /* let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsController: UIViewController = storyboard.instantiateViewController(withIdentifier: "ProfilIdView") as UIViewController

        
        //add as a childviewcontroller
         addChild(settingsController)

         // Add the child's View as a subview
         self.view.addSubview(settingsController.view)
        settingsController.view.frame = view.bounds
        settingsController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

         // tell the childviewcontroller it's contained in it's parent
        settingsController.didMove(toParent: self)*/
        let buttonCore = UIButton(type: UIButton.ButtonType.system) as UIButton
        buttonCore.frame = CGRect(x: 100, y: 350, width: 100.00, height: 30.00)
       // let logoutButton: UIButton = UIButton(frame: CGRect(x: 100, y: 350, width: 100.00, height: 30.00));
        self.view.addSubview(buttonCore)
       // txtField.borderStyle = UIButton.BorderStyle.line
        buttonCore.setTitle("Logout", for: .normal)
        buttonCore.addTarget(self, action: #selector(ProfilViewController.buttonCoreTapped), for: UIControl.Event.touchUpInside)
        buttonCore.backgroundColor = .gray
        
        
        
        
        
       // let appDelegate = UIApplication.shared.delegate as! AppDelegate
       //     let context = appDelegate.persistentContainer.viewContext
        
        
        
        
      
        
        
        
    }
    
    
    @objc func buttonCoreTapped(sender: UIButton!) {
        
        self.showToast(message: "Toast allright !!!!!")
        
//        let managedContext = AppDelegate.viewContext

//            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
//            let predicate = NSPredicate(format: "id = %d", 2) // Specify your condition here
//        // Or for integer value
//        // let predicate = NSPredicate(format: "age > %d", argumentArray: [10])
//
//            fetch.predicate = predicate
//
//            do {
//
//              let result = try managedContext.fetch(fetch)
//              for data in result as! [NSManagedObject] {
//                print(data.value(forKey: "url") as! String)
//              }
//            } catch {
//              print("Failed")
//            }
        
     
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
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
