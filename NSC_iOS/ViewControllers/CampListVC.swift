//
//  CampListVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 27/04/22.
//

import UIKit
import DZNEmptyDataSet

class CampListVC: ClearNaviagtionBarVC {
    
    //--------------------------------------------------------------------------------------
    // MARK: - Outlets
    //--------------------------------------------------------------------------------------
    
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var imgBanner: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    //--------------------------------------------------------------------------------------
    // MARK: - Variables
    //--------------------------------------------------------------------------------------
    var campListVM : CampListViewModel?
    
    var BannerImage = ""
    var arrayCurrentCampList = [CampDetailModel]()
    var arrayUpcomingCampList = [CampDetailModel]()
    
    var arrMain : [MainCampDetailModel] = []
    
    private var emptyMessage : String = Theme.strings.no_camps_to_display
    private var isAnimated = Bool()
    
    deinit{
        self.removeClassObservers()
    }
    
    //--------------------------------------------------------------------------------------
    // MARK: - Custom Methods
    //--------------------------------------------------------------------------------------
    private func setUpView(){
        
        self.addClassObservers()
        self.configureUI()
    }
    
    private func configureUI(){
        self.isAnimated = true
        self.imgBanner.backgroundColor = .clear
        self.lblName.applyLabelStyle(isAdjustFontWidth: true,text : "",fontSize: 14.0, fontName: .SFProDisplaySemibold)
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        self.tableView.refreshControl = self.refreshControl
        tableView.tableHeaderView = UIView()
    
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func setUpUI() {
        
        self.imgUser.sd_setImage(with: LoginDataModel.currentUser?.Profile_Image.url(), placeholderImage: UIImage(named: "defaultUserIcon")!, context: nil)
        
        let strName = (LoginDataModel.currentUser?.Fname ?? "") + " " + (LoginDataModel.currentUser?.Lname ?? "")
        self.lblName.text = strName.trim.count > 0 ? strName : kGuest
        
    }

    
    private func setUpData() {
        
        if BannerImage.trim.count > 0, let strUrl = BannerImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imgUrl = URL(string: strUrl) {
            imgBanner.sd_setImage(with: imgUrl, completed: nil)
            tableView.tableHeaderView = tableHeaderView
            
        } else {
            tableView.tableHeaderView = UIView()
        }
    
        self.tableView.reloadData()
    }
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.apiCallCampList()
    }
    
   
    
    //--------------------------------------------------------------------------------------
    //MARK: - Anctions
    //--------------------------------------------------------------------------------------
    @IBAction func userMenuClicked(_ sender: UIButton) {
        
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:MenuVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    @IBAction func notificationClicked(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:NotificationVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    
    @IBAction func bannerClicked(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: ReferVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    //--------------------------------------------------------------------------------------
    // MARK: - View Life Cycle
    //--------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.apiCallCampList(true)
        
    }
}


//--------------------------------------------------------------------------------------
// MARK: - UITableView Methods
//--------------------------------------------------------------------------------------
extension CampListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrMain.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrMain[section].data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withClass: CampListCell.self)
        cell.configureCell(data: self.arrMain[indexPath.section].data[indexPath.row], listType: self.arrMain[indexPath.section].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withClass: CampHeaderTbleCell.self)
        cell.backgroundColor = .colorAppThemeBGWhite
        cell.configureDataHeaderCell(with: self.arrMain[section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:CampDetailVC.self)
        aVC.strCampID = self.arrMain[indexPath.section].data[indexPath.row].CampId
        aVC.campDetails = self.arrMain[indexPath.section].data[indexPath.row]
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.isAnimated{
            cell.alpha = 0
            self.isAnimated = indexPath.row == (self.arrMain[indexPath.section].data.count-1) ? false : true
            UIView.animate(withDuration: 2, delay: 0.05*Double(indexPath.row), options: .transitionFlipFromBottom, animations: {
                cell.alpha = 1
            })
        }
    }
}

//--------------------------------------------------------------------------------------
//MARK: - Empty TableView Methods
//--------------------------------------------------------------------------------------
extension CampListVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource{
   
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {

        return EmptyViewClass.shared.showEmptyView(title : self.emptyMessage,actionButtonTitle : kApplyNow)
    }
}

//--------------------------------------------------------------------------------------
//MARK: - API Calling Methods
//--------------------------------------------------------------------------------------
extension CampListVC{
    
    private func apiCallCampList(_ isLoader : Bool = false) {
        let campListViewModel = CampListViewModel()
        campListViewModel.callCampListAPI(isLoader : isLoader){ success in
            
            self.refreshControl.endRefreshing()
            
            if success {
                self.BannerImage = campListViewModel.BannerImage
                self.arrayCurrentCampList = campListViewModel.arrayCurrentCampList
                self.arrayUpcomingCampList = campListViewModel.arrayUpcomingCampList
                
                self.arrMain = []
                if !self.arrayCurrentCampList.isEmpty {
                    let mainData = MainCampDetailModel()
                    mainData.title = kCurrentCamp
                    mainData.data = self.arrayCurrentCampList
                    self.arrMain.append(mainData)
                }
                
                if !self.arrayUpcomingCampList.isEmpty {
                    let mainData = MainCampDetailModel()
                    mainData.title = kUpcomingCamps
                    mainData.data = self.arrayUpcomingCampList
                    self.arrMain.append(mainData)
                }
            }
            
            self.setUpUI()
            self.setUpData()
        }
    }
}

//----------------------------------------------------------------------------
//MARK: - Class observers Methods
//----------------------------------------------------------------------------
extension CampListVC {
    
    func addClassObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(self.btnApplyNowTapped(_:)), name: NSNotification.Name.emptyViewReturnAction, object: nil)
    }
    
    func removeClassObservers() {
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.emptyViewReturnAction, object: nil)
    }
    
    //----------------------------------------------------------------------------
    // Update like/unlike on comment's reply
    
//    @objc func btnApplyNowTapped(_ notification : NSNotification) {
//
//        if let dataModel = notification.object as? JSON {
//
//            if dataModel["action"].boolValue{
//                let aVC = AppStoryBoard.main.viewController(viewControllerClass: ApplyForCampVC.self)
//                self.navigationController?.pushViewController(aVC, animated: true)
//            }
//        }
//    }
}

