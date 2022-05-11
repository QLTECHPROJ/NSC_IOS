//
//  CampListVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 27/04/22.
//

import UIKit

class CampListVC: BaseViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables
    var campListVM : CampListViewModel?
    var arrayCampList = [CampListDataModel]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(nibWithCellClass: CampListCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        let campListViewModel = CampListViewModel()
        campListViewModel.callCampListAPI(completion: { success in
            self.arrayCampList = campListViewModel.campListData
            self.setupData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    //MARK:- FUNCTION
    override func setupData() {
        tableView.reloadData()
    }
    
    //MARK:- ACTION
    @IBAction func backClicked(_ sender: UIButton) {
        
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:UserListPopUpVC.self)
        let navVC = UINavigationController(rootViewController: aVC)
        navVC.navigationBar.isHidden = true
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
}

extension CampListVC: UITableViewDelegate , UITableViewDataSource {
    
    // MARK - UITableView Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 2
        }else {
            return arrayCampList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: CampListCell.self)
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withClass: CampListCell.self)
            cell.configureCell(data: arrayCampList[indexPath.row])
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
        }else {
            label.text = "Upcoming Camps"
        }
        label.textColor = .black
        label.font = Theme.fonts.appFont(ofSize: 14, weight: .bold)
        headerView.backgroundColor = .clear
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:CampDetailVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}
