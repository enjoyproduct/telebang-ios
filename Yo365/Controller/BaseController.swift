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

    func enableTapDismissKeyboar() {
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
    
    func updateMessageLoading(msg: String) {
        self.updateOverlayText(msg)
    }
    
    func hideLoading(){
        self.removeAllOverlays()
    }
}
