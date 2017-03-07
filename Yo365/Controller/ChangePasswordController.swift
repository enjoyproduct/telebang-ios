//
//  ChangePasswordController.swift
//  Yo365
//
//  Created by Billy on 2/13/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class ChangePasswordController: BaseNavController {
    @IBOutlet var utfCurrentPassword: UITextField!
    @IBOutlet var utfNewPassword: UITextField!
    @IBOutlet var utfReNewPassword: UITextField!
    
    @IBOutlet var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTitleHeader(title: "Change Password")
        
        utfCurrentPassword.delegate = self
        utfNewPassword.delegate = self
        utfReNewPassword.delegate = self
        
        enableTapDismissKeyboar()
        KeyboardAvoiding.avoidingView = self.btnSubmit
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doSubmit(_ sender: UIButton) {
        let oldPassword = utfCurrentPassword.text
        let newPassword = utfNewPassword.text
        
        let msg = validate()
        if(msg.isEmpty){
            showLoading(msg: "Loading... Please wait")
            ApiClient.changePassword(accountID: customerManager.getCustomerID(), currentPassword: oldPassword!, newPassword: newPassword!, errorHandler: { (msg: String) in
                self.hideLoading()
                self.showMessage(title: "Error", msg: msg)
            }, successHandler: {
                self.hideLoading()
                customerManager.onChangePasswordSuccessfully(password: newPassword!)
                self.showMessage(title: "Successfully", msg: "Password updated successfully!", handler: { (alert: UIAlertAction) in
                    self.backView()
                })
            })
        }else{
            showMessage(title: "Error", msg: msg)
        }
    }
    
    func validate() -> String {
        var message:String = ""
        
        let oldPassword = utfCurrentPassword.text
        let password = utfNewPassword.text
        let rePassword = utfReNewPassword.text
        
        if((oldPassword?.isEmpty)! || (password?.isEmpty)! || (rePassword?.isEmpty)!){
            message = "Please enter password"
        }else if((password?.characters.count)! < 4){
            message = ValidateUtil.PASSWORD_INVALID_MSG
        }else if(password != rePassword){
            message = ValidateUtil.PASSWORD_NOT_MATCH_MSG
        }
        
        return message
    }
}

extension ChangePasswordController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == utfCurrentPassword {
            utfNewPassword.becomeFirstResponder() //move it to your next textField.
        } else if textField == utfNewPassword {
            utfReNewPassword.becomeFirstResponder()
        }else if textField == utfReNewPassword{
            utfReNewPassword.resignFirstResponder()
        }
        
        return true
    }
}
