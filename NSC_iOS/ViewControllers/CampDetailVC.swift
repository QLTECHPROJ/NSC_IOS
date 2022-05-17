//
//  CampDetailVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 27/04/22.
//

import UIKit

class CampDetailVC: BaseViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imgViewLocation: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    
    // MARK: - VARIABLES
    var strCampID = ""
    var campDetails: CampDetailModel?
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupData()
        
        refreshData()
    }
    
    
    // MARK: - FUNCTIONS
    override func setupData() {
        guard let campDetails = campDetails else {
            imgView.image = nil
            imgViewLocation.isHidden = true
            lblName.text = ""
            lblAddress.text = ""
            lblDescription.text = ""
            
            return
        }
        
        if let strUrl = campDetails.CampImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imgUrl = URL(string: strUrl) {
            imgView.sd_setImage(with: imgUrl, completed: nil)
        }
        
        imgViewLocation.isHidden = false
        
        lblName.text = campDetails.CampName
        lblAddress.text = campDetails.CampAddress
        lblDescription.text = campDetails.CampDetail
    }
    
    override func refreshData() {
        let campDetailVM = CampDetailViewModel()
        campDetailVM.callCampDetailsAPI(parameters: ["campId":strCampID]) { success in
            if success {
                self.campDetails = campDetailVM.campDetails
                self.setupData()
            }
        }
    }
    
    
    // MARK: - ACTIONS
    @IBAction func backClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func kidsClicked(_ sender: UIButton) {
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:CampDaysVC.self)
        aVC.campDetails = self.campDetails
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}
