//
//  SettingController.swift
//  Yo365
//
//  Created by Billy on 1/24/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Kingfisher

class SettingController: BaseSlideController {
    @IBOutlet var imvAvatar: UIImageView!
    @IBOutlet var imvPremium: UIImageView!
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        updateTitleHeader(title: "Setting")
        let urlAvatar = URL(string: customerManager.getCustomerModel().avatar!)!
        imvAvatar.kf.setImage(with: urlAvatar, placeholder: Image.init(named: "img_avatar_default"), options: nil, progressBlock: nil, completionHandler: nil)
        
        if(!customerManager.isPremiumAccount()){
            imvPremium.image = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doSignOut(_ sender: UIButton) {
        customerManager.doLogout()
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController((UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as? LoginController)!, completion: nil)
    }
    
    @IBAction func doChangeProfile(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "ChangeProfileView", sender: self)
    }
    
    @IBAction func doChangePassword(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "ChangePasswordView", sender: self)
    }
    
    @IBAction func doChangeAvatar(_ sender: UITapGestureRecognizer) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
}

extension SettingController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        imvAvatar.image = chosenImage //4
        
        let imageUrl          = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imageName         = imageUrl.lastPathComponent
        
        dismiss(animated:true, completion: nil) //5
        
        ApiClient.changeAvatar(customerID: customerManager.getCustomerID(), image: chosenImage, errorHandler: { (msg: String) in
            
        }, successHandler: { 
            
        })
    }   
}
