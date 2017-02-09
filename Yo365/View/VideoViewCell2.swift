//
//  VideoViewCell2.swift
//  Yo365
//
//  Created by Billy on 2/7/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Kingfisher

class VideoViewCell2: UITableViewCell {
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
        var moreInfo = String.init(format: "%@ &#8226; %@", model.getUpdateAt(), model.getViewCounterFormat())
        let aux = "<span style=\"font-family: Helvetica; line-height: 1.5;color: #8F8E94; font-size: 12\">%@</span>"
        moreInfo = String.init(format: aux, moreInfo)
        lbMoreInfo.attributedText = AppUtil.stringFromHtml(string: moreInfo)
    }
    

}
