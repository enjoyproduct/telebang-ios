//
//  CustomerManager.swift
//  Yo365
//
//  Created by Billy on 2/3/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import Foundation
import UIKit
import FacebookLogin

let customerManager = CustomerManager()

class CustomerManager {
    private var customerModel: CustomerResponse
    private var loginStatus:LoginStatus
    private let preferences = UserDefaults.standard
    
    enum LoginStatus {
        case NotLogin
        case LoginWithSystem
        case LoginWithFacebook
    }
    
    init() {
        customerModel  = CustomerResponse()
        loginStatus = .NotLogin
    }
    
    func saveAuthenticAccount(username: String, password: String) {
        preferences.set(username, forKey: KEY_USERNAME)
        preferences.set(password, forKey: KEY_PASSWORD)
    }
    
    func onLoginSuccessfully(loginStatus: LoginStatus, customer: CustomerResponse) {
        self.loginStatus = loginStatus;
        self.customerModel = customer;
    }
    
    func doLogout() {
        switch loginStatus {
        case .LoginWithSystem:
            preferences.removeObject(forKey: KEY_USERNAME)
            preferences.removeObject(forKey: KEY_PASSWORD)
            break
            
        case .LoginWithFacebook:
            let loginManager = LoginManager()
            loginManager.logOut()
            break
            
        default:
            preferences.removeObject(forKey: KEY_USERNAME)
            preferences.removeObject(forKey: KEY_PASSWORD)
            
            let loginManager = LoginManager()
            loginManager.logOut()
            break
        }
        
        onLogout()
    }
    
    func onLogout() {
        self.loginStatus = .NotLogin
        customerModel  = CustomerResponse()
    }
    
    func getCustomerModel() -> CustomerResponse {
        return customerModel
    }
    
    func getCustomerID() -> Int {
        if(!isLogin()){
            return 0
        }
        
        return customerModel.id!
    }
    
    func isLogin() -> Bool {
        if(loginStatus == .NotLogin){
            return false
        }
        
        return true;
    }
}
