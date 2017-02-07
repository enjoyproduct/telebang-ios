//
//  CategoryViewCell.swift
//  Yo365
//
//  Created by Billy on 2/7/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryViewCell: UITableViewCell {
    @IBOutlet var bgrViewHover: UIView!
    @IBOutlet var imvThumbnail: UIImageView!
    @IBOutlet var lbTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView(model : VideoCategoryJSON) {
        lbTitle.text = model.name
        
        let urlThumbnail = URL(string: model.icon!)!
        imvThumbnail.kf.setImage(with: urlThumbnail, placeholder: Image.init(named: "no_image_default"), options: nil, progressBlock: nil, completionHandler: nil)
    }
}
