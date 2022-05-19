//
//  CampListVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 27/04/22.
//

import UIKit

class CampListVC: BaseViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    
    // MARK: - VARIABLES
    var campListVM : CampListViewModel?
    var arrayCurrentCampList = [CampDetailModel]()
    var arrayUpcomingCampList = [CampDetailModel]()
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        lblNoData.isHidden = true
        lblNoData.text = Theme.strings.no_camps_to_display
        
        tableView.register(nibWithCellClass: TitleLabelCell.self)
        tableView.register(nibWithCellClass: CampListCell.self)
        tableView.refreshControl = self.refreshControl
        
        setupUI()
        self.refreshData()
    }
    
    
    // MARK: - FUNCTIONS
    override func setupUI() {
        imgUser.loadUserProfileImage(fontSize: 20)
        let strName = (LoginDataModel.currentUser?.Fname ?? "") + " " + (LoginDataModel.currentUser?.Lname ?? "")
        lblName.text = strName.trim.count > 0 ? strName : "Guest"
    }
    
    override func setupData() {
        if arrayCurrentCampList.count > 0 || arrayUpcomingCampList.count > 0 {
            lblNoData.isHidden = true
            tableView.isHidden = false
        } else {
            lblNoData.isHidden = false
            tableView.isHidden = true
        }
        
        tableView.reloadData()
    }
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.refreshData()
        refreshControl.endRefreshing()
    }
    
    override func refreshData() {
        let campListViewModel = CampListViewModel()
        campListViewModel.callCampListAPI(completion: { success in
            if success {
                self.arrayCurrentCampList = campListViewModel.arrayCurrentCampList
                self.arrayUpcomingCampList = campListViewModel.arrayUpcomingCampList
            }
            self.setupData()
        })
    }
    
    //MARK:- ACTION
    @IBAction func userMenuClicked(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:UserListPopUpVC.self)
        navigationController?.pushViewController(aVC, animated: true)
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension CampListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrayCurrentCampList.count
        } else {
            return arrayUpcomingCampList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: CampListCell.self)
            cell.configureCell(data: arrayCurrentCampList[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: CampListCell.self)
            cell.configureCell(data: arrayUpcomingCampList[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withClass: TitleLabelCell.self)
        
        if section == 0 {
            cell.lblTitle.text = "Current Camp"
        } else {
            cell.lblTitle.text = "Upcoming Camps"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if arrayCurrentCampList.count > 0 {
                return UITableView.automaticDimension
            }
        } else {
            if arrayUpcomingCampList.count > 0 {
                return UITableView.automaticDimension
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:CampDetailVC.self)
            aVC.strCampID = arrayCurrentCampList[indexPath.row].CampId
            aVC.campDetails = arrayCurrentCampList[indexPath.row]
            self.navigationController?.pushViewController(aVC, animated: true)
        } else {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:CampDetailVC.self)
            aVC.strCampID = arrayUpcomingCampList[indexPath.row].CampId
            aVC.campDetails = arrayUpcomingCampList[indexPath.row]
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
}
