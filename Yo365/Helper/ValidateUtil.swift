//
//  ValidateUtil.swift
//  Yo365
//
//  Created by Billy on 1/20/17.
//  Copyright © 2017 Billy. All rights reserved.
//
import UIKit

class ValidateUtil {
    static let USERNAME_INVALID_MSG = "Please choose a username between 4-20 characters"
    static let EMAIL_INVALID_MSG = "Email address is not valid"
    static let PASSWORD_INVALID_MSG = "Passwords should be at least 4 characters"
    static let PASSWORD_NOT_MATCH_MSG = "Passwords do not match"
    
    static func isValidUsername(strUsername:String!) -> Bool {
        if((strUsername.characters.count) < 4){
            return false
        }
        
        return true;
    }
    
    static func isValidEmail(emailAddress:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailAddress)
    }
}
