//
//  HomeViewController.swift
//  TestShare
//
//  Created by Jean-Baptiste Revel on 06/01/2021.
//

import SideMenu
import UIKit
//import PlaygroundSupport


  
class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var myCollectionView:UICollectionView?
   
    private let settingsController = SettingsViewController()
    private let profilController = ProfilViewController()
    
    let transition = SlideInTransition()
    var topView: UIView?
    
    @IBOutlet weak var labelID: UILabel!
    
    @IBOutlet weak var imageField: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupNotification()

        //collection view of image
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
        self.view.addSubview(myCollectionView ?? UICollectionView())


        //UserID from local storage
        let user =   UserDefaults.standard.string(forKey: "userId");
        
        let incomingUser = UserDefaults(suiteName: "group.POP.TestShare")
        if let userStore = incomingUser?.string(forKey: "userId") {

        let txtField: UITextField = UITextField(frame: CGRect(x: 250, y: 250, width: 100.00, height: 30.00));
        self.view.addSubview(txtField)
        txtField.borderStyle = UITextField.BorderStyle.line
        txtField.text = userStore
        txtField.backgroundColor = .red

        }
        
        
        
        let incomingURL = UserDefaults(suiteName: "group.POP.TestShare")
        if let imageStore = incomingURL?.string(forKey: "url") {
            print("Available Data")
//            let img = (incomingURL?.value(forKey: "url") as! Data)
            self.imageField.image = UIImage(data : imageStore as! Data)
//            UserDefaults(suiteName: "POP.TestShare.ShareExtension")?.removeObject(forKey: "url")
        }
        
        addChildControllers()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        print("User tapped on item \(indexPath.row)")
        
        
    }
    
    // Number of cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    //make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        //get  a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: /*reuseIdentifier*/"MyCell", for: indexPath as IndexPath)

        
      
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        let imageview:UIImageView=UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width,height: cell.frame.width))
        imageview.layer.cornerRadius=8
        let image:UIImage = UIImage(named: images[indexPath.row]) ?? UIImage(named: "33.png") as! UIImage
        imageview.image = image
        cell.contentView.addSubview(imageview)
        
        return cell
    }
    
    //for the collectionView
    var images: [String] = [
        "11.png", "10.png", "11.png",
        "10.png", "10.png", "10.png",
        "11.png", "11.png", "11.png",
        "10.png", "11.png", "10.png",
        "10.png", "10.png", "11.png",
        "61.png", "11.png", "10.png",
        "11.png", "72.png", "10.png",
    ]
    
    deinit {
          NotificationCenter.default.removeObserver(self)
      }

      func setupNotification() {
          NotificationCenter.default.addObserver(
              self,
              selector: #selector(setUrl),
              name: UIApplication.didBecomeActiveNotification,
              object: nil
          )
      }
    
    
    //Verifiy if user is loggedin
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // self.setUrl()
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(!isUserLoggedIn){
            self.performSegue(withIdentifier: "loginView", sender: self);
        }
        
    }
    
    
    
    @objc func setUrl() {
        
        if let incomingURL = UserDefaults(suiteName: "group.POP.TestShare"){
            let image1 = incomingURL.string(forKey: "url")
            imageField.image = UIImage(data : image1 as! Data)
            
//            UserDefaults(suiteName: "POP.TestShare.ShareExtension")?.removeObject(forKey: "incomingURL")
        }
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

            UserDefaults.standard.set(false, forKey: "isUserLoggedin");
            UserDefaults.standard.synchronize();
            

            performSegue(withIdentifier: "loginView", sender: self);
            
            
        default:
            break
        }
    }
  
  
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning();
    }
    
    
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
