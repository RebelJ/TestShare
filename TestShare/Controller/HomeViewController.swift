//
//  HomeViewController.swift
//  TestShare
//
//  Created by Jean-Baptiste Revel on 06/01/2021.
//

import SideMenu
import UIKit
//import PlaygroundSupport


  
class HomeViewController: UIViewController/*, MenuControllerDelegate*/ {
    
    var myCollectionView:UICollectionView?
   
    private let settingsController = SettingsViewController()
    private let profilController = ProfilViewController()
  //  private let imageStore = ImageStore()
    
    
   // private var sideMenu: SideMenuNavigationController?
    
    
    let transition = SlideInTransition()
    var topView: UIView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        /*
        //Init menu
        let menu = MenuController(with: ["Home","Info","Settings"])
        menu.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        
        //diplay User Info
//        let userUIDStorage = UserDefaults.standard.string(forKey: "userId")
//        displayUserInfo.text = userUIDStorage
//        
//
            */
        
        
        
         let view = UIView()
         view.backgroundColor = .white
             
         let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
         layout.sectionInset = UIEdgeInsets(top: 200, left: 20, bottom: 10, right: 20)
         layout.itemSize = CGSize(width: 90, height: 90)
         
         myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
         myCollectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
         myCollectionView?.backgroundColor = UIColor.white
        
             
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
      
        view.addSubview(myCollectionView ?? UICollectionView())
        
        
        
 //       let imageName = "IMG_20201219_180627"
        
   
             
        self.view = view
        
        addChildControllers()
    }
    
    /*
    
    func loadIimage() {
        if let photo = defaults.objectForKey("\(intFileRef)") as? NSData {
                  println("Image created")
                  let photo = defaults.objectForKey("\(intFileRef)") as NSData
                  let imageToView:UIImage = UIImage(data: photo)

                  var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                  imageView.image = imageToView
                  self.view.addSubview(imageView)
              }
    }
    */
    
    
    
    //add subView of the menu
    func addChildControllers() {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let settingsController: UIViewController = storyboard.instantiateViewController(withIdentifier: "SettingsIdView") as UIViewController

        
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
    
    
    
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
      
        //Print TEST isLoggin
        //===================
        let user =   UserDefaults.standard.string(forKey: "userId");
        print(user!)
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        print(isUserLoggedIn)
        //=============================
        
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
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let settingsController: UIViewController = storyboard.instantiateViewController(withIdentifier: "SettingsIdView") as UIViewController

        
        topView?.removeFromSuperview()
        
        switch menuType {
        
        case .Home:
           // let view = UIView()
            
            self.settingsController.view.isHidden = true
            self.profilController.view.isHidden = true
         //   view.backgroundColor = .blue
         //   view.frame = self.view.bounds
         //   self.topView = view
        
        case .Profil:
           // let view = UIView()
            
            
            self.settingsController.view.isHidden = true
            self.profilController.view.isHidden = false
                //    view.backgroundColor = .blue
        //    view.frame = self.view.bounds
          //  self.topView = view
            
        case .Settings:
            
            
          //  let view = UIView()
            
            self.settingsController.view.isHidden = false
            self.profilController.view.isHidden = true
      //      view.backgroundColor = .yellow
        //    view.frame = self.view.bounds
         //   self.topView = view
            
            
        default:
            break
        }
    }
    
    //Button menu action
 /*   func didSelectMenuItem(named: String) {
        
        sideMenu?.dismiss(animated: true, completion: { [weak self] in
            self?.title = named
            
            
            if named == "Home" {
                self?.settingsController.view.isHidden = true
                self?.infoController.view.isHidden = true
                
            }
            else if named == "Info" {
                self?.settingsController.view.isHidden = true
                self?.infoController.view.isHidden = false
            }
            else if named == "Settings" {
                self?.settingsController.view.isHidden = false
                self?.infoController.view.isHidden = true
            }
        })
            
        
    }*/
    
    
  
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning();
    }
    
    
    //Verifiy if user is loggedin
    override func viewDidAppear(_ animated: Bool) {
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(!isUserLoggedIn){
            self.performSegue(withIdentifier: "loginView", sender: self);
        }
    }
    
    
    static func delete(imageNamed name: String) {
        guard let imagePath = path(for: name) else {
            return
        }
        
        try? FileManager.default.removeItem(at: imagePath)
    }
    
    static func retrieve(imageNamed name: String) -> UIImage? {
        guard let imagePath = path(for: name) else {
            return nil
        }
        
        return UIImage(contentsOfFile: imagePath.path)
    }
    
    
    private static func path(for imageName: String, fileExtension: String = "png") -> URL? {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return directory?.appendingPathComponent("\(imageName).\(fileExtension)")
    }
    
    
     
  /*  @IBOutlet var UIImageViewDisplay: UIImageView!{
        if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
                   let image = UIImage(data: imageData)
                   {
                        return image
                    }
    }
    
    
    
    
    
    
    // Button Logout (A DEPLACER)
    @IBAction func logoutButtonTapped(_ sender: AnyObject) {
        
        UserDefaults.standard.set(false, forKey: "isUserLoggedin");
        UserDefaults.standard.synchronize();
        
        self.performSegue(withIdentifier: "loginView", sender: self);
    }
 
     */
    
}

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





extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9 // How many cells to display
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        myCell.backgroundColor = UIColor.gray
//        let image = myImages[indexPath.row]
//        myCell.imageView.image = image
        
        return myCell
    }
}
extension HomeViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("User tapped on item \(indexPath.row)")
    }
}


// Present the view controller in the Live View window
//PlaygroundPage.current.liveView = HomeViewController()
