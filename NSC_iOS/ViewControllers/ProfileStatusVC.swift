//
//  ProfileStatusVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 29/04/22.
//

import UIKit

class ProfileStatusVC: BaseViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var imgViewStatus: UIImageView!
    
    @IBOutlet weak var btnContinue: UIButton!
    
    
    // MARK: - VARIABLES
    var coachStatusVM : CoachStatusViewModel?
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        fetchCoachSatusData()
    }
    
    
    // MARK: - FUNCTIONS
    override func setupUI() {
        lblName.text = "Hello, \(LoginDataModel.currentUser?.Name ?? "")"
        
        lblStatus.text = ""
        lblSubTitle.text = ""
        imgViewStatus.isHidden = true
        btnContinue.isUserInteractionEnabled = false
        btnContinue.backgroundColor = Theme.colors.gray_7E7E7E
    }
    
    override func setupData() {
        lblName.text = "Hello, \(LoginDataModel.currentUser?.Name ?? "")"
        
        guard let statusData = coachStatusVM?.coachStatusData else {
            return
        }
        
        lblStatus.text = statusData.Title
        lblSubTitle.text = statusData.SubTitle
        
        if statusData.Status == CoachStatus.Pending.rawValue || statusData.Status == CoachStatus.Rejected.rawValue {
            imgViewStatus.isHidden = true
            btnContinue.isUserInteractionEnabled = false
            btnContinue.backgroundColor = Theme.colors.gray_7E7E7E
        } else {
            imgViewStatus.isHidden = false
            btnContinue.isUserInteractionEnabled = false
            btnContinue.backgroundColor = Theme.colors.theme_dark
        }
    }
    
    func fetchCoachSatusData() {
        coachStatusVM = CoachStatusViewModel()
        coachStatusVM?.callCoachStatusAPI(completion: { success in
            self.setupData()
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
    
}
