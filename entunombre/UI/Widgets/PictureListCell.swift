//
//  PictureListCell.swift
//  entunombre
//
//  Created by Eury Perez on 10/1/17.
//  Copyright © 2017 Dulce Refugio. All rights reserved.
//

import UIKit

class PictureListCell: UITableViewCell {

    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var ivPicture: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
