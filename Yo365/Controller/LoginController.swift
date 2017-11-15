//
//  ViewController.swift
//  Yo365
//
//  Created by Billy on 1/18/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import IHKeyboardAvoiding

class LoginController: BaseController {
    @IBOutlet var tfUsername: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var switchRemember: UISwitch!
    @IBOutlet var avoidingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let preferences = UserDefaults.standard
        
        tfUsername.delegate = self
        tfPassword.delegate = self
        
        if let accessToken = AccessToken.current {
            requestSignInWithFacebook(accessToken: accessToken.authenticationToken)
        }else if(preferences.object(forKey: KEY_USERNAME) != nil && preferences.object(forKey: KEY_PASSWORD) != nil){
            let username = preferences.object(forKey: KEY_USERNAME) as! String
            let password = preferences.object(forKey: KEY_PASSWORD) as! String
            
            tfUsername.text = username
            tfPassword.text = password
            
            requestLogin(username: username, password: password)
        }
        KeyboardAvoiding.avoidingView = self.avoidingView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doLogin(_ sender: Any) {
        let username = tfUsername.text
        let password = tfPassword.text
        
        if(username?.isEmpty)!{
            showMessage(title: "Error", msg: "Please enter username")
            return
        }
        
        if((username?.characters.count)! < 4){
            showMessage(title: "Error", msg: "Please choose a username between 4-20 characters")
            return
        }
        
        if(password?.isEmpty)!{
            showMessage(title: "Error", msg: "Please enter password")
            return
        }
        
        requestLogin(username: username, password: password)
    }
    
    @IBAction func doFacebookLogin(_ sender: Any){
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ReadPermission.email], viewController: self) { (loginResult) in
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
    
    @IBAction func doRegister(_ sender: UIButton) {
        performSegue(withIdentifier: "RegisterScreen",
                     sender: self)
    }
    
    @IBAction func doForgotPass(_ sender: UIButton) {
        performSegue(withIdentifier: "ForgotPasswordScreen",
                     sender: self)
    }
    
    @IBAction func doExit(_ sender: UIButton) {
        exit(0)
    }
    
    func requestLogin(username: String!,password: String!) {
        showLoading(msg: "Loading... Please wait")
        
        ApiClient.login(username: username, password: password,errorHandler: { (message: String) in
            self.showMessage(title: "Error", msg: message)
            self.hideLoading()
        }) { (customer: CustomerResponse) in
            self.hideLoading()
            self.saveAccountLogin(username: username, password: password)
            customerManager.onLoginSuccessfully(loginStatus: .LoginWithSystem, customer: customer)
            customerManager.saveSubscription(paystack_auth_code: customer.paystack_auth_code!, subscription_date: customer.subscribed_date!)
            //            self.performSegue(withIdentifier: "MainScreen",
            //                         sender: self)
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController((UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContainerViewController") as? ContainerViewController)!, completion: nil)
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
            customerManager.saveSubscription(paystack_auth_code: customer.paystack_auth_code!, subscription_date: customer.subscribed_date!)
            //            self.performSegue(withIdentifier: "MainScreen",
            //                              sender: self)
            
            (UIApplication.shared.delegate as? AppDelegate)?.changeRootViewController((UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContainerViewController") as? ContainerViewController)!, completion: nil)
        }
    }
    
    func saveAccountLogin(username: String!,password: String!) {
        if(!switchRemember.isOn){
            return
        }
        
        customerManager.saveAuthenticAccount(username: username, password: password)
    }
}

extension LoginController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfUsername {
            tfPassword.becomeFirstResponder() //move it to your next textField.
        }else if textField == tfPassword {
            tfPassword.resignFirstResponder()
        }
        
        return true
    }
}

