//
//  NearbyLocationCell.swift
//  CustomPlacePicker
//
//  Created by Damandeep Kaur on 10/30/17.
//  Copyright © 2017 Damandeep Kaur. All rights reserved.
//

import UIKit
import Kingfisher

class NearbyLocationCell: UITableViewCell {

    @IBOutlet weak var btnIcon: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!

    
    var item: LocationModel? {
        didSet {
            guard  let item = item else {
                return
            }
            if item.placeId == nil{
                lblName?.text = "Select this location"
                lblAddress?.text = "\(item.latitude ?? 0),\(item.longitude ?? 0)"
                item.icon = "https://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png"
            }
            else{
                lblName.text = item.name ?? ""
                lblAddress.text = item.vicinity ?? ""
                btnIcon.setImage(UIImage.init(contentsOfFile: item.icon ?? ""), for: .normal)
            }

            if let url = URL(string: item.icon ?? ""){
                btnIcon.kf.setImage(with: url, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btnIcon.layer.borderWidth = 2
        btnIcon.layer.borderColor = UIColor.lightGray.cgColor
        btnIcon.layer.cornerRadius = btnIcon.frame.size.width / 2.0
        btnIcon.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
