//
//  EmptyView.swift
//  CustomPlacePicker
//
//  Created by Damandeep Kaur on 10/27/17.
//  Copyright © 2017 Damandeep Kaur. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view?.superview?.classForCoder == UITableViewCell.self || view?.superview?.classForCoder == NearbyLocationCell.self{
            return view
        }
        return nil
    }
    

}
