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
        
        tableView.register(nibWithCellClass: CampListCell.self)
        tableView.refreshControl = self.refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        self.refreshData()
    }
    
    // MARK: - FUNCTIONS
    override func setupUI() {
        imgUser.loadUserProfileImage(fontSize: 20)
        lblName.text = (LoginDataModel.currentUser?.Fname ?? "") + " " + (LoginDataModel.currentUser?.Lname ?? "")
    }
    
    override func setupData() {
        if arrayCurrentCampList.count > 0 || arrayUpcomingCampList.count > 0 {
            lblNoData.isHidden = true
        } else {
            lblNoData.isHidden = false
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
            self.arrayCurrentCampList = campListViewModel.arrayCurrentCampList
            self.arrayUpcomingCampList = campListViewModel.arrayUpcomingCampList
            self.setupData()
        })
    }
    
    //MARK:- ACTION
    @IBAction func userMenuClicked(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:UserListPopUpVC.self)
        let navVC = UINavigationController(rootViewController: aVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion: nil)
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
        return 120
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        if section == 0 {
            label.text = "Current Camp"
        } else {
            label.text = "Upcoming Camps"
        }
        label.textColor = .black
        label.font = Theme.fonts.appFont(ofSize: 14, weight: .bold)
        headerView.backgroundColor = .clear
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if arrayCurrentCampList.count > 0 {
                return 30
            }
        } else {
            if arrayUpcomingCampList.count > 0 {
                return 30
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
