//
//  FavoriteTableViewCell.swift
//  Sightwalk
//
//  Created by Nigel de Mie on 18/12/15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet var favoriteImageView: UIImageView!
    @IBOutlet var sightTitleLabel: UILabel!
    @IBOutlet var sightDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
