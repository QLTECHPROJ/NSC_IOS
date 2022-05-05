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
    
    
    // MARK: - VARIABLES
    var coachStatusVM : CoachStatusViewModel?
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        
        coachStatusVM = CoachStatusViewModel()
        coachStatusVM?.callCoachStatusAPI(completion: { success in
            self.setupData()
        })
    }
    
    
    // MARK: - FUNCTIONS
    override func setupUI() {
        lblName.text = "Hello, \(LoginDataModel.currentUser?.Name ?? "")"
        
        lblStatus.text = ""
        lblSubTitle.text = ""
        imgViewStatus.isHidden = true
    }
    
    override func setupData() {
        lblName.text = "Hello, \(LoginDataModel.currentUser?.Name ?? "")"
        
        guard let statusData = coachStatusVM?.coachStatusData else {
            return
        }
        
        lblStatus.text = statusData.Title
        lblSubTitle.text = statusData.SubTitle
        
        if statusData.Status == CoachStatus.Approved.rawValue {
            imgViewStatus.isHidden = false
        } else {
            imgViewStatus.isHidden = true
        }
    }
    
    
    // MARK: - ACTIONS
    @IBAction func onTappedContinue(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:CampListVC.self)
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}
