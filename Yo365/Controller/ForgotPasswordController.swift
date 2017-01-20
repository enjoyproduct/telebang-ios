//
//  ForgotPasswordController.swift
//  Yo365
//
//  Created by Billy on 1/19/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class ForgotPasswordController: BaseController {
    @IBOutlet var utfEmail: UITextField!
    
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
    
    @IBAction func doSubmit(_ sender: UIButton) {
        let email:String! = utfEmail.text

        if(ValidateUtil.isValidEmail(emailAddress: email!)){
            ApiClient.forgotPassword(email: email, errorHandler: { (msg: String) in
                self.showMessage(title: "Error", msg: msg)
            }, successHandler: { (msg: String) in
                self.showMessage(title: "Successfully", msg: msg, handler: { (action) in
                    self.backView()
                })
            })

        }else{
            showMessage(title: "Error", msg: ValidateUtil.EMAIL_INVALID_MSG)
        }
    }
}
