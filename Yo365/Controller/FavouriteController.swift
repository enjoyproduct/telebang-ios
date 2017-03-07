//
//  FavouriteController.swift
//  Yo365
//
//  Created by Billy on 2/7/17.
//  Copyright © 2017 Billy. All rights reserved.
//
import UIKit
import RealmSwift

class FavouriteController: BaseTabController{
    @IBOutlet var tableView: UITableView!
    var pageNumber:Int = 1
    var listVideo: Array<VideoEntity> = []
    let cellIdentifier = "FavouriteViewCell"
    
    let cellSpacingHeight: CGFloat = 15
//    var isLoadMore: Bool = true
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTitleHeader(title: "Favourite")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)

        tableView.register(UINib(nibName: "FavouriteViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestGetVideos()
    }
    
    func refresh(sender:AnyObject) {
        self.pageNumber = 1
//        self.isLoadMore = true
        requestGetVideos()
    }
    
    func requestGetVideos() {
        do {
            let realm = try Realm()
            let data = realm.objects(VideoEntity.self)
            print(data)
            
            self.listVideo.removeAll()
            for model in data {
                self.listVideo.append(model)
            }
            self.tableView.reloadData()
            
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
}

extension FavouriteController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return listVideo.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if(isLoadMore && indexPath.section == listVideo.count-1){
//            requestGetVideos()
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FavouriteViewCell
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let videoCell = cell as! FavouriteViewCell
        videoCell.updateView(model: listVideo[indexPath.section])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        requestGetVideo(id: listVideo[indexPath.section].videoID)
    }
    
    func requestGetVideo(id: Int){
        showLoading(msg: "Please wait while the content loads")
        ApiClient.getVideosByID(videoID: id, errorHandler: { (msg) in
            self.hideLoading()
            self.showMessage(title: "Error", msg: msg)
        }, successHandler: { (model: VideoResponseJSON) in
            self.hideLoading()
            let nav = self.storyboard?.instantiateViewController(withIdentifier: "VideoDetailScreen") as!
            UINavigationController
            let vc = nav.topViewController as! VideoDetailController
            vc.videoModel = VideoModel.init(videoJSON: model)
            self.present(nav, animated: true, completion: nil)

        })
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        highlightCell(indexPath: indexPath, flag: true)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        highlightCell(indexPath: indexPath, flag: false)
    }
    
    func highlightCell(indexPath : IndexPath, flag: Bool) {
        
        let cell = self.tableView.cellForRow(at: indexPath) as! FavouriteViewCell
        
        if flag {
            cell.bgrViewHover.alpha = 1
        } else {
            cell.bgrViewHover.alpha = 0
        }
    }
}
