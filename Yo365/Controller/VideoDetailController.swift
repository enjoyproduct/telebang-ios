//
//  VideoDetailController.swift
//  Yo365
//
//  Created by Billy on 2/8/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController
import AVFoundation
import AVKit
import XCDYouTubeKit
import RealmSwift

class VideoDetailController: BaseNavController {
    var videoModel: VideoModel? = nil
    
    @IBOutlet var viewPlayer: UIView!
    @IBOutlet var lbInfo: UILabel!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbSeries: UILabel!
    @IBOutlet var lbDescription: UILabel!
    @IBOutlet var imvLike: UIImageView!
    @IBOutlet var lbLike: UILabel!
    
    var favouriteButton:UIBarButtonItem?
    var realm: Realm?
    var videoFavouriteSaved: VideoEntity?
    var youtubePlayer : XCDYouTubeVideoPlayerViewController? = nil
    var avPlayer: AVPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        if(videoModel == nil){
            return
        }
        
        do {
            realm = try Realm()
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
        
        updateTitleHeader(title: (videoModel?.getTitle())!)
        
        initVideoInfo()
        initFavourite()
        requestUpdateCounter(field: .view)
        requestGetLikeStatus()
        initPlayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentView" {
            if let toViewController = segue.destination as? CommentController {
                toViewController.videoModel = videoModel
            }
        }
    }
    
    override func initLeftHeader() {
        addBackButton()
    }
    
    override func initRightHeader() {
        super.initRightHeader()
        favouriteButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_video_favourite"), style: .plain, target: self, action: #selector(self.callFavouriteMethod))
        
        let downloadButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_video_download"), style: .plain, target: self, action: #selector(self.callDownloadMethod))
        
        self.navigationItem.rightBarButtonItems = [downloadButton, favouriteButton!]
    }
    
    func initFavourite(){
        let predicate = NSPredicate.init(format: "userID = %d AND videoID = %d", customerManager.getCustomerID(), (videoModel?.getID())!)
        videoFavouriteSaved = realm?.objects(VideoEntity.self).filter(predicate).first
        
//        let countVideo = self.favouriteStack.fetchCount(From(VideoEntity.self), Where("videoID == %d", videoModel?.getID() ?? 0))
//        
        if(videoFavouriteSaved != nil){
            favouriteButton?.image = UIImage.init(named: "ic_video_favourited")
        }else{
            favouriteButton?.image = UIImage.init(named: "ic_video_favourite")
        }
    }
    
    func initPlayer() {
        let player = videoModel?.getPlayerType()
        if(player == .YOUTUBE){
            initYoutubePlayer()
        }else if(player == .UPLOAD){
            initDefaultPlayer()
        }
    }
    
    func pausePlayer() {
        let player = videoModel?.getPlayerType()
        if(player == .YOUTUBE){
            if(youtubePlayer != nil){
                youtubePlayer?.moviePlayer.pause()
            }
        }else if(player == .UPLOAD){
            if(avPlayer != nil){
                avPlayer?.pause()
            }
        }
    }

    func callFavouriteMethod() {
        if(videoFavouriteSaved != nil){
            videoFavouriteSaved?.delete()
            videoFavouriteSaved = nil
            
            favouriteButton?.image = UIImage.init(named: "ic_video_favourite")
        }else{
            videoFavouriteSaved = VideoEntity()
            videoFavouriteSaved?.videoID = (videoModel?.getID())!
            videoFavouriteSaved?.videoName = (videoModel?.getTitle())!
            videoFavouriteSaved?.videoThumbnail = (videoModel?.getThumbnail())!
            videoFavouriteSaved?.videoSeries = (videoModel?.getSeries())!
            videoFavouriteSaved?.videoCreateAt = (videoModel?.getUpdateAt())!
            videoFavouriteSaved?.userID = customerManager.getCustomerID()
            videoFavouriteSaved?.save()
            
            favouriteButton?.image = UIImage.init(named: "ic_video_favourited")
        }
    }
    
    func callDownloadMethod() {
        
    }
    
    func initVideoInfo() {
        lbTitle.text = videoModel?.getTitle()
        lbSeries.text = videoModel?.getSeries()
        
        var moreInfo = String.init(format: "%@ &#8226; %@", (videoModel?.getUpdateAt())!, (videoModel?.getViewCounterFormat())!)
        let aux = "<span style=\"font-family: Helvetica; line-height: 1.5;color: #8F8E94; font-size: 13\">%@</span>"
        moreInfo = String.init(format: aux, moreInfo)
        lbInfo.attributedText = AppUtil.stringFromHtml(string: moreInfo)
        
        let fmDescription = "<span style=\"font-family: Helvetica; line-height: 1.5;color: #555555; font-size: 13\">%@</span>"
        let description = String.init(format: fmDescription, (videoModel?.getDescription())!)
        lbDescription.attributedText = AppUtil.stringFromHtml(string: description)
    }
    
    func initDefaultPlayer(){
        let videoPath = videoModel?.getVideoPath()
        let videoUrl: URL = URL.init(string: videoPath!)!
        
        avPlayer = AVPlayer(url: videoUrl)
        let playerController = AVPlayerViewController()
        
        playerController.player = avPlayer
        self.addChildViewController(playerController)
        self.viewPlayer.addSubview(playerController.view)
        playerController.view.frame = self.viewPlayer.frame
        
        avPlayer?.play()
    }
    
    func initYoutubePlayer(){
        let youtubeID = getYoutubeId(youtubeUrl: (videoModel?.getVideoPath())!)
        youtubePlayer = XCDYouTubeVideoPlayerViewController(videoIdentifier: youtubeID)
  
        youtubePlayer?.present(in: viewPlayer)
        youtubePlayer?.moviePlayer.play()
    }
    
    func getYoutubeId(youtubeUrl: String) -> String? {
        return URLComponents(string: youtubeUrl)?.queryItems?.first(where: { $0.name == "v" })?.value
    }
    
    func updateLikeState(isLiked: Bool) {
        if(isLiked){
            imvLike.isHighlighted = true
            lbLike.isHighlighted = true
            lbLike.text = "Liked"
        }else{
            imvLike.isHighlighted = false
            lbLike.isHighlighted = false
            lbLike.text = "Like"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doLike(_ sender: UITapGestureRecognizer) {
        requestLikeVideo()
    }
    
    @IBAction func doShare(_ sender: UITapGestureRecognizer) {
        displayShareSheet(shareContent: (videoModel?.getShareContent())!)
    }
    
    @IBAction func doComment(_ sender: UITapGestureRecognizer) {
        pausePlayer()
        performSegue(withIdentifier: "CommentView", sender: self)
    }
    
    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    func requestUpdateCounter(field: VideoCounterField) {
        ApiClient.updateVideosCounter(field: field.rawValue, videoID: (videoModel?.getID())!, errorHandler: { (message: String) in
            
        }, successHandler: {
            
        })
    }
    
    func requestLikeVideo() {
        ApiClient.updateUserLikeVideo(customerID: customerManager.getCustomerID(), videoID: (videoModel?.getID())!, errorHandler: { (msg: String) in
            self.showMessage(title: "Error", msg: msg)
        }, successHandler: { (response: LikeStatusResponse) in
            if(response.action?.lowercased() == "liked"){
                self.updateLikeState(isLiked: true)
            }else{
                self.updateLikeState(isLiked: false)
            }
        })
    }
    
    func requestGetLikeStatus() {
        self.updateLikeState(isLiked: false)
        
        if(!customerManager.isLogin()){
            return
        }

        ApiClient.getLikeVideoStatus(customerID: customerManager.getCustomerID(), videoID: (videoModel?.getID())!, errorHandler: { (msg: String) in
            self.updateLikeState(isLiked: false)
        }, successHandler: { (response: LikeStatusResponse) in
            if(response.action?.lowercased() == "liked"){
                self.updateLikeState(isLiked: true)
            }else{
                self.updateLikeState(isLiked: false)
            }
        })
    }
}
