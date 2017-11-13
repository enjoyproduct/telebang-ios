//
//  SubscriptionHistoryTableViewCell.swift
//  teleBang
//
//  Created by Admin on 5/23/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class SubscriptionHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblCardNumber: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
