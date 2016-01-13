//
//  shadowedButton.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 11/2/15.
//  Copyright © 2015 IVET. All rights reserved.
//

import UIKit
import Foundation

class shadowedButton: UIButton {
    
    deinit {
        print("deinit")
    }
    
    required override internal init(frame: CGRect) {
        super.init(frame: frame)
        configureButtonStyles()
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureButtonStyles()
    }
    

    func configureButtonStyles() {
        
        let fontSize = self.titleLabel?.font.pointSize
        self.titleLabel?.font = UIFont(name: "BoosterNextFY-Medium", size: fontSize!)
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 6
        self.layer.shadowOffset = CGSizeMake(2, 2)
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 1.0
    }


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
