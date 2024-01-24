//
//  MenuVC.swift
//  NSC_iOS
//
//  Created by vishal parmar on 21/10/23.
//

import UIKit

enum MenuItemsType : String{
   
    case editProfile = "Edit Profile"
    case bankDetails = "Bank Details"
    case personalDetails = "Personal Details"
    case myEarning = "My Earnings"
    case applyForACamp = "Apply For a Camp"
    case referCoach = "Refer a Coach"
    case logout = "Logout"
}

class MenuTblCell : UITableViewCell{
    
    @IBOutlet weak var imgIcon : UIImageView!
    @IBOutlet weak var lblTitle : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.applyLabelStyle(fontSize: 13, fontName: .SFProDisplayRegular)
    }
    
    func configureDataCell(with menuItem : JSON){
        
        self.lblTitle.text = menuItem["title"].stringValue
        self.imgIcon.image = UIImage(named: menuItem["icon"].stringValue)
    }
}

class MenuVC: ClearNaviagtionBarVC {
    
    //----------------------------------------------------------------------------
    //MARK: - Outlets
    //----------------------------------------------------------------------------
    
    @IBOutlet weak var imgUserProfile : ProfileRoundImageViewClass!
    
    @IBOutlet weak var vwProfile : AppShadowViewClass!
    
    @IBOutlet weak var tblView : UITableView!
    
    @IBOutlet weak var lblUserName : UILabel!
    
    @IBOutlet weak var lblLogout : UILabel!
    
    @IBOutlet weak var lblEmail : UILabel!
    
    //----------------------------------------------------------------------------
    //MARK: - Variables
    //----------------------------------------------------------------------------
    
    private var arrMenuItems : [JSON] = []
    private var isAnimated = Bool()
    
    //----------------------------------------------------------------------------
    //MARK: - Memory management
    //----------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
    }
    
    //----------------------------------------------------------------------------
    //MARK: - Custome Methods
    //----------------------------------------------------------------------------

    private func setUpView(){
        
        self.configureUI()
        self.setMenuItems()
        
    }
    
    private func setMenuItems(){
        self.arrMenuItems.append(["icon" : "editProfileNewIcon", "title" : kEditProfile , "type" : MenuItemsType.editProfile.rawValue])
        
        self.arrMenuItems.append(["icon" : "bankdetailNewicon", "title" : kBankDetails , "type" : MenuItemsType.bankDetails.rawValue])
        
        self.arrMenuItems.append(["icon" : "personalDetailNew", "title" : kPersonalDetails , "type" : MenuItemsType.personalDetails.rawValue])
        
        self.arrMenuItems.append(["icon" : "myearningNewIcon", "title" : kMyEarning , "type" : MenuItemsType.myEarning.rawValue])
        
        self.arrMenuItems.append(["icon" : "applyforCamp", "title" : kApplyForACamp , "type" : MenuItemsType.applyForACamp.rawValue])
        
        self.arrMenuItems.append(["icon" : "referCoachNewIcon", "title" : kReferACoach , "type" : MenuItemsType.referCoach.rawValue])
        
    }
    
    private func configureUI(){
        self.isAnimated = true
        self.title = kAccount
        
        self.lblUserName.applyLabelStyle(fontSize: 18, fontName: .SFProDisplaySemibold)
        self.lblEmail.applyLabelStyle(fontSize: 12, fontName: .SFProDisplayRegular,textColor: .colorAppTxtFieldGray)
        self.lblLogout.applyLabelStyle(text : kLogout,fontSize: 13, fontName: .SFProDisplayRegular)
        self.vwProfile.isRound = true
    }
    
    private func setUserProfile(){
        self.lblUserName.text = LoginDataModel.currentUser?.Name ?? ""
        self.lblEmail.text = LoginDataModel.currentUser?.Email ?? ""
                    
        self.imgUserProfile.sd_setImage(with: LoginDataModel.currentUser?.Profile_Image.url(), placeholderImage: UIImage(named: "defaultUserIcon")!,options: .forceTransition) { img, error, cacheType, url in
            
            if let image = img{
                self.vwProfile.shadowColorVW = image.averageColor!.cgColor
                self.vwProfile.shadowOffSetSize = CGSize(width: 3, height: 3)
                self.vwProfile.shadowRadiusSize = 6
            }
        }
    }
    
    //----------------------------------------------------------------------------
    //MARK: - Action Methods
    //----------------------------------------------------------------------------
    @IBAction func btnBackTapped(_ sender : UIBarButtonItem){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLogoutTapped(_ sender : UIButton){
        if checkInternet(showToast: true) == false {
            return
        }
        
        let vc = AppStoryBoard.main.viewController(viewControllerClass: AlertPopUpVC.self)
        vc.alertType = .logout
        vc.modalPresentationStyle = .overFullScreen
        
        UIApplication.topViewController()?.present(vc, animated: false, completion :{
            vc.openPopUpVisiable()
        })
        vc.completionBlock = { completion , type in
            
            if completion , type == .logout{
                
                if checkInternet(showToast: true) == false {
                    return
                }
                
                let logoutVM = LogoutViewModel()
                logoutVM.callLogoutAPI(completion: { success in
                    APPDELEGATE.logout()
                })
            }
        }
    }
   
    
    
    
    //----------------------------------------------------------------------------
    //MARK: - View life cycle
    //----------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.setUserProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

}

//----------------------------------------------------------------------------
//MARK: - UITableView Methods
//----------------------------------------------------------------------------
extension MenuVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MenuTblCell.self)
        cell.configureDataCell(with: self.arrMenuItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch self.arrMenuItems[indexPath.row]["type"].stringValue {
            
        case MenuItemsType.editProfile.rawValue:
           
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:EditProfileVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            
            break
            
        case MenuItemsType.bankDetails.rawValue:
            
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:BankDetailsVC.self)
            aVC.isFromEdit = true
            self.navigationController?.pushViewController(aVC, animated: true)
            
            break
            
            
        case MenuItemsType.personalDetails.rawValue:
            
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:PersonalDetailsVC.self)
            aVC.isFromEdit = true
            self.navigationController?.pushViewController(aVC, animated: true)
            
            break
            
      
        case MenuItemsType.applyForACamp.rawValue:
           
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: ApplyForCampVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            
            break
            
            
        case MenuItemsType.myEarning.rawValue:
           
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:EarningVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            
            break
            
        case MenuItemsType.referCoach.rawValue:
           
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:ReferVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
            
            break
            
        default:
            
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.isAnimated{
            cell.alpha = 0
            self.isAnimated = indexPath.row == (self.arrMenuItems.count-1) ? false : true
            UIView.animate(withDuration: 2, delay: 0.05*Double(indexPath.row), options: .transitionFlipFromBottom, animations: {
                cell.alpha = 1
            })
        }
    }
}


