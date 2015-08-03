//
//  DimView.swift
//  SyllaSync
//
//  Created by Joel Wasserman on 8/3/15.
//  Copyright (c) 2015 IVET. All rights reserved.
//

import Foundation

class DimView: UIView {
    
    var loadingIndicator:UIActivityIndicatorView?
    
    deinit {
        println("deinit")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadingIndicator = UIActivityIndicatorView()
        loadingIndicator?.activityIndicatorViewStyle = .WhiteLarge
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        loadingIndicator!.center = CGPointMake(frame.width/2, frame.height/2)
        loadingIndicator!.startAnimating()
        self.addSubview(loadingIndicator!)
        self.bringSubviewToFront(loadingIndicator!)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
