//
//  ContainerViewController.swift
//  Yo365
//
//  Created by Billy on 1/24/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class ContainerViewController: SlideMenuController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        //        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainController") {
//            self.mainViewController = controller
//        }
        SlideMenuOptions.hideStatusBar = true
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Left") {
            self.leftViewController = controller
        }
        
        SlideMenuOptions.hideStatusBar = true
        super.awakeFromNib()
    }
}
