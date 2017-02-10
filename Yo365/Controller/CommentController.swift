//
//  CommentController.swift
//  Yo365
//
//  Created by Billy on 2/9/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class CommentController: BaseSlideController {
    var videoModel: VideoModel? = nil
    
    @IBOutlet var utfComment: UITextField!
    @IBOutlet var tableView: UITableView!
    var listComment: Array<CommentJSON> = []
    let cellIdentifier = "CommentViewCell"
    var isLoadMore: Bool = true
    var pageNumber:Int = 1
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(videoModel == nil){
            return
        }
        
        updateTitleHeader(title: (videoModel?.getTitle())!)
        
        utfComment.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.register(UINib(nibName: "CommentViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        showLoading(msg: "Please wait while the content loads")
        requestGetComment()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    func refresh(sender:AnyObject) {
        self.pageNumber = 1
        requestGetComment()
    }
    
    @IBAction func doComment(_ sender: UIButton) {
        if(!customerManager.isLogin()){
            showMessage(title: "Error", msg: "You need to login to continue!")
            return
        }
        
        let commentContent = utfComment.text
        if(commentContent?.isEmpty)!{
            showMessage(title: "Error", msg: "Please enter comment content!")
            return
        }
        
        showLoading(msg: "Loading... Please wait")
        ApiClient.postCommentVideo(customerID: customerManager.getCustomerID(), videoID: (videoModel?.getID())!, commentContent: commentContent!, errorHandler: { (msg: String) in
            self.hideLoading()
            self.showMessage(title: "Error", msg: msg)
        }, successHandler: { (response: CommentJSON) in
            self.hideLoading()
            self.utfComment.text = ""
            self.listComment.insert(response, at: 0)
            self.tableView.reloadData()
        })
    }
    
    
    func requestGetComment() {
        if(pageNumber == 1){
            listComment.removeAll()
            self.tableView.reloadData()
        }
        
        ApiClient.getVideoComments(videoID: (videoModel?.getID())!,pageNumber: pageNumber, errorHandler: { (msg: String) in
            self.showMessage(title: "Error", msg: msg)
            self.refreshControl.endRefreshing()
            self.hideLoading()
        }, successHandler: { (response: Array<CommentJSON>) in
            self.refreshControl.endRefreshing()
            self.hideLoading()
            
            if(response.count < LIMIT_COMMENTS_VIDEO){
                self.isLoadMore = false
            }
            
            self.listComment += response
            
            self.pageNumber += 1
            self.tableView.reloadData()
        })
    }
}

extension CommentController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
}

extension CommentController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(isLoadMore && indexPath.section == listComment.count-1){
            requestGetComment()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CommentViewCell
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let commentCell = cell as! CommentViewCell
        commentCell.updateView(model: listComment[indexPath.row])
    }
}
