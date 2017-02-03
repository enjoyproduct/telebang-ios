//
//  File.swift
//  Yo365
//
//  Created by Billy on 1/19/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import SwiftOverlays

class BaseController: UIViewController{
    func backView() {
        guard navigationController?.popViewController(animated: true) != nil else { //modal
            print("Not a navigation Controller")
            dismiss(animated: true, completion: nil)
            return
        }
    }
    
    func backToRoot() {
        guard navigationController?.popToRootViewController(animated: true) != nil
            else {
                print("No Navigation Controller")
                return
        }
    }

    func switchToViewController(identifier: String) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: identifier) else {
            print("View controller not found")
            return
        }
        
        switchToViewController(viewController: vc)
    }
    
    func switchToViewController(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true )
    }
    
    func showMessage(title: String, msg: String) {
        showMessage(title: title, msg: msg, handler: nil)
    }
    
    func showMessage(title: String, msg: String, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLoading() {
        showLoading(msg: "");
    }
    
    func showLoading(msg: String) {
        if(msg.isEmpty){
            self.showWaitOverlay()
        }else{
            self.showWaitOverlayWithText(msg)
        }
    }
    
    func hideLoading(){
        self.removeAllOverlays()
    }
}
