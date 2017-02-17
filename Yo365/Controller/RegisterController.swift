//
//  RegisterController.swift
//  Yo365
//
//  Created by Billy on 1/19/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

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
            showLoading(msg: "Loading... Please wait")
            ApiClient.register(username: username, email: email, password: password, errorHandler: { (msg: String) in
                self.hideLoading()
                self.showMessage(title: "Error", msg: msg)
            }, successHandler: { (customerModel: CustomerResponse) in
                self.hideLoading()
                customerManager.saveAuthenticAccount(username: username, password: password)
                customerManager.onLoginSuccessfully(loginStatus: .LoginWithSystem, customer: customerModel)
//                self.performSegue(withIdentifier: "MainScreen",
//                                  sender: self)
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController((UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContainerViewController") as? ContainerViewController)!, completion: nil)
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
    
    @IBAction func doSignInFacebook(_ sender: Any) {
        let loginManager = LoginManager()
        
        loginManager.logIn([ .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                self.showMessage(title: "Error", msg: error as! String)
                break
            case .cancelled:
                print("User cancelled login.")
                break
            case .success(_, _, let accessToken):
                self.requestSignInWithFacebook(accessToken: accessToken.authenticationToken)
                break
            }
        }
    }
    
    func requestSignInWithFacebook(accessToken: String!) {
        showLoading(msg: "Please wait while the content loads")
        ApiClient.signInWithFacebook(accessToken: accessToken, errorHandler: { (message: String) in
            self.hideLoading()
            self.showMessage(title: "Error", msg: message)
        }) { (customer: CustomerResponse) in
            self.hideLoading()
            customerManager.onLoginSuccessfully(loginStatus: .LoginWithFacebook, customer: customer)
//            self.performSegue(withIdentifier: "MainScreen",
//                              sender: self)
            
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController((UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContainerViewController") as? ContainerViewController)!, completion: nil)
            
        }
    }
}
