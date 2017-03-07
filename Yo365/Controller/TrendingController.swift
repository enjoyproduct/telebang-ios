//
//  FavouriteController.swift
//  Yo365
//
//  Created by Billy on 2/7/17.
//  Copyright © 2017 Billy. All rights reserved.
//
import UIKit

class TrendingController: BaseTabController{
    @IBOutlet var tableView: UITableView!
    var pageNumber:Int = 1
    var listVideo: Array<VideoModel> = []
    let cellIdentifier = "VideoViewCell1"

    var isLoadMore: Bool = true
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTitleHeader(title: "Trending")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 260
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)

        tableView.register(UINib(nibName: "VideoViewCell1", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        requestGetVideos()
    }
    
    func refresh(sender:AnyObject) {
        self.pageNumber = 1
        self.isLoadMore = true
        requestGetVideos()
    }
    
    func requestGetVideos() {
        if(pageNumber == 1){
            listVideo.removeAll()
            self.tableView.reloadData()
        }
        
        ApiClient.getVideosTrending(pageNumber: pageNumber, errorHandler: { (message: String) in
            self.refreshControl.endRefreshing()
            
        }) { (data: Array<VideoResponseJSON>) in
            self.refreshControl.endRefreshing()
            
            if(data.count < LIMIT_VIDEOS_HOMES){
                self.isLoadMore = false
            }
            
            for model in data {
                self.listVideo.append(VideoModel.init(videoJSON: model))
            }
            
            self.pageNumber += 1
            self.tableView.reloadData()
        }
    }
}

extension TrendingController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listVideo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(isLoadMore && indexPath.row == listVideo.count-1){
            requestGetVideos()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! VideoViewCell1
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let videoCell = cell as! VideoViewCell1
        videoCell.updateView(model: listVideo[indexPath.row])
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nav = storyboard?.instantiateViewController(withIdentifier: "VideoDetailScreen") as!
        UINavigationController
        let vc = nav.topViewController as! VideoDetailController
        vc.videoModel = listVideo[indexPath.row]
        present(nav, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        highlightCell(indexPath: indexPath, flag: true)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        highlightCell(indexPath: indexPath, flag: false)
    }
    
    func highlightCell(indexPath : IndexPath, flag: Bool) {
        
        let cell = self.tableView.cellForRow(at: indexPath) as! VideoViewCell1
        
        if flag {
            cell.bgrViewHover.alpha = 1
        } else {
            cell.bgrViewHover.alpha = 0
        }
    }
}
