//
//  DayListCell.swift
//  NSC_iOS
//
//  Created by Dhruvit on 17/05/22.
//

import UIKit

class DayListCell: UITableViewCell {
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBack.dropShadow()
    }
    
}
