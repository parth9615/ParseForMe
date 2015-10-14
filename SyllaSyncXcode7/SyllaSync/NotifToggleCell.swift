//
//  NotifToggleCell.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 10/14/15.
//  Copyright © 2015 IVET. All rights reserved.
//

import UIKit

class NotifToggleCell: UITableViewCell {

    @IBOutlet weak var notifName: UILabel!
    @IBOutlet weak var notifToggleSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
