//
//  SubscriptionModel.swift
//  teleBang
//
//  Created by Admin on 5/23/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import ObjectMapper

class SubscriptionModel: Mappable {
    var time: Int?
    var cardNumber: String?
    var amount: String?
    var subscribed_time: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        subscribed_time <- map["time"]
        time = Int(subscribed_time!)
        cardNumber      <- map["card_number"]
        amount          <- map["amount"]
        
    }
}
