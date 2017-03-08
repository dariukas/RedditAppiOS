//
//  FavoritesTableViewCell.swift
//  redditApp
//
//  Created by Darius Miliauskas on 08/03/2017.
//  Copyright © 2017 Darius Miliauskas. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var customLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        if let imageView = self.customImageView as UIImageView! {
            imageView.layer.borderColor = UIColor.black.cgColor
            imageView.layer.borderWidth = 1.0
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
        }
    }

}
