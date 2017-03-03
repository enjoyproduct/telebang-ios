//
//  BaseTabController.swift
//  Yo365
//
//  Created by Billy on 3/3/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class BaseTabController: BaseSlideController{
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if ((self.navigationController?.viewControllers.count)! > 1) {
            hideTabBar(flag: true)
        }else{
            hideTabBar(flag: false)
        }
    }
    
    func hideTabBar(flag:Bool) {
        let atc = self.tabBarController as! RAMAnimatedTabBarController
        atc.animationTabBarHidden(flag)
        
        self.tabBarController?.tabBar.isHidden = flag
        
        if(flag){
            self.tabBarController?.tabBar.layer.zPosition = -1
        }
    }
}
