//
//  ChannelCell.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 11/17/15.
//  Copyright © 2015 IVET. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var channelState: UISwitch!
    var groupIndex:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let fontSize = channelName.font.pointSize
        channelName.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize)
        
        channelState.addTarget(self, action: Selector("channelStateChanged:"), forControlEvents: UIControlEvents.ValueChanged)


    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func channelStateChanged(switchState: UISwitch) {
        
        if switchState.on {
            switch(groupIndex!) {
            case 0:
                UserSettings.sharedInstance.RelayForLife = true
            case 1:
                UserSettings.sharedInstance.ACappella = true
            case 2:
                UserSettings.sharedInstance.MemorialHall = true
            case 3:
                UserSettings.sharedInstance.BlackStudentMovement = true
            case 4:
                UserSettings.sharedInstance.CUAB = true
            case 5:
                UserSettings.sharedInstance.FreeFood = true
            case 6:
                UserSettings.sharedInstance.CampusY = true
            case 7:
                UserSettings.sharedInstance.ClubSports = true
            case 8:
                UserSettings.sharedInstance.BarEvents = true
            case 9:
                UserSettings.sharedInstance.CAA = true
            default:
                print("\nshould never get here line 82 channel cell\n")
            }
        }
        else {
            switch(groupIndex!) {
            case 0:
                UserSettings.sharedInstance.RelayForLife = false
            case 1:
                UserSettings.sharedInstance.ACappella = false
            case 2:
                UserSettings.sharedInstance.MemorialHall = false
            case 3:
                UserSettings.sharedInstance.BlackStudentMovement = false
            case 4:
                UserSettings.sharedInstance.CUAB = false
            case 5:
                UserSettings.sharedInstance.FreeFood = false
            case 6:
                UserSettings.sharedInstance.CampusY = false
            case 7:
                UserSettings.sharedInstance.ClubSports = false
            case 8:
                UserSettings.sharedInstance.BarEvents = false
            case 9:
                UserSettings.sharedInstance.CAA = false
            default:
                print("\nshould never get here line 56 channel cell\n")
            }

        }
    }
    

}
