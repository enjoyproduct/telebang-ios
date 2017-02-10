//
//  CommentViewCell.swift
//  Yo365
//
//  Created by Billy on 2/9/17.
//  Copyright © 2017 Billy. All rights reserved.
//

import UIKit
import Kingfisher

class CommentViewCell: UITableViewCell {
    @IBOutlet var imvAvatar: UIImageView!
    @IBOutlet var lbUsername: UILabel!
    @IBOutlet var lbCreateAt: UILabel!
    @IBOutlet var lbCommentContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateView(model : CommentJSON) {
        imvAvatar.layer.cornerRadius = imvAvatar.frame.size.width / 2;
        imvAvatar.clipsToBounds = true;
        let avatar = model.customerJSON?.avatar
        if(avatar != nil){
            let urlAvatar = URL.init(string: avatar!)
            imvAvatar.kf.setImage(with: urlAvatar, placeholder: Image.init(named: "img_avatar_default"), options: nil, progressBlock: nil, completionHandler: nil)
        }else{
            imvAvatar.image = Image.init(named: "img_avatar_default")
        }
        
        var fullName: String = "";
        fullName = String.init(format: "%@ %@", (model.customerJSON?.firstName)!, (model.customerJSON?.lastName)!)
        
        if(fullName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty){
            fullName = (model.customerJSON?.username)!
        }
        
        lbUsername.text = fullName
        let longTime: Double = Double.init(model.createAt!)!
        let createAt: Date = Date.init(timeIntervalSince1970: longTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        lbCreateAt.text = dateFormatter.string(from: createAt)
        
        lbCommentContent.text = model.commentContent
    }
}
