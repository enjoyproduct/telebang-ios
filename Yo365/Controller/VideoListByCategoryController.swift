//
//  VideoListByCategoryController.swift
//  Yo365
//
//  Created by Billy on 2/21/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class VideoListByCategoryController: BaseTabController {
    @IBOutlet var tableView: UITableView!
    var pageNumber:Int = 1
    var listVideo: Array<VideoModel> = []
    let cellIdentifier = "VideoViewCell2"
    
    let cellSpacingHeight: CGFloat = 15
    var isLoadMore: Bool = true
    
    var categoryModel: VideoCategoryJSON? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(categoryModel == nil){
            return
        }
        
        updateTitleHeader(title: (categoryModel?.name!)!)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "VideoViewCell2", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        showLoading(msg: "Please wait while the content loads")
        requestGetVideos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func requestGetVideos() {
        if(pageNumber == 1){
            listVideo.removeAll()
            self.tableView.reloadData()
        }
        
        ApiClient.getListVideoByCategory(catID: (categoryModel?.id)!, pageNumber: pageNumber, errorHandler: { (message: String) in
            self.hideLoading()
        }) { (data: Array<VideoResponseJSON>) in
            self.hideLoading()
            
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

extension VideoListByCategoryController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return listVideo.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(isLoadMore && indexPath.section == listVideo.count-1){
            requestGetVideos()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! VideoViewCell2
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let videoCell = cell as! VideoViewCell2
        videoCell.updateView(model: listVideo[indexPath.section])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "VideoDetailScreen") as! VideoDetailController
        vc.videoModel = listVideo[indexPath.section]
        switchToViewController(viewController: vc)
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
        
        let cell = self.tableView.cellForRow(at: indexPath) as! VideoViewCell2
        
        if flag {
            cell.bgrViewHover.alpha = 1
        } else {
            cell.bgrViewHover.alpha = 0
        }
    }
}
