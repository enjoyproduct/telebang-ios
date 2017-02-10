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
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        initHeader()
    }
    
    func initHeader() {
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        
        let navBackgroundImage:UIImage! = UIImage.init(named: "bgr_header_slide_menu")
        nav?.setBackgroundImage(navBackgroundImage, for: .default)
    
        initLeftHeader()
        initRightHeader()
    }
    
    func updateTitleHeader(title: String) {
        self.navigationItem.title = title
    }
    
    func initLeftHeader() {
        var leftButton: UIBarButtonItem
        if ((self.navigationController?.viewControllers.count)! > 1) {
            leftButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_customer_back"), style: .plain, target: self, action: #selector(self.callBackMethod))
        }else{
            leftButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_slide_menu"), style: .plain, target: self, action: #selector(self.callMenuMethod))
        }
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    func initRightHeader() {
    }
    
    func callBackMethod() {
        self.backView()
    }
    
    func callMenuMethod() {
         self.slideMenuController()?.openLeft()
    }
}
