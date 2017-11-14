//
//  SeriesVideoTableViewCell.swift
//  teleBang
//
//  Created by Admin on 11/14/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class SeriesVideoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var ivThumbnail: UIImageView!
    
    @IBOutlet weak var lblVideoTitle: UILabel!
    @IBOutlet weak var lblSeriesTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblViews: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
