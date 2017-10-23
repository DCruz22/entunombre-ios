//
//  VideoListCell.swift
//  entunombre
//
//  Created by Eury Perez on 10/18/17.
//  Copyright © 2017 Dulce Refugio. All rights reserved.
//

import UIKit

class VideoListCell: UITableViewCell {
    
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var ivPicture: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbNameWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
