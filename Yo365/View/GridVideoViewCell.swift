//
//  GridVideoCell.swift
//  Yo365
//
//  Created by Billy on 2/6/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Kingfisher

class GridVideoViewCell: UICollectionViewCell {
    @IBOutlet var imvThumbnail: UIImageView!
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet var lbSeries: UILabel!
    @IBOutlet var lbUpdateAt: UILabel!
    @IBOutlet var lbViewCounter: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateView(model : VideoModel) {
        lbTitle.text = model.getTitle()
        
        let urlThumbnail = URL(string: model.getThumbnail())!
        imvThumbnail.kf.setImage(with: urlThumbnail, placeholder: Image.init(named: "no_image_default"), options: nil, progressBlock: nil, completionHandler: nil)
        
        lbSeries.text = model.getSeries()
        lbUpdateAt.text = model.getUpdateAt()
        lbViewCounter.text = model.getViewCounterFormat()
    }
}
