//
//  SearchController.swift
//  Yo365
//
//  Created by Billy on 2/8/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class SearchController: BaseNavController {
    @IBOutlet var tableView: UITableView!
    var pageNumber:Int = 1
    var listVideo: Array<VideoModel> = []
    let cellIdentifier = "VideoViewCell2"
    var currentKeyword: String = ""
    
    let cellSpacingHeight: CGFloat = 15
    var isLoadMore: Bool = true
    var isRequestSearch: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(UINib(nibName: "VideoViewCell2", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        requestGetVideosMostView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func initHeader() {
        super.initHeader()
    }
    
    override func initLeftHeader() {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Enter your keyword here!"
        searchBar.returnKeyType = .search
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func initRightHeader() {
        
    }
    
    func requestGetVideosMostView() {
        isRequestSearch = false
        if(pageNumber == 1){
            listVideo.removeAll()
            self.tableView.reloadData()
        }
        
        ApiClient.getVideosMostView(pageNumber: pageNumber, errorHandler: { (message: String) in
            self.showMessage(title: "Error", msg: message)
            
        }) { (data: Array<VideoResponseJSON>) in
            self.parseResponseVideo(data: data)
        }
    }
    
    func requestGetVideosByKeyword() {
        isRequestSearch = true
        if(pageNumber == 1){
            listVideo.removeAll()
            self.tableView.reloadData()
        }
        
        ApiClient.getVideosBeyKeyword(keyword: currentKeyword, pageNumber: pageNumber, errorHandler: { (message: String) in
            self.showMessage(title: "Error", msg: message)
            
        }) { (data: Array<VideoResponseJSON>) in
            self.parseResponseVideo(data: data)
        }
    }
    
    func parseResponseVideo(data: Array<VideoResponseJSON>) {
        if(data.count < LIMIT_VIDEOS_SEARCH){
            self.isLoadMore = false
        }
        
        for model in data {
            self.listVideo.append(VideoModel.init(videoJSON: model))
        }
        
        self.pageNumber += 1
        self.tableView.reloadData()
    }
}

extension SearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(searchBar.text?.isEmpty)!{
            self.showMessage(title: "Error", msg: "Please enter keyword!")
            return
        }
        
        if(searchBar.text != currentKeyword){
            self.currentKeyword = searchBar.text!
            self.pageNumber = 1
            requestGetVideosByKeyword()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        backView()
    }
}

extension SearchController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return listVideo.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(isLoadMore && indexPath.section == listVideo.count-1){
            if(isRequestSearch){
                requestGetVideosByKeyword()
            }else{
                requestGetVideosMostView()
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! VideoViewCell2
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let videoCell = cell as! VideoViewCell2
        videoCell.updateView(model: listVideo[indexPath.section])
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 85
//    }
    
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
