//
//  VideoResponseObject.swift
//  Yo365
//
//  Created by Billy on 2/6/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import ObjectMapper

class VideoResponseJSON: Mappable {
    var id: Int?
    var urlSocial: String?
    var categoryId: Int?
    var series: String?
    var author: String?
    var thumbnail: String?
    var description: String?
    var title: String?
    var updateAt: String?
    var createAt: String?
    var vipPlay: Int?
    var anotherCategoryId: Any?
    var statsCounter: VideoCounterJSON?
    var videoPlayer: VideoPlayerJSON?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        urlSocial           <- map["url_social"]
        categoryId          <- map["category_id"]
        series              <- map["series"]
        author              <- map["author"]
        thumbnail           <- map["url_image"]
        description         <- map["description"]
        title               <- map["title"]
        updateAt            <- map["update_at"]
        createAt            <- map["create_at"]
        vipPlay             <- map["vip_play"]
        anotherCategoryId   <- map["another_category_ids"]
        statsCounter        <- map["stats"]
        videoPlayer         <- map["video"]
    }
}

class VideoCounterJSON: Mappable {
    var viewCounter: Int?
    var shareCounter: Int?
    var likeCounter: Int?
    var downloadCounter: Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        viewCounter         <- map["views"]
        shareCounter        <- map["shares"]
        likeCounter         <- map["likes"]
        downloadCounter     <- map["downloads"]
    }
}

class VideoPlayerJSON: Mappable {
    var path: String?
    var type: String?
    var length: Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        path        <- map["url"]
        type        <- map["type"]
        length      <- map["length"]
    }
}
