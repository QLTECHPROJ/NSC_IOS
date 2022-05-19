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
        tableView.refreshControl = self.refreshControl
        
        DispatchQueue.main.async {
            self.btnSubmit.isUserInteractionEnabled = false
            self.btnSubmit.backgroundColor = Theme.colors.gray_7E7E7E
        }
        
        self.refreshData()
    }
    
    
    // MARK: - FUNCTIONS
    override func setupData() {
        lblNoData.isHidden = arrayKids.count > 0
        tableView.isHidden = arrayKids.count == 0
        
        tableView.reloadData()
    }
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.refreshData()
        refreshControl.endRefreshing()
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}
