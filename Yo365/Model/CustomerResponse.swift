//
//  CustomerModel.swift
//  Yo365
//
//  Created by Billy on 1/19/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import ObjectMapper

class CustomerResponse: Mappable {
    var id: Int?
    var email: String?
    var username: String? = ""
    var avatar: String? = ""
    var firstName: String? = ""
    var lastName: String? = ""
    var phone: String? = ""
    var address: String?
    var city: String?
    var country: String?
    var zip: String?
    var vip: Int?
    var paystack_auth_code : String?
    var subscribed_date: Int?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id              <- map["id"]
        email           <- map["email"]
        username        <- map["username"]
        avatar          <- map["avatar"]
        firstName       <- map["firstname"]
        lastName        <- map["lastname"]
        phone           <- map["phone"]
        address         <- map["address"]
        city            <- map["city"]
        country         <- map["country"]
        zip             <- map["zip"]
        vip             <- map["vip"]
        var time: String?
        time            <- map["subscribed_date"]
        subscribed_date = Int(time!)
        paystack_auth_code    <- map["paystack_auth_code"]
        
    }
}

