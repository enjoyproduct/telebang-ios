//
//  VideoResponseObject.swift
//  Yo365
//
//  Created by Billy on 2/6/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import ObjectMapper

class VideoModel{
    enum PlayerType: String {
        case UPLOAD, YOUTUBE, VIMEO, Download, MP3, FACEBOOK, DAILY_MOTION
    }
    
    var videoJSON: VideoResponseJSON
    
    var playerType: PlayerType?
    var videoPath: String?
    var viewCounterFormat: String?
    var series: String?
    
    init(videoJSON: VideoResponseJSON) {
        self.videoJSON = videoJSON
        self.playerType = PlayerType(rawValue: (videoJSON.videoPlayer?.type)!)
        
        if(self.playerType == .FACEBOOK){
            self.videoPath = String.init(format: RELATIVE_URL_PLAY_FACEBOOK, (videoJSON.videoPlayer?.path)!)
        }else if(self.playerType == .VIMEO){
            self.videoPath = String.init(format: RELATIVE_URL_PLAY_VIMEO, (videoJSON.videoPlayer?.path)!)
        }else{
            self.videoPath = videoJSON.videoPlayer?.path
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let strView = formatter.string(from: NSNumber.init(value: (videoJSON.statsCounter?.viewCounter)!))!
        self.viewCounterFormat = String.init(format: "%@ views", strView)
        
        self.series = videoJSON.series
        if(series?.isEmpty)!{
            series = "No Series";
        }
    }
    
    func getThumbnail() -> String {
        return videoJSON.thumbnail!
    }
    
    func getTitle() -> String {
        return videoJSON.title!
    }
    
    func getVideoPath() -> String {
        return videoPath!
    }
    
    func getViewCounterFormat() -> String {
        return viewCounterFormat!
    }
    
    func getUpdateAt() -> String {
        return videoJSON.updateAt!
    }
    
    func getSeries() -> String {
        return series!
    }
}

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
