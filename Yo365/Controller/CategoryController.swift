//
//  CategoryController.swift
//  Yo365
//
//  Created by Billy on 2/7/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class CategoryController: BaseTabController{
    @IBOutlet var tableView: UITableView!
    var listCategoies: Array<VideoCategoryJSON> = []
    let cellIdentifier = "CategoryViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTitleHeader(title: "Categories")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        requestGetCategories()
    }
    
    func requestGetCategories() {
        ApiClient.getVideoCategories(errorHandler: { (message: String) in
            
        }) { (response: VideoCategoryResponseJSON) in
            self.listCategoies += response.allcategories!
            self.tableView.reloadData()
        }
    }
}

extension CategoryController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCategoies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CategoryViewCell
        cell.selectionStyle = .none
        let row = indexPath.row
        cell.updateView(model: listCategoies[row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {       
        let nav = storyboard?.instantiateViewController(withIdentifier: "VideosByCategory") as!
        UINavigationController
        let vc = nav.topViewController as! VideoListByCategoryController
        vc.categoryModel = listCategoies[indexPath.row]
        present(nav, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        highlightCell(indexPath: indexPath, flag: true)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        highlightCell(indexPath: indexPath, flag: false)
    }
    
    func highlightCell(indexPath : IndexPath, flag: Bool) {
        
        let cell = self.tableView.cellForRow(at: indexPath) as! CategoryViewCell
        
        if flag {
            cell.bgrViewHover.alpha = 1
        } else {
            cell.bgrViewHover.alpha = 0
        }
    }
}
