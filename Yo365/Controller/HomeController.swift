//
//  HomeController.swift
//  Yo365
//
//  Created by Billy on 1/21/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class HomeController: BaseSlideController{
    var pageNumber:Int = 1
    var listVideo: Array<VideoModel> = []
    let cellIdentifier = "GridVideoCell"
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    var isLoadMore: Bool = true
    var refreshControl: UIRefreshControl!
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTitleHeader(title: "Yo365")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        collectionView.addSubview(refreshControl)
        
        requestGetVideos()
    }
    
    override func initRightHeader() {
        super.initRightHeader()
        let rightButton = UIBarButtonItem.init(image: UIImage.init(named: "ic_search"), style: .plain, target: self, action: #selector(self.callSearchMethod))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func callSearchMethod() {
        performSegue(withIdentifier: "SearchView",
                     sender: self)
    }

    func refresh(sender:AnyObject) {
        self.pageNumber = 1
        self.isLoadMore = true
        requestGetVideos()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestGetVideos() {
        if(pageNumber == 1){
            listVideo.removeAll()
            collectionView.reloadData()
        }
        
        ApiClient.getVideosLatest(pageNumber: pageNumber, errorHandler: { (message: String) in
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
            self.collectionView.reloadData()
        }
    }
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listVideo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(isLoadMore && indexPath.row == listVideo.count-1){
            requestGetVideos()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GridVideoViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let videoCell = cell as! GridVideoViewCell
        videoCell.updateView(model: listVideo[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "VideoDetailScreen") as! VideoDetailController
        vc.videoModel = listVideo[indexPath.row]
        switchToViewController(viewController: vc)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 154)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        highlightCell(indexPath: indexPath, flag: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        highlightCell(indexPath: indexPath, flag: false)
    }
    func highlightCell(indexPath : IndexPath, flag: Bool) {
        
        let cell = self.collectionView.cellForItem(at: indexPath) as! GridVideoViewCell
        
        if flag {
            cell.bgrViewHover.alpha = 1
        } else {
            cell.bgrViewHover.alpha = 0
        }
    }
}
