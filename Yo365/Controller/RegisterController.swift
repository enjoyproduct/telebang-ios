//
//  RegisterController.swift
//  Yo365
//
//  Created by Billy on 1/19/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class RegisterController: BaseController {
    @IBOutlet var utfUsername: UITextField!
    @IBOutlet var utfEmail: UITextField!
    @IBOutlet var utfPassword: UITextField!
    @IBOutlet var utfRePassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doBack(_ sender: UIButton) {
        backView()
    }
    
    @IBAction func doRegister(_ sender: UIButton) {
        let username:String! = utfUsername.text
        let email:String! = utfEmail.text
        let password:String! = utfPassword.text
        
        let msg = validate()
        if(msg.isEmpty){
            ApiClient.register(username: username, email: email, password: password, errorHandler: { (msg: String) in
                self.showMessage(title: "Error", msg: msg)
            }, successHandler: { (customerModel: CustomerResponse) in
                self.performSegue(withIdentifier: "MainScreen",
                                  sender: self)
            })
        }else{
            showMessage(title: "Error", msg: msg)
        }
    }
    
    func validate() -> String {
        var message:String = ""
        
        let username = utfUsername.text
        let email = utfEmail.text
        let password = utfPassword.text
        let rePassword = utfRePassword.text
        
        if(!ValidateUtil.isValidUsername(strUsername: username)){
            message = ValidateUtil.USERNAME_INVALID_MSG
        }else if(!ValidateUtil.isValidEmail(emailAddress: email!)){
            message = ValidateUtil.EMAIL_INVALID_MSG
        }else if(password?.isEmpty)!{
            message = "Please enter password"
        }else if((password?.characters.count)! < 4){
            message = ValidateUtil.PASSWORD_INVALID_MSG
        }else if(password != rePassword){
            message = ValidateUtil.PASSWORD_NOT_MATCH_MSG
        }
        
        return message
    }
}
