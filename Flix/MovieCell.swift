//
//  MovieCell.swift
//  Flix
//
//  Created by Pavani Malli on 6/21/17.
//  Copyright © 2017 Pavani Malli. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {


    @IBOutlet weak var overviewLabel: UILabel!
   
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
