//
//  VideoListBySeriesViewController.swift
//  teleBang
//
//  Created by Admin on 11/14/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Kingfisher

class VideoListBySeriesViewController: BaseNavController {

    @IBOutlet weak var tableView: UITableView!
    var seriesJSON: SeriesJSON? = nil
    
    var pageNumber:Int = 1
    var listVideo: Array<VideoModel> = []
    let cellIdentifier = "VideoViewCell2"
    let cellSpacingHeight: CGFloat = 15
    var isLoadMore: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(seriesJSON == nil){
            return
        }
        
        updateTitleHeader(title: (seriesJSON?.title)!)
        
        tableView.register(UINib(nibName: "VideoViewCell2", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        showLoading(msg: "Please wait while the content loads")
        requestGetVideos()
    }
    override func initLeftHeader() {
        addBackButton()
    }
    func requestGetVideos() {
        if(pageNumber == 1){
            listVideo.removeAll()
            self.tableView.reloadData()
        }
        let url = String(format: RELATIVE_URL_GET_VIDEO_BY_SERIES, (seriesJSON?.id)!, pageNumber, LIMIT_SERIES_LIST)
        ApiClient.getListVideoBySeries(url: url, errorHandler: { (message: String) in
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension VideoListBySeriesViewController: UITableViewDataSource, UITableViewDelegate{
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
//        videoCell.updateView(model: listVideo[indexPath.section])
        let model = listVideo[indexPath.section]
        videoCell.lbTitle.text = model.getTitle()
        
        let urlThumbnail = URL(string: model.getThumbnail())!
        videoCell.imvThumbnail.kf.setImage(with: urlThumbnail, placeholder: Image.init(named: "no_image_default"), options: nil, progressBlock: nil, completionHandler: nil)
        
        videoCell.lbSeries.text = model.getSeries()
        var moreInfo = String.init(format: "%@ &#8226; %@", model.getUpdateAt(), model.getViewCounterFormat())
        let aux = "<span style=\"font-family: Helvetica; line-height: 1.5;color: #8F8E94; font-size: 12\">%@</span>"
        moreInfo = String.init(format: aux, moreInfo)
        videoCell.lbMoreInfo.attributedText = AppUtil.stringFromHtml(string: moreInfo)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nav = storyboard?.instantiateViewController(withIdentifier: "VideoDetailScreen") as!
        UINavigationController
        let vc = nav.topViewController as! VideoDetailController
        vc.videoModel = listVideo[indexPath.section]
        present(nav, animated: true, completion: nil)
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
