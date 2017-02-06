//
//  BaseSlideController.swift
//  Yo365
//
//  Created by Billy on 2/6/17.
//  Copyright © 2017 Billy. All rights reserved.
//
import UIKit

class BaseSlideController: BaseController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.blackTranslucent
        nav?.tintColor = UIColor.white
        
        let navBackgroundImage:UIImage! = UIImage.init(named: "bgr_header_slide_menu")
        nav?.setBackgroundImage(navBackgroundImage, for: .default)
        
        var leftButton: UIBarButtonItem
        if ((self.navigationController?.viewControllers.count)! > 1) {
            let button = UIButton.init(type: .custom)
            button.setImage(UIImage.init(named: "ic_customer_back"), for: UIControlState.normal)
            button.addTarget(self, action:#selector(self.callBackMethod), for: UIControlEvents.touchUpInside)
            button.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40) //CGRectMake(0, 0, 40, 40)
            leftButton = UIBarButtonItem.init(customView: button)
        }else{
            let button = UIButton.init(type: .custom)
            button.setImage(UIImage.init(named: "ic_slide_menu"), for: UIControlState.normal)
            button.addTarget(self, action:#selector(self.callMenuMethod), for: UIControlEvents.touchUpInside)
            button.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40) //CGRectMake(0, 0, 40, 40)
            leftButton = UIBarButtonItem.init(customView: button)
        }

        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    func callBackMethod() {
        self.backView()
    }
    
    func callMenuMethod() {
         self.slideMenuController()?.openLeft()
    }
}
