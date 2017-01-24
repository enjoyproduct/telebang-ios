//
//  SideMenuView.swift
//  Yo365
//
//  Created by Billy on 1/23/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class SideMenuView: BaseController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doSetting(_ sender: UIButton) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "SettingScreen") {
           self.slideMenuController()?.changeMainViewController(controller, close: true)
        }
    }
}
