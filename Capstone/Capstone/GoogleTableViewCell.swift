//
//  GoogleTableViewCell.swift
//  Capstone
//
//  Created by Xinran Che on 1/14/20.
//  Copyright © 2020 Xinran Che. All rights reserved.
//

import UIKit

class GoogleTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellImage.layer.masksToBounds = true
        cellImage.layer.cornerRadius = cellImage.bounds.width / 2
        cellImage.layer.borderWidth = 1
        cellImage.layer.borderColor = UIColor.gray.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
