//
//  AlertPopUpVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 29/04/22.
//

import UIKit


enum AlertPopUpType : String {
    
    case logout
    case deleteAccount
    case normalUpdate
    case forceUpadte
    case removeMedia
    case none
}



class AlertPopUpVC: UIViewController {
    
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblDetail : UILabel!
    
    @IBOutlet weak var btnTrue : AppThemeButton!
    @IBOutlet weak var btnFalse : AppThemeBorderButton!
    
    
    // MARK: - VARIABLES
    var alertType : AlertPopUpType = .none
    
    var completionBlock : ((Bool,AlertPopUpType)->Void)?
    
    
    // MARK: - FUNCTIONS
    
    private func setUpView(){
        self.configureUI()
        self.setData()
    }
    
    private func configureUI(){
        self.view.alpha = 0
        self.lblTitle.applyLabelStyle(fontSize: 16.0, fontName: .SFProDisplayBold)
        self.lblDetail.applyLabelStyle(fontSize: 13.0, fontName: .SFProDisplayMedium)
        
        self.btnTrue.isSelect = true
    }
    
    func openPopUpVisiable(){
        UIView.animate(withDuration: 0.5, delay: 0.0) {
            self.view.alpha = 1
        }
    }
    
    private func closePopUpVisiable(isCompletion : Bool = false){
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
            
            self.view.alpha = 0
            
        }, completion: { (finished: Bool) in
            self.dismiss(animated: false) {
                
                if let _ = self.completionBlock{
                    self.completionBlock!(isCompletion,self.alertType)
                }
            }
        })
    }
    
    
    private func setData(){
       
        if self.alertType == .logout{
            
            self.lblTitle.text = kLogout
            self.lblDetail.text = kAlertForAppLogoutPersmission
            
            self.btnTrue.setTitle(kYes, for: .normal)
            self.btnFalse.setTitle(kCancel, for: .normal)
        }
        else if self.alertType == .forceUpadte{
            
            self.lblTitle.text = kForceUpdate
            self.lblDetail.text = kForceUpdateInstruction
            
            self.btnTrue.setTitle(kUpdate, for: .normal)
            self.btnFalse.isHidden = true
        }
        else if self.alertType == .normalUpdate{
            
            self.lblTitle.text = kNormalUpdate
            self.lblDetail.text = kNormalUpdateInstruction
            
            self.btnTrue.setTitle(kUpdate, for: .normal)
            self.btnFalse.setTitle(kNotNow, for: .normal)
        }
        else if self.alertType == .deleteAccount{
            
            self.lblTitle.text = kDeleteAccount
            self.lblDetail.text = kAlertForDeleteAccountPersmission
            
            self.btnTrue.setTitle(kDelete, for: .normal)
            self.btnFalse.setTitle(kCancel, for: .normal)
        }
        else if self.alertType == .removeMedia{
            
            self.lblTitle.text = kDeleteMedia
            self.lblDetail.text = kDeleteMediaInstruction
            
            self.btnTrue.setTitle(kYes, for: .normal)
            self.btnFalse.setTitle(kCancel, for: .normal)
        }
    }
    
    
    // MARK: - ACTIONS
    
    @IBAction func btnTrueTapped(_ sender : UIButton) {
        self.closePopUpVisiable(isCompletion: true)
    }
    
    @IBAction func btnFalseTapped(_ sender : UIButton) {
        self.closePopUpVisiable()
    }
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}

