//
//  SettingController.swift
//  Yo365
//
//  Created by Billy on 1/24/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Kingfisher

class SettingController: BaseNavController {
    @IBOutlet var imvPremium: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        updateTitleHeader(title: "Account")
        
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
}
