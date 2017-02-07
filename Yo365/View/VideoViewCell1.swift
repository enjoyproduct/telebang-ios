//
//  VideoViewCell1.swift
//  Yo365
//
//  Created by Billy on 2/7/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Kingfisher

class VideoViewCell1: UITableViewCell {
    @IBOutlet var bgrViewHover: UIView!
    @IBOutlet var imvThumbnail: UIImageView!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbSeries: UILabel!
    @IBOutlet var lbMoreInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateView(model : VideoModel) {
        lbTitle.text = model.getTitle()
        
        let urlThumbnail = URL(string: model.getThumbnail())!
        imvThumbnail.kf.setImage(with: urlThumbnail, placeholder: Image.init(named: "no_image_default"), options: nil, progressBlock: nil, completionHandler: nil)
        
        lbSeries.text = model.getSeries()
        let moreInfo = String.init(format: "%@ - %@", model.getUpdateAt(), model.getViewCounterFormat())
        lbMoreInfo.text = moreInfo
    }
}
