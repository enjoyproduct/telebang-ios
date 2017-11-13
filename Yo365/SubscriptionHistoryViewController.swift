//
//  SubscriptionHistoryViewController.swift
//  teleBang
//
//  Created by Admin on 5/23/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class SubscriptionHistoryViewController: BaseNavController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var arrSubscription = [SubscriptionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         updateTitleHeader(title: "Subscription History")
        getSubscriptions()
    }
    func getSubscriptions()  {
        if !customerManager.isLogin() {
            return
        }
        showLoading()
        ApiClient.getSubscriptions(accountID: customerManager.getCustomerID(), errorHandler: { (errorString) in
            self.hideLoading()
            self.showMessage(title: "Error", msg: errorString)
            
        }) { (arraySubscriptions) in
            self.hideLoading()
            self.arrSubscription = arraySubscriptions
            self.tableView.reloadData()
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

    //MARK: UITableView 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSubscription.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionHistoryTableViewCell") as! SubscriptionHistoryTableViewCell
        let subscription = self.arrSubscription[indexPath.row]
        cell.lblAmount.text = subscription.amount
        cell.lblCardNumber.text = subscription.cardNumber
        cell.lblTime.text = AppUtil.getDateFromTimestamp(timestamp: subscription.time!)
        return cell
    }
}
