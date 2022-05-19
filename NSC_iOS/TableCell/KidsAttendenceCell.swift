//
//  KidsAttendenceCell.swift
//  NSC_iOS
//
//  Created by Mac Mini on 27/04/22.
//

import UIKit

class KidsAttendenceCell: UITableViewCell {
    
    @IBOutlet weak var viewBack: UIView!
    
    @IBOutlet weak var lblKidName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblGroupName: UILabel!
    
    @IBOutlet weak var btnPresentM: UIButton!
    @IBOutlet weak var btnPresentPL: UIButton!
    
    @IBOutlet weak var btnAbsentM: UIButton!
    @IBOutlet weak var btnAbsentPL: UIButton!
    
    @IBOutlet weak var btnCheckIn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBack.dropShadow()
    }
    
    override func prepareForReuse() {
        btnPresentM.setImage(UIImage(named: "CheckDeselect"), for: .normal)
        btnAbsentM.setImage(UIImage(named: "CheckDeselect"), for: .normal)
        
        btnPresentPL.setImage(UIImage(named: "CheckDeselect"), for: .normal)
        btnAbsentPL.setImage(UIImage(named: "CheckDeselect"), for: .normal)
    }

    // Configure Cell
    func configureCell(data : KidsAttendanceDataModel) {
        lblKidName.text = data.Name
        lblStatus.text = data.CheckIn
        lblGroupName.text = data.Group_Name
        
        if data.Morning_Attendance == "1" {
            btnPresentM.setImage(UIImage(named: "CheckSelect"), for: .normal)
            btnAbsentM.setImage(UIImage(named: "CheckDeselect"), for: .normal)
        } else if data.Morning_Attendance == "0" {
            btnPresentM.setImage(UIImage(named: "CheckDeselect"), for: .normal)
            btnAbsentM.setImage(UIImage(named: "CheckSelect"), for: .normal)
        } else {
            btnPresentM.setImage(UIImage(named: "CheckDeselect"), for: .normal)
            btnAbsentM.setImage(UIImage(named: "CheckDeselect"), for: .normal)
        }
        
        if data.Lunch_Attendance == "1" {
            btnPresentPL.setImage(UIImage(named: "CheckSelect"), for: .normal)
            btnAbsentPL.setImage(UIImage(named: "CheckDeselect"), for: .normal)
        } else if data.Lunch_Attendance == "0" {
            btnPresentPL.setImage(UIImage(named: "CheckDeselect"), for: .normal)
            btnAbsentPL.setImage(UIImage(named: "CheckSelect"), for: .normal)
        } else {
            btnPresentPL.setImage(UIImage(named: "CheckDeselect"), for: .normal)
            btnAbsentPL.setImage(UIImage(named: "CheckDeselect"), for: .normal)
        }
    }
    
}
