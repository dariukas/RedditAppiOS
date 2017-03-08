//
//  CustomTableViewCell.swift
//  redditApp
//
//  Created by Darius Miliauskas. on 08/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var customLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        if let imageView = self.customImageView as UIImageView! {
//            imageView.frame = CGRect(x: 5.0, y: 0.0, width: 40.0, height: 40.0)
//            imageView.contentMode = UIViewContentMode.scaleAspectFit
            imageView.layer.borderColor = UIColor.black.cgColor
            imageView.layer.borderWidth = 1.0
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
        }
//        self.textLabel?.frame = CGRect(x: 50.0, y: 0.0, width: self.frame.width - 45, height: 20.0)
//        self.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
//        self.textLabel?.numberOfLines = 2
    }
}
