//
//  EventCell.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/4/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let fontSize = self.eventName.font.pointSize
        eventName.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        eventTime.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        eventDate.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        eventLocation.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
