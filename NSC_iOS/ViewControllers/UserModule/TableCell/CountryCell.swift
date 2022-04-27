//
//  CountryCell.swift
//  BWS
//
//  Created by Sapu on 13/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    // MARK: - OUTLETS
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lblCountryName : UILabel!
    @IBOutlet weak var lblCountryCode : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
