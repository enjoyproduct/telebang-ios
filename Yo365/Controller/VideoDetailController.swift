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

class VideoDetailController: BaseSlideController {
    var videoModel: VideoModel? = nil
    
    @IBOutlet var viewPlayer: UIView!
    @IBOutlet var lbInfo: UILabel!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbSeries: UILabel!
    @IBOutlet var lbDescription: UITextView!
    @IBOutlet var imvLike: UIImageView!
    @IBOutlet var lbLike: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
        if(videoModel == nil){
            return
        }
        
        updateTitleHeader(title: (videoModel?.getTitle())!)
        
        initVideoInfo()
        requestUpdateCounter(field: .view)
        requestGetLikeStatus()
        initPlayer()
    }
    
    override func initRightHeader() {
        super.initRightHeader()
        let favouriteButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_video_favourite"), style: .plain, target: self, action: #selector(self.callFavouriteMethod))
        
        let downloadButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_video_download"), style: .plain, target: self, action: #selector(self.callDownloadMethod))
        
        self.navigationItem.rightBarButtonItems = [downloadButton, favouriteButton]
    }
    
    func initPlayer() {
        let player = videoModel?.getPlayerType()
        if(player == .YOUTUBE){
            initYoutubePlayer()
        }else if(player == .UPLOAD){
            initDefaultPlayer()
        }
    }
    
    func callFavouriteMethod() {
        
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
        
        let player = AVPlayer(url: videoUrl)
        let playerController = AVPlayerViewController()
        
        playerController.player = player
        self.addChildViewController(playerController)
        self.viewPlayer.addSubview(playerController.view)
        playerController.view.frame = self.viewPlayer.frame
        
        player.play()
    }
    
    func initYoutubePlayer(){
        let youtubeID = getYoutubeId(youtubeUrl: (videoModel?.getVideoPath())!)
        let vidplayer : XCDYouTubeVideoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: youtubeID)
  
        vidplayer.present(in: viewPlayer)
        vidplayer.moviePlayer.play()
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "CommentScreen") as! CommentController
        vc.videoModel = videoModel
        switchToViewController(viewController: vc)
    }
    
    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    func requestUpdateCounter(field: VideoCounterField) {
        ApiClient.updateVideosCounter(field: field.rawValue, videoID: (videoModel?.getID())!, errorHandler: { (message: String) in
            
        }, successHandler: {
            self.updateLikeState(isLiked: true)
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
        if(!customerManager.isLogin()){
            self.updateLikeState(isLiked: false)
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
