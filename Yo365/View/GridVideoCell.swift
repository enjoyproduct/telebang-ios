//
//  GridVideoCell.swift
//  Yo365
//
//  Created by Billy on 2/6/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class GridVideoCell: UITableViewCell {
    @IBOutlet var imvThumbnail: UIImageView!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbInfo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
