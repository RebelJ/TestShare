//
//  HomeViewController.swift
//  TestShare
//
//  Created by Jean-Baptiste Revel on 06/01/2021.
//

import SideMenu
import UIKit
import CoreData
//import PlaygroundSupport


  
@available(iOS 13.0, *)
class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var myCollectionView:UICollectionView?
    @IBOutlet weak var imageTest: UIImageView!
    
    private let settingsController = SettingsViewController()
    private let profilController = ProfilViewController()
    
    var selectionOn = false
    let buttonSelection = UIButton(type: UIButton.ButtonType.system) as UIButton
    
    let boutonPeliculleBuy = UIButton(type: UIButton.ButtonType.system) as UIButton
    
    let transition = SlideInTransition()
    var topView: UIView?

    var idUser : String = ""
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupNotification()
        loadSavedData()
     
        
        
//        setupNotification()

        //collection view of image
        let view = UIView()
        view.backgroundColor = .white

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 75, left: 10, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: 80, height: 80)
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView?.backgroundColor = UIColor.white
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            myCollectionView!.refreshControl = refreshControl
        } else {
            myCollectionView!.addSubview(refreshControl)
        }
        
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Weather Data ...")
        
        self.view.addSubview(myCollectionView ?? UICollectionView())
        


//        //UserID from local storage
//        idUser =   UserDefaults.standard.string(forKey: "userId")!;
//        if  (idUser == ""){
//            let incomingUser = UserDefaults(suiteName: "group.POP.TestShare")
//            idUser = incomingUser!.string(forKey: "userId")!;
//            if(idUser == "") {
//                let managedContext = AppDelegate.viewContext
//                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//                    fetch.predicate = nil
//                    do {
//                      let result = try managedContext.fetch(fetch)
//                      for data in result as! [NSManagedObject] {
//                        idUser  = data.value(forKey: "id") as! String
//                      }
//                    } catch {
//                      print("Failed")
//                    }
//            }
//        }
//
//        print (idUser)
        
//
//        let txtField: UITextField = UITextField(frame: CGRect(x: 250, y: 250, width: 100.00, height: 30.00));
//        self.view.addSubview(txtField)
//        txtField.borderStyle = UITextField.BorderStyle.line
//        txtField.text = idUser
//        txtField.backgroundColor = .red
            
            
       
        
         // Init button selection image
//         buttonSelection = UIButton(type: UIButton.ButtonType.system) as UIButton
//        buttonSelection.frame = CGRect(x: 100, y: 250, width: 100.00, height: 30.00)
//        buttonSelection.setTitle("Selection", for: .normal)
//        buttonSelection.addTarget(self, action: #selector(HomeViewController.buttonSelectionTapped), for: UIControl.Event.touchUpInside)
//        buttonSelection.backgroundColor = .white
//        self.view.addSubview(buttonSelection)
        
        // Init button peliculle buy
//         buttonSelection = UIButton(type: UIButton.ButtonType.system) as UIButton
//        boutonPeliculleBuy.frame = CGRect(x: 200, y: 250, width: 100.00, height: 30.00)
//        boutonPeliculleBuy.setTitle("Achat peliculle", for: .normal)
//        boutonPeliculleBuy.addTarget(self, action: #selector(HomeViewController.boutonPeliculleBuyTapped), for: UIControl.Event.touchUpInside)
//        boutonPeliculleBuy.backgroundColor = .white
//        self.view.addSubview(boutonPeliculleBuy)
        
        self.addChildControllers()
        
        
       
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        fetchWeatherData()
    }
    private func fetchWeatherData() {
//        dataManager.weatherDataForLocation(latitude: 37.8267, longitude: -122.423) { (location, error) in
//            DispatchQueue.main.async {
//                if let location = location {
//                    self.days = location.days
//                }
                loadSavedData()

                myCollectionView!.reloadData()
               // self.viewDidLoad()
                self.refreshControl.endRefreshing()
             //   self.activityIndicatorView.stopAnimating()
//            }
//        }
    }
    

    @objc func buttonSelectionTapped(sender: UIButton!) {

        if (selectionOn == false) {
            buttonSelection.setTitle("Annuler", for: .normal)
            selectionOn = true
        } else {
            selectionOn = false
            buttonSelection.setTitle("Selection", for: .normal)
        }
        self.view.addSubview(buttonSelection)
      }
    
//    @objc func boutonPeliculleBuyTapped(sender: UIButton!) {
//      }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("User tapped on item \(indexPath.row)")
        let cell = collectionView.cellForItem(at : indexPath)
       
        if (selectionOn == true){
            if (cell?.layer.borderColor != UIColor.red.cgColor){
                cell?.layer.borderColor = UIColor.red.cgColor
                cell?.layer.borderWidth = 2
                //ajouter à la liste de selection
            }
            else {
                cell?.layer.borderColor = nil
                cell?.layer.borderWidth = 0
                //supprimer de la liste de selection
            }
        }else{
            
            //popup recadrage
            let image = images[indexPath.row]
            let idImage = tables[indexPath.row]
            var popUpWindow: PopUpWindow!
            popUpWindow = PopUpWindow(title: "Cropping", image: image as! UIImage, idImage: idImage)
            self.present(popUpWindow, animated: true, completion: nil)
        }
    
    }
    
    
    
    // Number of cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 24
        return images.count
    }
    //make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        //get  a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: /*reuseIdentifier*/"MyCell", for: indexPath as IndexPath)
        cell.layer.backgroundColor = UIColor.gray.cgColor
        let imageView:UIImageView=UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width,height: cell.frame.width))
        imageView.image = images[indexPath.row] as! UIImage
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    
    @available(iOS 13.0, *)
    func loadSavedData() {
        
        var image:UIImage = UIImage(named: "33.png")!
        var idImage = 0
        
        
        
        let managedContext = AppDelegate.viewContext
        tables.removeAll()
        images.removeAll()
//        DispatchQueue.main.async {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
            fetch.predicate = nil
            do {
              let result = try managedContext.fetch(fetch)
              for data in result as! [NSManagedObject] {
                image = UIImage(data: data.value(forKey: "url") as! Data)!
                idImage = data.value(forKey: "id") as! Int
                self.tables.append(idImage)
                self.images.append(image)
              }
            } catch {
              print("Failed")
            }
//        }
    }
    
    
    //for the collectionView
    var images :[Any] = []
    var tables :[Int] = []
    
//    deinit {
//          NotificationCenter.default.removeObserver(self)
//      }
//
//      func setupNotification() {
//          NotificationCenter.default.addObserver(
//              self,
//              selector: #selector(setUrl),
//              name: UIApplication.didBecomeActiveNotification,
//              object: nil
//          )
//      }

    
    //Verifiy if user is loggedin
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        //UserID from local storage
        var idUser =   UserDefaults.standard.bool(forKey: "isUserLoggedIn");
        if  (idUser == false){
            let incomingUser = UserDefaults(suiteName: "group.POP.TestShare")
            idUser = incomingUser!.bool(forKey: "isUserLoggedIn");
            if(idUser == false) {
                let managedContext = AppDelegate.viewContext
                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
                    fetch.predicate = nil
                    do {
                      let result = try managedContext.fetch(fetch)
                      for data in result as! [NSManagedObject] {
                        idUser  = data.value(forKey: "isLog") as! Bool
                      }
                    } catch {
                      print("Failed")
                    }
            }
        }
        
        if(idUser == false){
            self.performSegue(withIdentifier: "loginView", sender: self);
        }
        
    }
//    @objc func setUrl() {
//            if let incomingURL = UserDefaults(suiteName: "group.POP.TestShare")?.value(forKey: "incomingURL") as? String {
//                urlTextField.text = incomingURL
//                UserDefaults(suiteName: "group.POP.TestShare")?.removeObject(forKey: "incomingURL")
//            }
//        }
    
    
    
    //add subView of the menu
    func addChildControllers() {

        addChild(settingsController)
        addChild(profilController)
        
        view.addSubview(settingsController.view)
        view.addSubview(profilController.view)
        
        settingsController.view.frame = view.bounds
        profilController.view.frame = view.bounds
        
       // settingsController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        settingsController.didMove(toParent: self)
        profilController.didMove(toParent: self)
        
        settingsController.view.isHidden = true 
        profilController.view.isHidden = true
        
        
        
        
        
    }
    
    
    
    @available(iOS 13.0, *)
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
      
    
        
        guard let menuViewController = storyboard?.instantiateViewController(identifier: "MenuController") as? MenuController else {return}
      //  present(sideMenu!, animated: true)
        menuViewController.didTapMenuType = {menuType in
            self.transitionToNew(menuType)
        }
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
        
        
    }
    
    func transitionToNew(_ menuType: SideMenuItem){
        let title = String(describing: menuType).capitalized
        self.title = title
        
        topView?.removeFromSuperview()
        
        switch menuType {
        
        case .Home:
           // let view = UIView()
            
            self.settingsController.view.isHidden = true
            self.profilController.view.isHidden = true
        
        case .Profil:
           // let view = UIView()
            
            self.settingsController.view.isHidden = true
            self.profilController.view.isHidden = false
            
        case .Settings:
          //  let view = UIView()
            
            self.settingsController.view.isHidden = false
            self.profilController.view.isHidden = true
        
        case .Disconnect:
            logOut()
            
        default:
            break
        }
    }
  
  
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning();
    }
    
    func logOut(){
        UserDefaults.standard.set(false, forKey: "isUserLoggedin");
        UserDefaults.standard.set("", forKey: "userId")
        UserDefaults.standard.synchronize();
        

        performSegue(withIdentifier: "loginView", sender: self);
    }
    

}

@available(iOS 13.0, *)
extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}




//extension NSPersistentContainer {
//    // Configure change event handling from external processes.
//    func observeAppExtensionDataChanges() {
//        DarwinNotificationCenter.shared.addObserver(self, for: .didSaveManagedObjectContextExternally, using: { [weak self] (_) in
//            // Since the viewContext is our root context that's directly connected to the persistent store, we need to update our viewContext.
//            self?.viewContext.perform {
//                self?.viewContextDidSaveExternally()
//            }
//        })
//    }
//}
//
//extension NSPersistentContainer {
//    /// Called when a certain managed object context has been saved from an external process. It should also be called on the context's queue.
//    func viewContextDidSaveExternally() {
//        // `refreshAllObjects` only refreshes objects from which the cache is invalid. With a staleness intervall of -1 the cache never invalidates.
//        // We set the `stalenessInterval` to 0 to make sure that changes in the app extension get processed correctly.
//        viewContext.stalenessInterval = 0
//        viewContext.refreshAllObjects()
//        viewContext.stalenessInterval = -1
//    }
//}
extension DarwinNotification.Name {
    private static let appIsExtension = Bundle.main.bundlePath.hasSuffix(".appex")

    /// The relevant DarwinNotification name to observe when the managed object context has been saved in an external process.
    static var didSaveManagedObjectContextExternally: DarwinNotification.Name {
        if appIsExtension {
            return appDidSaveManagedObjectContext
        } else {
            return extensionDidSaveManagedObjectContext
        }
    }

    /// The notification to post when a managed object context has been saved and stored to the persistent store.
    static var didSaveManagedObjectContextLocally: DarwinNotification.Name {
        if appIsExtension {
            return extensionDidSaveManagedObjectContext
        } else {
            return appDidSaveManagedObjectContext
        }
    }

    /// Notification to be posted when the shared Core Data database has been saved to disk from an extension. Posting this notification between processes can help us fetching new changes when needed.
    private static var extensionDidSaveManagedObjectContext: DarwinNotification.Name {
        return DarwinNotification.Name("group.POP.TestShare.extension-did-save")
    }

    /// Notification to be posted when the shared Core Data database has been saved to disk from the app. Posting this notification between processes can help us fetching new changes when needed.
    private static var appDidSaveManagedObjectContext: DarwinNotification.Name {
        return DarwinNotification.Name("group.POP.TestShare.app-did-save")
    }
}


