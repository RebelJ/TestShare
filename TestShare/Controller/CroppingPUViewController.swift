//
//  CroppingPUViewController.swift
//  TestShare
//
//  Created by Jean-Baptiste Revel on 23/03/2021.
//

import Foundation
import UIKit
import CropPickerView
import CoreData

private class CroppingPUViewController: UIView {
    let screenSize: CGRect = UIScreen.main.bounds
    let popupView = UIView(frame: CGRect.zero)
    let popupTitle = UILabel(frame: CGRect.zero)
   // let popupText = UILabel(frame: CGRect.zero)
    let trashButton = UIButton(frame: CGRect.zero)
    let croppingButton = UIButton(frame: CGRect.zero)
    let peliculleButton = UIButton(frame: CGRect.zero)
    let imageOView = UIImageView(frame: CGRect())
    var idImageCrop = 0
    var idImage = UILabel(frame: CGRect.zero)
//    var imageO : UIImage
//    var idUser :String
    
    let cropPickerView: CropPickerView = {
        let cropPickerView = CropPickerView()
        cropPickerView.translatesAutoresizingMaskIntoConstraints = false
       // cropPickerView.backgroundColor = .black
        return cropPickerView
    }()
    
    
    let BorderWidth: CGFloat = 2.0
    
    init() {
        super.init(frame: CGRect.zero)
//        super.init(nibName: nil, bundle: nil)
        // Semi-transparent background
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        // Popup Background
        popupView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        popupView.layer.borderWidth = BorderWidth
        popupView.layer.masksToBounds = true
        popupView.layer.borderColor = UIColor.white.cgColor
        
        // Popup Title
        popupTitle.textColor = UIColor.white
//        popupTitle.backgroundColor = UIColor.yellow
        popupTitle.layer.masksToBounds = true
        popupTitle.adjustsFontSizeToFitWidth = true
        popupTitle.clipsToBounds = true
        popupTitle.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        popupTitle.numberOfLines = 1
        popupTitle.textAlignment = .center
        
        // Popup Text
        cropPickerView.backgroundColor = #colorLiteral(red: 0.8558698893, green: 0.8208386302, blue: 0, alpha: 1)
//        imageView.textColor = UIColor.white
//        imageView.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
//        imageView.numberOfLines = 0
//        imageView.textAlignment = .center
        imageOView.isHidden = true
       // idImage.isHidden = true
        
        // Trash Button
        trashButton.setTitleColor(UIColor.red, for: .normal)
        trashButton.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        trashButton.backgroundColor = UIColor.white
//        trashButton.setImage(UIImage(named: "trash"), for: UIControl.State.normal)
        
        // Cropping Button
        croppingButton.setTitleColor(UIColor.black, for: .normal)
        croppingButton.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        croppingButton.backgroundColor = UIColor.white
        
        // Peliculle Button
        peliculleButton.setTitleColor(UIColor.blue, for: .normal)
        peliculleButton.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        peliculleButton.backgroundColor = UIColor.white
        
        
        
    
        
        popupView.addSubview(cropPickerView)
        popupView.addSubview(popupTitle)
//        popupView.addSubview(imageView)
        popupView.addSubview(trashButton)
        popupView.addSubview(croppingButton)
        popupView.addSubview(peliculleButton)
        
        // Add the popupView(box) in the PopUpWindowView (semi-transparent background)
        addSubview(popupView)
        
        
        // PopupView constraints
        popupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupView.widthAnchor.constraint(equalToConstant: screenSize.width * 0.85),
            popupView.heightAnchor.constraint(equalToConstant: screenSize.height * 0.85),
            popupView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            popupView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        
        // PopupTitle constraints
        popupTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupTitle.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: BorderWidth),
            popupTitle.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -BorderWidth),
            popupTitle.topAnchor.constraint(equalTo: popupView.topAnchor, constant: BorderWidth),
            popupTitle.heightAnchor.constraint(equalToConstant: 55)
            ])
        
        
        
      
        
        // PopupCropPicker constraints
        cropPickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cropPickerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 67),
            cropPickerView.topAnchor.constraint(equalTo: popupTitle.bottomAnchor, constant: 8),
            cropPickerView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 15),
            cropPickerView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -15),
            cropPickerView.bottomAnchor.constraint(equalTo: trashButton.topAnchor, constant: -8)
                ])
        
//        cropPickerView.delegate = self
      
    

        
        // PopupButton constraints
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trashButton.heightAnchor.constraint(equalToConstant: 44),
            trashButton.widthAnchor.constraint(equalToConstant: screenSize.width * 0.10),
            trashButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: BorderWidth),
            trashButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -200),
            trashButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -10)
            ])
        // PopupButton constraints
        croppingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            croppingButton.heightAnchor.constraint(equalToConstant: 44),
            croppingButton.widthAnchor.constraint(equalToConstant: screenSize.width * 0.10),
            croppingButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 100),
            croppingButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -100),
            croppingButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -10)
            ])
        
        // PopupButton constraints
        peliculleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            peliculleButton.heightAnchor.constraint(equalToConstant: 44),
            peliculleButton.widthAnchor.constraint(equalToConstant: screenSize.width * 0.10),
            peliculleButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 200),
            peliculleButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: BorderWidth),
            peliculleButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -10)
            ])
    }
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
@available(iOS 13.0, *)
class PopUpWindow: UIViewController {

    private let popUpWindowView = CroppingPUViewController()
    var cropped = false
   // var imageid : Int
    
    init(title: String, image: UIImage, idImage: Int) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        
        popUpWindowView.imageOView.image = image
        popUpWindowView.popupTitle.text = title
        popUpWindowView.cropPickerView.image =  image
        popUpWindowView.trashButton.setTitle("Fermer", for: .normal)
        popUpWindowView.croppingButton.setTitle("crop", for: .normal)
        popUpWindowView.peliculleButton.setTitle("Suppimer", for: .normal)
        popUpWindowView.idImage.text = String(idImage)
     //   imageid = idImage
     
        popUpWindowView.trashButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        popUpWindowView.croppingButton.addTarget(self, action: #selector(cropping), for: .touchUpInside)
        
        popUpWindowView.peliculleButton.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(confirmCrop))
        view = popUpWindowView
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func dismissView(){
           self.dismiss(animated: true, completion: nil)
       }
    
    
    @objc func deleteImage(sender: UIButton!) {
        print("delete")
        
        let managedContext = AppDelegate.viewContext
        let idDel = popUpWindowView.idImage.text

        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Image")
        fetchRequest.predicate = NSPredicate(format: "id = %@", idDel as! CVarArg)
            do
            {
                let fetchedResults =  try managedContext.fetch(fetchRequest) as? [NSManagedObject]

                for entity in fetchedResults! {

                    managedContext.delete(entity)
                }
                do {
                    try managedContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                
            }
            catch _ {
                print("Could not delete")

            }
            self.dismiss(animated: true, completion: nil)
        }
 
    @objc func cropping(sender: UIButton!) {
        
        popUpWindowView.cropPickerView.crop { (crop) in
            self.popUpWindowView.cropPickerView.image = crop.image
            self.view = self.popUpWindowView
            self.cropped = true
            
        }
      }
    
    @objc func confirmCrop(sender: UIButton!) {
        print("confirm")
        if (cropped == true){
            // Update image server
       //     let serverCon = ServerConnectionModelController()
         //   let result = serverCon.imageUpload(idUser: popUpWindowView.idUser.text!, image: self.popUpWindowView.cropPickerView.image!)
          //  return result
        }
      }
    
    
    @objc func cancelCrop(sender: UIButton!) {
        print("cancel")
        if (cropped == true){
            self.popUpWindowView.cropPickerView.image = self.popUpWindowView.imageOView.image
            self.view = self.popUpWindowView
            self.cropped = false
        }
      }
    
    
    @objc func nbImagePeliculle(sender: UIButton!) {
        
        print("nbimage")
      }

}
// MARK: CropPickerViewDelegate
extension CroppingPUViewController: CropPickerViewDelegate {
    func cropPickerView(_ cropPickerView: CropPickerView, result: CropResult) {

    }

    func cropPickerView(_ cropPickerView: CropPickerView, didChange frame: CGRect) {
        print("frame: \(frame)")
    }
}

extension CroppingPUViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        self.cropPickerView.image(image)
    }
}
