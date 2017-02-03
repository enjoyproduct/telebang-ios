//
//  SlideMenuCell.swift
//  Yo365
//
//  Created by Billy on 2/3/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit

class SlideMenuCell: UITableViewCell {
    @IBOutlet var imvIcon: UIImageView!
    @IBOutlet var lbTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView(element : SlideMenuElement) {
        imvIcon.image = UIImage.init(named: element.icon)
        lbTitle.text = element.title
    }
}
