//
//  SettingController.swift
//  Yo365
//
//  Created by Billy on 1/24/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class SettingController: BaseController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doMenu(_ sender: UIButton) {
        self.slideMenuController()?.openLeft()
    }
}
