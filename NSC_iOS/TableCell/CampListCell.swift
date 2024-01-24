//
//  CampListCell.swift
//  NSC_iOS
//
//  Created by Mac Mini on 27/04/22.
//

import UIKit


class CampHeaderTbleCell : UITableViewCell{
    
    @IBOutlet weak var lblTitle : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.applyLabelStyle(fontSize: 16.0, fontName: .SFProDisplaySemibold)
    }
    
    func configureDataHeaderCell(with data : MainCampDetailModel){
        
        self.lblTitle.text = data.title
    }
}

class CampListCell: UITableViewCell {
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblCampDesc: UILabel!
    @IBOutlet weak var lblCampLocation: UILabel!
    @IBOutlet weak var lblCampTitle: UILabel!
    @IBOutlet weak var imgCamp: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgCamp.layer.cornerRadius = 12.0
        
        self.lblCampTitle.applyLabelStyle(fontSize: 13.0, fontName: .SFProDisplaySemibold)
        self.lblCampLocation.applyLabelStyle(fontSize: 10.0, fontName: .SFProDisplayRegular, textColor: .colorAppTextBlack)
        self.lblCampDesc.applyLabelStyle(fontSize: 10.0, fontName: .SFProDisplayRegular, textColor: .colorAppTextBlack)
        self.lblCampDesc.numberOfLines = 3
        viewBack.dropShadow(shadowRadius : 5)
    }
    
    // Configure Cell
    func configureCell(data : CampDetailModel?,listType : String) {
        
        guard let indexdata = data else {return}
        self.lblCampTitle.text = indexdata.CampName
        
        self.lblCampDesc.text = indexdata.CampDetail
        self.lblCampLocation.text = indexdata.CampAddress
        
        if let strUrl = indexdata.CampImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imgUrl = URL(string: strUrl) {

            imgCamp.sd_setImage(with: imgUrl)
        }
        
        if listType == kCurrentCamp{
            self.viewBack.dropShadow(shadowRadius : 15)
        }
        else{
            self.viewBack.applyBorderView()
        }
    }
    
}
