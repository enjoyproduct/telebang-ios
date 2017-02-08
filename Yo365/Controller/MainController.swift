//
//  MainController.swift
//  Yo365
//
//  Created by Billy on 1/20/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController


class MainController: RAMAnimatedTabBarController {
    var positionActive: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidesBottomBarWhenPushed = true
        setSelectIndex(from: 0, to: positionActive)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
