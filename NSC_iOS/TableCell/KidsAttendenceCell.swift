//
//  KidsAttendenceCell.swift
//  NSC_iOS
//
//  Created by Mac Mini on 27/04/22.
//

import UIKit

class KidsAttendenceCell: UITableViewCell {
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewStatus: UIView!
    
    @IBOutlet weak var lblKidName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblGroupName: UILabel!
    
    @IBOutlet weak var btnPresentM: UIButton!
    @IBOutlet weak var btnPresentPL: UIButton!
    
    @IBOutlet weak var btnAbsentM: UIButton!
    @IBOutlet weak var btnAbsentPL: UIButton!
    
    @IBOutlet weak var btnCheckIn: UIButton!
    
    var didChangeAttendance: (() -> Void)?
    var didClickCheckOut: (() -> Void)?
    
    var kidsData: KidsAttendanceDataModel?
    
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
        self.kidsData = data
        
        lblKidName.text = data.Name
        lblGroupName.text = data.Group_Name
        
        lblStatus.text = data.isFirstTimer == "0" ? "First timer" : ""
        
        DispatchQueue.main.async {
            if data.CheckIn == CheckInStatus.checkIn.rawValue {
                self.viewStatus.backgroundColor = Theme.colors.green_008D36
            } else if data.CheckIn == CheckInStatus.checkOut.rawValue {
                self.viewStatus.backgroundColor = Theme.colors.theme_dark
            } else {
                self.viewStatus.backgroundColor = Theme.colors.yellow_F3DE29
            }
        }
        
        btnPresentM.isUserInteractionEnabled = data.CheckIn == CheckInStatus.checkIn.rawValue
        btnPresentPL.isUserInteractionEnabled = data.CheckIn == CheckInStatus.checkIn.rawValue
        
        btnAbsentM.isUserInteractionEnabled = data.CheckIn == CheckInStatus.checkIn.rawValue
        btnAbsentPL.isUserInteractionEnabled = data.CheckIn == CheckInStatus.checkIn.rawValue
        
        btnCheckIn.isHidden = data.CheckIn != CheckInStatus.checkIn.rawValue
        btnCheckIn.isUserInteractionEnabled = data.CheckIn == CheckInStatus.checkIn.rawValue
        
        if data.Morning_Attendance == AttendanceStatus.present.rawValue {
            btnPresentM.setImage(UIImage(named: "CheckSelect"), for: .normal)
            btnAbsentM.setImage(UIImage(named: "CheckDeselect"), for: .normal)
        } else if data.Morning_Attendance == AttendanceStatus.absent.rawValue {
            btnPresentM.setImage(UIImage(named: "CheckDeselect"), for: .normal)
            btnAbsentM.setImage(UIImage(named: "CheckSelect"), for: .normal)
        } else {
            btnPresentM.setImage(UIImage(named: "CheckDeselect"), for: .normal)
            btnAbsentM.setImage(UIImage(named: "CheckDeselect"), for: .normal)
        }
        
        if data.Lunch_Attendance == AttendanceStatus.present.rawValue {
            btnPresentPL.setImage(UIImage(named: "CheckSelect"), for: .normal)
            btnAbsentPL.setImage(UIImage(named: "CheckDeselect"), for: .normal)
        } else if data.Lunch_Attendance == AttendanceStatus.absent.rawValue {
            btnPresentPL.setImage(UIImage(named: "CheckDeselect"), for: .normal)
            btnAbsentPL.setImage(UIImage(named: "CheckSelect"), for: .normal)
        } else {
            btnPresentPL.setImage(UIImage(named: "CheckDeselect"), for: .normal)
            btnAbsentPL.setImage(UIImage(named: "CheckDeselect"), for: .normal)
        }
    }
    
    @IBAction func morningAttendanceChanged(_ sender: UIButton) {
        if let kidsData = kidsData {
            kidsData.Morning_Attendance = "\(sender.tag)"
        }
        
        self.didChangeAttendance?()
    }
    
    @IBAction func postLunchAttendanceChanged(_ sender: UIButton) {
        if let kidsData = kidsData {
            kidsData.Lunch_Attendance = "\(sender.tag)"
        }
        
        self.didChangeAttendance?()
    }
    
    @IBAction func checkoutClicked(_ sender: UIButton) {
        if let kidsData = kidsData {
            kidsData.CheckIn = CheckInStatus.checkOut.rawValue
        }
        
        self.didClickCheckOut?()
    }
    
}
