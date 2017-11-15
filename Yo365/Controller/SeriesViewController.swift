//
//  SeriesViewController.swift
//  teleBang
//
//  Created by Admin on 11/14/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Kingfisher

class SeriesViewController: BaseNavController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var btnOnAir: UIButton!
    @IBOutlet weak var btnMostView: UIButton!
    @IBOutlet weak var viewOnAir: UIView!
    @IBOutlet weak var viewMostView: UIView!
    
    var listSeries: Array<SeriesJSON> = []
    var isCompleted = 0
    var pageNumber = 1
    var isLoadMore: Bool = true
    var refreshControl: UIRefreshControl!
    
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateTitleHeader(title: "Series")
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        collectionView.addSubview(refreshControl)
        
        requestGetSeries()
    }
    func refresh(sender:AnyObject) {
        self.pageNumber = 1
        self.isLoadMore = true
        requestGetSeries()
    }
    @IBAction func onClickAir(_ sender: Any) {
        self.isCompleted = 0
        self.btnOnAir.setTitleColor(colorPrimary, for: .normal)
        self.btnMostView.setTitleColor(UIColor.darkGray, for: .normal)
        self.viewOnAir.backgroundColor = colorPrimary
        self.viewMostView.backgroundColor = UIColor.darkGray
        
        self.refresh(sender: sender as AnyObject)
    }
    @IBAction func onClickMostView(_ sender: Any) {
        self.isCompleted = 1
        self.btnOnAir.setTitleColor(UIColor.darkGray, for: .normal)
        self.btnMostView.setTitleColor(colorPrimary, for: .normal)
        self.viewOnAir.backgroundColor = UIColor.darkGray
        self.viewMostView.backgroundColor = colorPrimary
        
        self.refresh(sender: sender as AnyObject)
    }
    func requestGetSeries() {
        if(pageNumber == 1){
            listSeries.removeAll()
            collectionView.reloadData()
        }
        let url = String(format: RELATIVE_URL_GET_SERIES, isCompleted, pageNumber, LIMIT_SERIES_LIST)
        ApiClient.getVideoSeries(url: url, errorHandler: { (message: String) in
            self.refreshControl.endRefreshing()
        }) { (response: Array<SeriesJSON>) in
            self.refreshControl.endRefreshing()
            if(response.count < LIMIT_SERIES_LIST){
                self.isLoadMore = false
            }
            self.listSeries = response
            self.collectionView.reloadData()
            self.pageNumber += 1
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SeriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listSeries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(isLoadMore && indexPath.row == listSeries.count-1){
            requestGetSeries()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeriesCollectionViewCell", for: indexPath) as! SeriesCollectionViewCell
        let seriesJSON = self.listSeries[indexPath.row]
        cell.lblName.text = seriesJSON.title
        
        let urlThumbnail = URL(string: seriesJSON.thumbnail!)!
        cell.imageView.kf.setImage(with: urlThumbnail, placeholder: Image.init(named: "no_image_default"), options: nil, progressBlock: nil, completionHandler: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nav = storyboard?.instantiateViewController(withIdentifier: "SeriesVideoList") as! UINavigationController
        let vc = nav.topViewController as! VideoListBySeriesViewController
        vc.seriesJSON = self.listSeries[indexPath.row]
        present(nav, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 140)
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
    
}
