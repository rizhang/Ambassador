//
//  PagesTableViewCell.swift
//  Ambassador
//
//  Created by Richard Zhang on 4/28/15.
//  Copyright (c) 2015 Richard Zhang. All rights reserved.
//

import UIKit

class PagesTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
