//
//  ViewController.swift
//  Yo365
//
//  Created by Billy on 1/18/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class LoginController: BaseController {
    @IBOutlet var tfUsername: UITextField!
    @IBOutlet var tfPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        ApiClient.login(username: username, password: password,errorHandler: { (message: String) in
            self.showMessage(title: "Error", msg: message)
        }) { (customer: CustomerResponse) in
            self.performSegue(withIdentifier: "MainScreen",
                         sender: self)
        }
    }
}

