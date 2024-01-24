//
//  KidsAttendanceVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 27/04/22.
//

import UIKit
import DZNEmptyDataSet


class KidsNewAttendanceTblCell : UITableViewCell{
    
    @IBOutlet weak var imgStatus: UIImageView!
    
    @IBOutlet weak var lblKidName : UILabel!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var lblGroupName : UILabel!
    
    //----------------------------------------------------------------
    // After check/uncheck attandance display Status
    @IBOutlet weak var vwDisplayAttendance : UIView!
    
    @IBOutlet weak var stackVMorningAttendance : UIStackView!
    @IBOutlet weak var lblMornings : UILabel!
    @IBOutlet weak var lblMorningsValue : UILabel!
    
    @IBOutlet weak var stackVPostLunchAttendance : UIStackView!
    @IBOutlet weak var lblPostLunch : UILabel!
    @IBOutlet weak var lblPostLunchValue : UILabel!
    
    @IBOutlet weak var stackVCheckOutAttendance : UIStackView!
    @IBOutlet weak var lblCheckOut : UILabel!
    @IBOutlet weak var btnCheckOut : UIButton!
    //----------------------------------------------------------------
    
    // Check box View Hide/Show
    @IBOutlet weak var vwMSAttendance : UIView!
    @IBOutlet weak var lblMSTitle : UILabel!
    @IBOutlet weak var btnMSPresent : UIButton!
    @IBOutlet weak var btnMSAbsent : UIButton!
    
    @IBOutlet weak var vwPLAttendance : UIView!
    @IBOutlet weak var lblPLTitle : UILabel!
    @IBOutlet weak var btnPLPresent : UIButton!
    @IBOutlet weak var btnPLAbsent : UIButton!
    
    @IBOutlet weak var vwCOAttendance : UIView!
    @IBOutlet weak var lblCOTitle : UILabel!
    @IBOutlet weak var btnCOCheckInOut : UIButton!
    

    var kidsData: KidsAttendanceDetailModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblKidName.applyLabelStyle(fontSize: 14.0, fontName: .SFProDisplaySemibold)
        
        self.lblStatus.applyLabelStyle(fontSize: 12.0, fontName: .SFProDisplayBold,textColor: .colorAppThemeOrange)
        
        self.lblGroupName.applyLabelStyle(fontSize: 12.0, fontName: .SFProDisplayBold,textColor: .colorAppThemeOrange)
        
        
        self.lblMornings.applyLabelStyle(text :kMornings,fontSize: 12.0, fontName: .SFProDisplayMedium,textColor: .colorAppTxtFieldGray)
        self.lblMSTitle.applyLabelStyle(text :kMornings,fontSize: 12.0, fontName: .SFProDisplayMedium,textColor: .colorAppTxtFieldGray)
        
        self.lblPostLunch.applyLabelStyle(text :kPostLunch,fontSize: 12.0, fontName: .SFProDisplayMedium,textColor: .colorAppTxtFieldGray)
        self.lblPLTitle.applyLabelStyle(text :kPostLunch,fontSize: 12.0, fontName: .SFProDisplayMedium,textColor: .colorAppTxtFieldGray)
        
        self.lblCheckOut.applyLabelStyle(text :kCheckOut,fontSize: 12.0, fontName: .SFProDisplayMedium,textColor: .colorAppTxtFieldGray)
        self.lblCOTitle.applyLabelStyle(text :kCheckOut,fontSize: 12.0, fontName: .SFProDisplayMedium,textColor: .colorAppTxtFieldGray)
        
        self.lblMorningsValue.applyLabelStyle(fontSize: 12.0, fontName: .SFProDisplayBold,textColor: .colorAppThemeOrange)
        self.lblPostLunchValue.applyLabelStyle(fontSize: 12.0, fontName: .SFProDisplayBold,textColor: .colorAppThemeOrange)
        
        self.btnMSPresent.applystyle(isApsectRadio: false, fontname: .SFProDisplayRegular, fontsize: 12.0, titleText: kPresent)
        self.btnMSAbsent.applystyle(isApsectRadio: false, fontname: .SFProDisplayRegular, fontsize: 12.0, titleText: kAbsent)
        
        self.btnPLPresent.applystyle(isApsectRadio: false, fontname: .SFProDisplayRegular, fontsize: 12.0, titleText: kPresent)
        self.btnPLAbsent.applystyle(isApsectRadio: false, fontname: .SFProDisplayRegular, fontsize: 12.0, titleText: kAbsent)
    }
    
    func configureAttendenceCellWith(data :KidsAttendanceDetailModel, dayshift : String){
        
        self.lblKidName.text = data.Name
        self.lblGroupName.text = data.Group_Name
        
        let attributedGroup: NSMutableAttributedString = NSMutableAttributedString(string: "\(kGroupNameColmn)\(JSON(data.Group_Name as Any).stringValue)")
        attributedGroup.setAttributes(color: UIColor.colorAppTxtFieldGray, forText: kGroupNameColmn, font: 12, fontname: .SFProDisplayMedium)
        attributedGroup.setAttributes(color: UIColor.colorAppThemeOrange, forText: JSON(data.Group_Name as Any).stringValue, font: 12, fontname: .SFProDisplayBold)
        self.lblGroupName.attributedText = attributedGroup
        
        let attributed1stTime: NSMutableAttributedString = NSMutableAttributedString(string: "1st Time")
        attributed1stTime.setAttributes(color: UIColor.colorAppThemeOrange, forText: "1", font: 12, fontname: .SFProDisplayBold)
        attributed1stTime.setAttributes(color: UIColor.colorAppThemeOrange, forText: "st", font: 10, fontname: .SFProDisplayBold)
        attributed1stTime.setAttributes(color: UIColor.colorAppThemeOrange, forText: "Time", font: 12, fontname: .SFProDisplayBold)
        self.lblStatus.attributedText = attributed1stTime
        
        self.lblStatus.isHidden = data.isFirstTimer == "1" ? false : true
        
        //-----------------------------------------------------------------------------------
        // Status Displaying
        //-----------------------------------------------------------------------------------
        DispatchQueue.main.async {
            self.imgStatus.layer.cornerRadius = self.imgStatus.frame.height/2
        }
        
        if data.CheckIn == CheckInStatus.checkIn.rawValue {
        
            self.imgStatus.backgroundColor = Theme.colors.green_008D36
            
        } else if data.CheckIn == CheckInStatus.checkOut.rawValue {
            
            self.imgStatus.backgroundColor = UIColor.colorAppThemeOrange
            
        } else {
            self.btnPLAbsent.isUserInteractionEnabled = false
            self.btnPLPresent.isUserInteractionEnabled = false
            
            self.btnMSAbsent.isUserInteractionEnabled = false
            self.btnMSPresent.isUserInteractionEnabled = false
            
            self.btnCOCheckInOut.isUserInteractionEnabled = false
            
            self.imgStatus.backgroundColor = Theme.colors.yellow_F3DE29
        }
        
        //-----------------------------------------------------------------------------------
        // Morning Sessions Selection
        //-----------------------------------------------------------------------------------
        if data.Morning_Attendance == AttendanceStatus.present.rawValue {
            
            self.btnMSPresent.isSelected = true
            self.btnMSAbsent.isSelected = false
            
        } else if data.Morning_Attendance == AttendanceStatus.absent.rawValue {
        
            self.btnMSPresent.isSelected = false
            self.btnMSAbsent.isSelected = true
            
        } else {
            self.btnMSPresent.isSelected = false
            self.btnMSAbsent.isSelected = false
            self.lblMorningsValue.text = "-"
        }
        
        //----------------------------------------------------------------------------------
        // Post Lunch Sesssion Selection
        //----------------------------------------------------------------------------------
        if data.Lunch_Attendance == AttendanceStatus.present.rawValue {
            
            self.btnPLPresent.isSelected = true
            self.btnPLAbsent.isSelected = false
            
        } else if data.Lunch_Attendance == AttendanceStatus.absent.rawValue {
        
            self.btnPLPresent.isSelected = false
            self.btnPLAbsent.isSelected = true
            
        } else {
            self.btnPLPresent.isSelected = false
            self.btnPLAbsent.isSelected = false
            self.lblPostLunchValue.text = "-"
        }
        
        //----------------------------------------------------------------------------------
        // Check In-Out Selection
        //----------------------------------------------------------------------------------
        
        if data.CheckIn == CheckInStatus.checkOut.rawValue {
           
            self.btnCheckOut.isSelected = true
            
        } else {
            
            self.btnCheckOut.isSelected = false
        }
        
        //-----------------------------------------------------------------------------------
        //Default all actions & display view hidden
        //-----------------------------------------------------------------------------------
        
        self.vwDisplayAttendance.isHidden = true
        self.stackVMorningAttendance.isHidden = true
        self.stackVPostLunchAttendance.isHidden = true
        self.stackVCheckOutAttendance.isHidden = true
        
        self.vwMSAttendance.isHidden = true
        self.vwPLAttendance.isHidden = true
        self.vwCOAttendance.isHidden = true
        
        self.btnCheckOut.isSelected = true
        
        
        let shiftStatus = DayShiftStatus(rawValue: dayshift) ?? .none
        
        if shiftStatus == .morning{
            
            if data.CheckIn == CheckInStatus.checkOut.rawValue{
                
                self.vwDisplayAttendance.isHidden = false
                self.stackVMorningAttendance.isHidden = false
            }
            else{
                self.vwMSAttendance.isHidden = false
            }
        }
        else if shiftStatus == .lunch{
            
            self.vwDisplayAttendance.isHidden = false
            self.stackVMorningAttendance.isHidden = false

            if data.CheckIn == CheckInStatus.checkOut.rawValue{
                
                self.stackVPostLunchAttendance.isHidden = false
            }
            else{
                self.vwPLAttendance.isHidden = false
            }
        }
        else if shiftStatus == .checkout || shiftStatus.rawValue == ""{
            
            self.vwDisplayAttendance.isHidden = false
            self.stackVMorningAttendance.isHidden = false
            self.stackVPostLunchAttendance.isHidden = false
            
            if data.CheckIn == CheckInStatus.toBeCheckedIn.rawValue{
                
                self.stackVCheckOutAttendance.isHidden = false
                
            }
            else if data.CheckIn == CheckInStatus.checkIn.rawValue{
                
                self.vwCOAttendance.isHidden = false
            }
            else if data.CheckIn == CheckInStatus.checkOut.rawValue{
                
                self.stackVCheckOutAttendance.isHidden = false
            }
        }
        
        if data.Morning_Attendance == AttendanceStatus.present.rawValue {
            self.lblMorningsValue.text = kPresent
        }
        else if data.Morning_Attendance == AttendanceStatus.absent.rawValue {
            self.lblMorningsValue.text = kAbsent
        }
        
        if data.Lunch_Attendance == AttendanceStatus.present.rawValue {
            self.lblPostLunchValue.text = kPresent
        }
        else if data.Lunch_Attendance == AttendanceStatus.absent.rawValue {
            self.lblPostLunchValue.text = kAbsent
        }
    }
}


class KidsAttendanceVC: ClearNaviagtionBarVC {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSubmit: AppThemeButton!
    
    
    // MARK: - VARIABLES
    var campID = ""
    var dayID = ""
    var dayshift = ""
    var arrayKids = [KidsAttendanceDetailModel]()
    
    private var emptyMessage : String = Theme.strings.alert_something_went_wrong
    private var isAnimated = Bool()
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiCallShowKidsAttendanceAPI()
    }
    
    
    // MARK: - FUNCTIONS
    
    private func setUpView(){
        self.configureUI()
    }
    
    
    private func configureUI(){
        self.isAnimated = true
        
        self.title = kKidsAttendance
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    private func setData() {
       
        if dayshift == DayShiftStatus.none.rawValue {
           
            self.btnSubmit.isSelect = false
        } else {
            self.btnSubmit.isSelect = true
            
            
            if self.arrayKids.isEmpty{
                self.btnSubmit.isSelect = false
            }
        }
    }
    
    
    
    
    // MARK: - ACTIONS
    @IBAction func backClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if arrayKids.count > 0 {
            var arrayKidsData = [[String:Any]]()
            
            for kid in arrayKids {
                var dictKidData = [String:Any]()
                dictKidData["KidId"] = kid.ID
                dictKidData["Morning_Attendance"] = kid.Morning_Attendance
                dictKidData["Lunch_Attendance"] = kid.Lunch_Attendance
                dictKidData["CheckIn"] = kid.CheckIn
                arrayKidsData.append(dictKidData)
            }
            
            print("arrayKidsData - \(arrayKidsData)")
            
            let saveKidsAttendanceVM = SaveKidsAttendanceViewModel()
            saveKidsAttendanceVM.callSaveKidsAttendanceAPI(campId: campID, dayId: dayID, arrayAttendance: arrayKidsData) { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
    
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_something_went_wrong)
        }
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension KidsAttendanceVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayKids.count
    }
    
    @objc func btnMorningPresentAttendanceTapped(_ sender : UIButton){
        self.arrayKids[sender.tag].Morning_Attendance = "1"
//        self.tableView.reloadData()
        
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? KidsNewAttendanceTblCell else{
            return
        }
        
        if self.arrayKids[sender.tag].Morning_Attendance == AttendanceStatus.present.rawValue {
            
            cell.btnMSPresent.isSelected = true
            cell.btnMSAbsent.isSelected = false
            
        }
    }
    
    @objc func btnMorningAbsentAttendanceTapped(_ sender : UIButton){

        self.arrayKids[sender.tag].Morning_Attendance = "2"
//        self.tableView.reloadData()
        
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? KidsNewAttendanceTblCell else{
            return
        }
        
        if self.arrayKids[sender.tag].Morning_Attendance == AttendanceStatus.absent.rawValue {
            
            cell.btnMSPresent.isSelected = false
            cell.btnMSAbsent.isSelected = true
            
        }
    }
    
    @objc func btnPostLunchPresentAttendanceTapped(_ sender : UIButton){

        self.arrayKids[sender.tag].Lunch_Attendance = "1"
        //self.tableView.reloadData()
        
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? KidsNewAttendanceTblCell else{
            return
        }

        
        if self.arrayKids[sender.tag].Lunch_Attendance == AttendanceStatus.present.rawValue {
            
            cell.btnPLPresent.isSelected = true
            cell.btnPLAbsent.isSelected = false
            
        }
    }
    
    @objc func btnPostLunchAbsentAttendanceTapped(_ sender : UIButton){

        self.arrayKids[sender.tag].Lunch_Attendance = "2"
        
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? KidsNewAttendanceTblCell else{
            return
        }

        if self.arrayKids[sender.tag].Lunch_Attendance == AttendanceStatus.absent.rawValue {
        
            cell.btnPLPresent.isSelected = false
            cell.btnPLAbsent.isSelected = true
            
        }
    }
    
    @objc func btnCheckInOuttAttendanceTapped(_ sender : UIButton){

        if self.arrayKids[sender.tag].CheckIn == "1"{
            
            self.arrayKids[sender.tag].CheckIn = "2"
        }
        else {
            self.arrayKids[sender.tag].CheckIn = "1"
        }
        
        guard let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as? KidsNewAttendanceTblCell else{
            return
        }

        if self.arrayKids[sender.tag].CheckIn == CheckInStatus.checkOut.rawValue {
           
            cell.btnCOCheckInOut.isSelected = true
            
        } else {
            
            cell.btnCOCheckInOut.isSelected = false
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withClass: KidsNewAttendanceTblCell.self)
        
        cell.configureAttendenceCellWith(data: self.arrayKids[indexPath.row], dayshift: self.dayshift)
        
        cell.btnMSPresent.tag = indexPath.row
        cell.btnMSPresent.addTarget(self, action: #selector(self.btnMorningPresentAttendanceTapped(_:)), for: .touchUpInside)
        
        cell.btnMSAbsent.tag = indexPath.row
        cell.btnMSAbsent.addTarget(self, action: #selector(self.btnMorningAbsentAttendanceTapped(_:)), for: .touchUpInside)
        
        cell.btnPLPresent.tag = indexPath.row
        cell.btnPLPresent.addTarget(self, action: #selector(self.btnPostLunchPresentAttendanceTapped(_:)), for: .touchUpInside)
        
        cell.btnPLAbsent.tag = indexPath.row
        cell.btnPLAbsent.addTarget(self, action: #selector(self.btnPostLunchAbsentAttendanceTapped(_:)), for: .touchUpInside)
        
        
        cell.btnCOCheckInOut.tag = indexPath.row
        cell.btnCOCheckInOut.addTarget(self, action: #selector(self.btnCheckInOuttAttendanceTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.isAnimated{
            cell.alpha = 0
            self.isAnimated = indexPath.row == (self.arrayKids.count-1) ? false : true
            UIView.animate(withDuration: 2, delay: 0.05*Double(indexPath.row), options: .transitionFlipFromBottom, animations: {
                cell.alpha = 1
            })
        }
    }
}


//-------------------------------------------------------------------
//MARK: - Empty TableView Methods
//-------------------------------------------------------------------
extension KidsAttendanceVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource{
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.emptyMessage
        let attributes = [NSAttributedString.Key.font: UIFont.applyCustomFont(fontName: .SFProDisplayRegular, fontSize: 13.0), NSAttributedString.Key.foregroundColor: UIColor.colorAppTextBlack]
        return NSAttributedString(string: text, attributes: attributes)
    }
}
extension KidsAttendanceVC{
    
    func apiCallShowKidsAttendanceAPI(){
        let kidsAttendanceVM = KidsAttendanceViewModel()
        kidsAttendanceVM.callShowKidsAttendanceAPI(campId: campID, dayId: dayID) { success in
            if success {
                
                self.dayID = kidsAttendanceVM.dayId
                self.dayshift = kidsAttendanceVM.dayshift
                self.arrayKids = kidsAttendanceVM.arrayKids
            }
            self.tableView.reloadData()
            self.setData()
        }
    }
}
