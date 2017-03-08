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
    
    func onChangeProfileSuccessfully(customer: CustomerResponse) {
        self.customerModel = customer;
    }
    
    func onChangePasswordSuccessfully(password: String) {
        preferences.set(password, forKey: KEY_PASSWORD)
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
    
    func getFullName() -> String {
        var fullname: String = "";
        if(customerModel.firstName != nil && !(customerModel.firstName?.isEmpty)!){
            fullname += customerModel.firstName!
        }
        
        if(customerModel.lastName != nil && !(customerModel.lastName?.isEmpty)!){
            fullname = fullname+" "+customerModel.lastName!
        }
        
        if(fullname.isEmpty){
            fullname = customerModel.username!
        }
        
        return fullname
    }
    
    func getCustomerAvatar() -> String {
        if(customerModel.avatar == nil){
            return ""
        }
        
        return customerModel.avatar!
    }
    
    func getCustomerID() -> Int {
        if(!isLogin()){
            return 0
        }
        
        return customerModel.id!
    }
    
    func isPremiumAccount() -> Bool {
        if(loginStatus == .NotLogin){
            return false
        }
        
        return customerModel.vip == 1;
    }
    
    func isLogin() -> Bool {
        if(loginStatus == .NotLogin){
            return false
        }
        
        return true;
    }
}
