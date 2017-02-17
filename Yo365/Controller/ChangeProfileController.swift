//
//  ChangeProfileController.swift
//  Yo365
//
//  Created by Billy on 2/13/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class ChangeProfileController: BaseSlideController {
    @IBOutlet var imvBgrAvatar: UIImageView!
    @IBOutlet var imvAvatar: UIImageView!
    @IBOutlet var lbUsername: UILabel!
    @IBOutlet var utfFirstName: UITextField!
    @IBOutlet var utfLastName: UITextField!
    @IBOutlet var utfEmail: UITextField!
    @IBOutlet var utfPhone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTitleHeader(title: "Change Profile")
        
        // Circular avatar
        imvAvatar.layer.cornerRadius = imvAvatar.frame.size.width / 2;
        //        imvAvatar.layer.borderWidth = 3.0
        //        imvAvatar.layer.borderColor = UIColor.red.cgColor
        imvAvatar.clipsToBounds = true;
        
        let urlAvatar = URL(string: customerManager.getCustomerModel().avatar!)!
        imvAvatar.kf.setImage(with: urlAvatar, placeholder: Image.init(named: "img_avatar_default"), options: nil, progressBlock: nil, completionHandler: nil)
        
        imvBgrAvatar.kf.setImage(with: urlAvatar, placeholder: Image.init(named: "img_avatar_default"), options: nil, progressBlock: nil, completionHandler: nil)
        
        lbUsername.text = customerManager.getCustomerModel().username
        
        utfEmail.text = customerManager.getCustomerModel().email
        utfFirstName.text = customerManager.getCustomerModel().firstName
        utfLastName.text = customerManager.getCustomerModel().lastName
        utfPhone.text = customerManager.getCustomerModel().phone
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func doSubmit(_ sender: UIButton) {
        let email = utfEmail.text!
        let firstName = utfFirstName.text!
        let lastName = utfLastName.text!
        let phone = utfPhone.text!
        
        let msg = validate()
        if(msg.isEmpty){
            let params: Parameters = [KEY_USER_ID: customerManager.getCustomerID(), KEY_EMAIL: email, KEY_FIRST_NAME: firstName, KEY_LAST_NAME: lastName, KEY_PHONE_NUMBER: phone]
            
            showLoading(msg: "Loading... Please wait")
            ApiClient.changeProfile(params: params, errorHandler: { (msg: String) in
                self.hideLoading()
                
            }, successHandler: { (response: CustomerResponse) in
                self.hideLoading()
                customerManager.onChangeProfileSuccessfully(customer: response)
                self.showMessage(title: "Successfully", msg: "Profile updated successfully!", handler: { (alert: UIAlertAction) in
                    self.backView()
                })
            })
        }else{
            showMessage(title: "Error", msg: msg)
        }
    }
    
    func validate() -> String {
        var message:String = ""

        let email = utfEmail.text
        let firstName = utfFirstName.text
        let lastName = utfLastName.text
        
        if(firstName?.isEmpty)!{
            message = "Please enter First Name"
        }else if(lastName?.isEmpty)!{
            message = "Please enter Last Name"
        }else if(!ValidateUtil.isValidEmail(emailAddress: email!)){
            message = ValidateUtil.EMAIL_INVALID_MSG
        }
        
        return message
    }

}
