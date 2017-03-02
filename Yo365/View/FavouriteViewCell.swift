//
//  FavouriteViewCell.swift
//  Yo365
//
//  Created by Billy on 3/2/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Kingfisher

class FavouriteViewCell: UITableViewCell {
    @IBOutlet var bgrViewHover: UIView!
    @IBOutlet var imvThumbnail: UIImageView!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbSeries: UILabel!
    @IBOutlet var lbCreateAt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView(model : VideoEntity) {
        lbTitle.text = model.videoName
        
        let urlThumbnail = URL(string: model.videoThumbnail)
        imvThumbnail.kf.setImage(with: urlThumbnail, placeholder: Image.init(named: "no_image_default"), options: nil, progressBlock: nil, completionHandler: nil)
        
        lbSeries.text = model.videoSeries
        lbCreateAt.text = model.videoCreateAt
    }
}
