//
//  MenuController.swift
//  TestShare
//
//  Created by Jean-Baptiste Revel on 27/01/2021.
//

import Foundation
import UIKit


protocol MenuControllerDelegate {
    func didSelectMenuItem(named : String)
}

/*
enum SideMenuItem: String, CaseIterable {
    case home = "Home"
    case info = "Info"
    case settings = "Settings"
}
 */

enum SideMenuItem: Int {
    case Home
    case Profil
    case Settings
}

  
class MenuController: UITableViewController{
    
    var didTapMenuType : ((SideMenuItem) -> Void)?
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.backgroundColor = color
//        view.backgroundColor = color
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let menuType = SideMenuItem(rawValue: indexPath.row) else {return}
        dismiss(animated: true){ [weak self] in
            print("Dismissing: \(menuType)")
            self?.didTapMenuType?(menuType)
        }
        
        /*tableView.deselectRow(at: indexPath, animated: true)
        //Relay to delegate about menu item selection
        let selectedItem = menuItems[indexPath.row]
        delegate?.didSelectMenuItem(named: selectedItem)*/
    }
    
   
    /*
    
    //Table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        
        // A MODIFIER -> fond noir et text blanc du menu
        cell.textLabel?.textColor = .white
        cell.backgroundColor = color
        cell.contentView.backgroundColor = color
        return cell
    }
     public var delegate : MenuControllerDelegate?
     
    private let menuItems: [String]
    private let color  = UIColor(red : 33/255.0,
                                 green: 33/255.0,
                                 blue: 33/255.0,
                                 alpha: 1)
    
    init(with menuItems: [String]) {
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    */
}
