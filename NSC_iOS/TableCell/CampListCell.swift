//
//  CampListCell.swift
//  NSC_iOS
//
//  Created by Mac Mini on 27/04/22.
//

import UIKit

class CampListCell: UITableViewCell {
    
    @IBOutlet weak var lblCampDesc: UILabel!
    @IBOutlet weak var lblCampLocation: UILabel!
    @IBOutlet weak var lblCampTitle: UILabel!
    @IBOutlet weak var imgCamp: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Configure Cell
    func configureCell(data : CampListDataModel) {
        lblCampTitle.text = data.CampName
        lblCampDesc.text = data.CampDetail
        lblCampLocation.text = data.CampAddress
//        let url = URL(string: data.CampImage ?? "")
//        let data = try? Data(contentsOf: url!) //make sure your image in this url
//        imgCamp.image = UIImage(data: data!)
        
    }
    
}
