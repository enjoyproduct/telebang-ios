//
//  BaseTabController.swift
//  Yo365
//
//  Created by Billy on 3/3/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class BaseTabController: BaseNavController{
    
    override func initRightHeader() {
        super.initRightHeader()
        let rightButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_search"), style: .plain, target: self, action: #selector(self.callSearchMethod))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func callSearchMethod() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchView")
        present(vc!, animated: true, completion: nil)
    }
    
    func hideTabBar(flag:Bool) {
        let atc = self.tabBarController as! RAMAnimatedTabBarController
        atc.animationTabBarHidden(flag)
        
        self.tabBarController?.tabBar.isHidden = flag
    }
}
