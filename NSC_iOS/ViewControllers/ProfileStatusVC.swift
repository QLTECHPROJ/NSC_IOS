//
//  ProfileStatusVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 29/04/22.
//

import UIKit

enum ProfileStatus{
    case Pending
    case Approved
    case Rejected
    case Hired
}

class ProfileStatusVC: ClearNaviagtionBarVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var imgViewStatus: UIImageView!
    
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var btnContinue: AppThemeButton!
    @IBOutlet weak var btnRefer: AppThemeBorderButton!
    @IBOutlet weak var btnRefresh : AppThemeBorderButton!
    
    @IBOutlet weak var scrollView : UIScrollView!
    
    
    // MARK: - VARIABLES
    var coachStatusVM : CoachStatusViewModel?
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    // MARK: - FUNCTIONS
    
    private func setUpView(){
        self.configureUI()
        self.fetchCoachSatusData()
    }
    
    private func configureUI(){
        
        self.scrollView.alpha = 0
        
        self.title = kProgressTracker
        
        self.imgViewStatus.layer.cornerRadius = 15.0
        
        self.lblName.applyLabelStyle(fontSize : 18.0,fontName : .SFProDisplayBold)
        self.lblSubTitle.applyLabelStyle(fontSize : 12.0,fontName : .SFProDisplayRegular,textColor: .colorAppTxtFieldGray)
        
        self.btnContinue.setTitle(kContinue, for: .normal)
        self.btnRefresh.setTitle(kRefresh, for: .normal)
        self.btnRefer.setTitle(kReferACoach, for: .normal)
        self.btnStatus.applystyle(fontname: .SFProDisplaySemibold, fontsize: 12.0)
        
        lblName.text = "\(kHello), \(LoginDataModel.currentUser?.Name ?? "")"
        
        self.btnStatus.setTitle("", for: .normal)
        lblSubTitle.text = ""

        
        DispatchQueue.main.async {
            
            self.btnContinue.isSelect = false
        }
    }
    
    private func setUpData(){
        self.lblName.text = "\(kHello), \(LoginDataModel.currentUser?.Name ?? "")"
        
        guard let statusData = coachStatusVM?.coachStatusData else {
            return
        }
    
        self.btnStatus.setTitle(JSON(statusData.Title as Any).stringValue, for: .normal)
        
        self.lblSubTitle.text = statusData.SubTitle
        
        if statusData.Status == CoachStatus.Pending.rawValue || statusData.Status == CoachStatus.Rejected.rawValue {
        
            self.btnContinue.isSelect = false
        } else {
    
            self.btnContinue.isSelect = true
        }
        
        if statusData.Status == CoachStatus.Pending.rawValue{
            
            self.btnStatus.setImage(LoginDataModel.currentUser?.setProfileStatus(update: .Pending).statusImage, for: .normal)
        }
        else if statusData.Status == CoachStatus.Rejected.rawValue{
            
            self.btnStatus.setImage(LoginDataModel.currentUser?.setProfileStatus(update: .Rejected).statusImage, for: .normal)
        }
        else if statusData.Status == CoachStatus.Approved.rawValue{
            
            self.btnStatus.setImage(LoginDataModel.currentUser?.setProfileStatus(update: .Approved).statusImage, for: .normal)
        }
        
        self.btnStatus.setContentEdges(titleEngesLeft: 10)
        
        UIView.animate(withDuration: 1) {
            self.scrollView.alpha = 1
        }
    }

    func fetchCoachSatusData() {
        coachStatusVM = CoachStatusViewModel()
        coachStatusVM?.callCoachStatusAPI(completion: { success in
            self.setUpData()
        })
    }
    
    
    // MARK: - ACTIONS
    @IBAction func continueCliked(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:CampListVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
    @IBAction func refreshCliked(_ sender: UIButton) {
        fetchCoachSatusData()
    }
    
    @IBAction func referCliked(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass: ReferVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}
