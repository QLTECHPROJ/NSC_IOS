//
//  KidsAttendanceVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 27/04/22.
//

import UIKit

class KidsAttendanceVC: BaseViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    // MARK: - VARIABLES
    var campID = ""
    var campName = ""
    var dayID = ""
    var arrayKids = [KidsAttendanceDataModel]()
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblNoData.isHidden = true
        lblNoData.text = Theme.strings.no_data_found
        
        tableView.register(nibWithCellClass: KidsAttendenceCell.self)
        
        self.refreshData()
    }
    
    
    // MARK: - FUNCTIONS
    override func setupData() {
        lblNoData.isHidden = arrayKids.count > 0
        tableView.isHidden = arrayKids.count == 0
        
        tableView.reloadData()
    }
    
    override func refreshData() {
        let kidsAttendanceVM = KidsAttendanceViewModel()
        kidsAttendanceVM.callShowKidsAttendanceAPI(campId: campID, dayId: dayID) { success in
            if success {
                self.arrayKids = kidsAttendanceVM.arrayKids
            }
            self.setupData()
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
            showAlertToast(message: Theme.strings.alert_something_went_wrong)
        }
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension KidsAttendanceVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayKids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: KidsAttendenceCell.self)
        cell.configureCell(data: arrayKids[indexPath.row])
        
        cell.didChangeAttendance = {
            UIView.performWithoutAnimation {
                let loc = tableView.contentOffset
                tableView.reloadRows(at: [indexPath], with: .none)
                tableView.contentOffset = loc
            }
        }
        
        cell.didClickCheckOut = {
            UIView.performWithoutAnimation {
                let loc = tableView.contentOffset
                tableView.reloadRows(at: [indexPath], with: .none)
                tableView.contentOffset = loc
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}
