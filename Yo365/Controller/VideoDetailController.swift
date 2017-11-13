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
import Kingfisher
import GoogleMobileAds

class VideoDetailController: BaseNavController {
    var videoModel: VideoModel? = nil
    
    @IBOutlet var viewPlayer: UIView!
    @IBOutlet var lbInfo: UILabel!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbSeries: UILabel!
    @IBOutlet var lbDescription: UITextView!
    @IBOutlet var imvLike: UIImageView!
    @IBOutlet var lbLike: UILabel!
    @IBOutlet var imvThumbnail: UIImageView!
    @IBOutlet var bannerView: GADBannerView!
    @IBOutlet var heightAdConstraint: NSLayoutConstraint!
    
    var favouriteButton:UIBarButtonItem?
    var realm: Realm?
    var videoFavouriteSaved: VideoEntity?
    var youtubePlayer : XCDYouTubeVideoPlayerViewController? = nil
    var avPlayer: AVPlayer? = nil
    
    /// The interstitial ad.
    var interstitial: GADInterstitial!
    
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
        
        // load ads
        initAd();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
//        let downloadButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_video_download"), style: .plain, target: self, action: #selector(self.callDownloadMethod))
        
//        self.navigationItem.rightBarButtonItems = [downloadButton, favouriteButton!]
        self.navigationItem.rightBarButtonItems = [favouriteButton!]
    }
    
    func initAd() {
        bannerView.isHidden = !BANNER_AD_ENABLE
        if(BANNER_AD_ENABLE){
            heightAdConstraint.constant = 50
            bannerView.adUnitID = BANNER_AD_UNIT_ID
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
        }else{
            heightAdConstraint.constant = 0
        }
        bannerView.layoutIfNeeded()
        
        if(INTERSTITIAL_AD_ENABLE){
            interstitial = createAndLoadInterstitial()
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitialAd = GADInterstitial(adUnitID: INTERSTITIAL_AD_UNIT_ID)
        interstitialAd.delegate = self
        interstitialAd.load(GADRequest())
        return interstitialAd
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
        if(FULL_SCREEN_PLAYER){
            
        }else{
            let player = videoModel?.getPlayerType()
            if(player == .YOUTUBE){
                initYoutubePlayer()
            }else if(player == .UPLOAD){
                initDefaultPlayer()
            }
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
        
        let urlThumbnail = URL(string: (videoModel?.getThumbnail())!)!
        imvThumbnail.kf.setImage(with: urlThumbnail, placeholder: Image.init(named: "no_image_default"), options: nil, progressBlock: nil, completionHandler: nil)
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
    
    func playYoutube(){
        let youtubeID = getYoutubeId(youtubeUrl: (videoModel?.getVideoPath())!)
        youtubePlayer = XCDYouTubeVideoPlayerViewController(videoIdentifier: youtubeID)
        present(youtubePlayer!, animated: true, completion: nil)
    }
    
    func playDefault(){
        let videoPath = videoModel?.getVideoPath()
        let videoUrl: URL = URL.init(string: videoPath!)!
        
        avPlayer = AVPlayer(url: videoUrl)
        let playerController = AVPlayerViewController()
        
        playerController.player = avPlayer
        self.addChildViewController(playerController)
        
        avPlayer?.play()
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer?.currentItem)
        
        let fullScreenPlayerViewController = AVPlayerViewController()
        fullScreenPlayerViewController.player = avPlayer
        present(fullScreenPlayerViewController, animated: true, completion: nil)
    }
    
    func playerDidFinishPlaying(note:NSNotification){
        dismiss(animated: true, completion: nil)
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
    @IBAction func doPLayVideo(_ sender: UITapGestureRecognizer) {
        if self.checkVIP() {
            self.playVideo()
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionViewController") as! SubscriptionViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    func checkVIP() -> Bool {
        if videoModel?.getVIP() == 0 {
            return true
        } else {
            if !customerManager.isLogin() {
                self.showMessage(title: "Telebang", msg: "Please login")
                return false
            } else {
                let lastSubscribedTime = UserDefaults.standard.integer(forKey: KEY_SUBSCRIBED_DATE)
                let lastSubscribedType = UserDefaults.standard.integer(forKey: KEY_SUBSCRIPTION_TYPE)
                
                let currentTime = Int(Date().timeIntervalSince1970)
                if currentTime - lastSubscribedTime > (3600 * 24 * 30 * countMonth(type: lastSubscribedType)) {
                    return false
                }
                return true
            }
        }
        
    }
    func countMonth(type: Int) -> Int {
        switch (type) {
            case 0:
                return 1;
            case 1:
                return 3;
            case 2:
                return 6;
            case 3:
                return 12;
            default:
                return 1;
        }
    
    }
    func playVideo() {
        let player = videoModel?.getPlayerType()
        if(player == .YOUTUBE){
            playYoutube()
        }else if(player == .UPLOAD){
            playDefault()
        }
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

extension VideoDetailController: GADInterstitialDelegate{
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial loaded successfully")
        ad.present(fromRootViewController: self)
    }
    
    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Fail to receive interstitial")
    }
}
