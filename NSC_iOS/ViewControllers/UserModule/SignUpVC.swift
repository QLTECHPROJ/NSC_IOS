//
//  SignUpVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import IQKeyboardManagerSwift

class SignUpVC: BaseViewController {
    
    // MARK: - OUTLETS
    //UIStackView
    @IBOutlet weak var stackView: UIStackView!
    
    //UITextfield
    @IBOutlet weak var txtFName: UITextField!
    @IBOutlet weak var txtFMobileNo: UITextField!
    @IBOutlet weak var txtFEmailAdd: UITextField!
    
    // UIButton
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var btnGetSMSCode: UIButton!
    
    // UILabel
    @IBOutlet weak var lblTitleHeightConst: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblPrivacy: TTTAttributedLabel!
    @IBOutlet weak var lblSupport: TTTAttributedLabel!
    @IBOutlet weak var lblErrName: UILabel!
    @IBOutlet weak var lblErrMobileNo: UILabel!
    @IBOutlet weak var lblErrEmail: UILabel!
    
    // MARK: - VARIABLES
    var isFromOTP = false
    var isCountrySelected = false
    //var selectedCountry = CountrylistDataModel(id: "0", name: "Australia", shortName: "AU", code: "61")
    var strMobile:String?
   
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPrivacyLabel(lblPrivacy: lblPrivacy)
        setupSupportLabel(lblSupport: lblSupport)
        setupData()
        
        if strMobile != "" {
            txtFMobileNo.text = strMobile
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Segment Tracking
       // SegmentTracking.shared.trackGeneralScreen(name: SegmentTracking.screenNames.signUp)
        
        if isFromOTP {
            txtFMobileNo.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
   
    // MARK: - FUNCTIONS
    override func setupUI() {
        lblTitle.text = Theme.strings.register_title
        lblSubTitle.attributedText = Theme.strings.register_subtitle.attributedString(alignment: .center, lineSpacing: 5)
        
        lblErrName.isHidden = true
        
        lblErrMobileNo.isHidden = true
        lblErrEmail.isHidden = true
        
        txtFName.delegate = self
        txtFMobileNo.delegate = self
        txtFEmailAdd.delegate = self
        
//        if SCREEN_HEIGHT <= IPHONE_5 {
//            lblTitleHeightConst.constant = 0
//        } else if SCREEN_HEIGHT <= 667 {
//            lblTitleHeightConst.constant = 40
//        } else if SCREEN_HEIGHT <= 812 {
//            lblTitleHeightConst.constant = 80
//        } else {
//            lblTitleHeightConst.constant = 111
//        }
        buttonEnableDisable()
    }
    override func setupData() {
        
       // let countryText = selectedCountry.ShortName.uppercased() + " +" + selectedCountry.Code
        btnCountryCode.setTitle("+ 16", for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.isCountrySelected {
                self.btnCountryCode.setTitleColor(Theme.colors.textColor, for: .normal)
            } else {
                self.btnCountryCode.setTitleColor(Theme.colors.black_40_opacity, for: .normal)
            }
        }
       
        buttonEnableDisable()
    }
    
    override func buttonEnableDisable() {
        let name = txtFName.text?.trim
        let mobile = txtFMobileNo.text?.trim
        let email = txtFEmailAdd.text?.trim
        
        
        if name?.count == 0 || mobile?.count == 0 || email?.count == 0 {
            btnGetSMSCode.isUserInteractionEnabled = false
            btnGetSMSCode.backgroundColor = Theme.colors.gray_7E7E7E
            btnGetSMSCode.removeGradient()
        } else {
            btnGetSMSCode.isUserInteractionEnabled = true
            btnGetSMSCode.backgroundColor = UIColor.clear
            btnGetSMSCode.applyGradient(with: [Theme.colors.blue_83EAF1, Theme.colors.blue_63A4FF], gradient: .horizontal)
        }
    }
    
    func checkValidation() -> Bool {
        var isValid = true
        let strMobile = txtFMobileNo.text?.trim ?? ""
        
        if txtFName.text?.trim.count == 0 {
            isValid = false
            lblErrName.isHidden = false
            lblErrName.text = Theme.strings.alert_blank_fullname_error
        }
        
        if strMobile.count == 0 {
            isValid = false
            self.lblErrMobileNo.isHidden = false
            self.lblErrMobileNo.text = Theme.strings.alert_invalid_mobile_error
        } else if strMobile.count < 8 || strMobile.count > 13 {
            isValid = false
            self.lblErrMobileNo.isHidden = false
            self.lblErrMobileNo.text = Theme.strings.alert_invalid_mobile_error
        } else if strMobile.isPhoneNumber == false {
            isValid = false
            lblErrMobileNo.isHidden = false
            lblErrMobileNo.text = Theme.strings.alert_invalid_mobile_error
        }
        
        if txtFEmailAdd.text?.trim.count == 0 {
            isValid = false
            lblErrEmail.isHidden = false
            lblErrEmail.text = Theme.strings.alert_invalid_email_error
        } else if !txtFEmailAdd.text!.isValidEmail {
            isValid = false
            lblErrEmail.isHidden = false
            lblErrEmail.text = Theme.strings.alert_invalid_email_error
        }
        
        return isValid
    }
    
    // MARK: - ACTIONS
    @IBAction func onTappedCreateAccount(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if checkValidation() {
            lblErrName.isHidden = true
            lblErrMobileNo.isHidden = true
            lblErrEmail.isHidden = true
            
            isFromOTP = true
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:ProfileVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    @IBAction func onTappedCountryCode(_ sender: UIButton) {
        self.view.endEditing(true)
        isFromOTP = false
        
       let aVC = AppStoryBoard.main.viewController(viewControllerClass:CountryListVC.self)
//        aVC.didSelectCountry = { countryData in
//            self.selectedCountry = countryData
//            self.isCountrySelected = true
//            self.setupData()
//        }
        aVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(aVC, animated: true, completion: nil)
    }
    
    @IBAction func onTappedBack(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - UITextFieldDelegate
extension SignUpVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblErrName.isHidden = true
        lblErrMobileNo.isHidden = true
        lblErrEmail.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text,
              let textRange = Range(range, in: text) else {
            return false
        }
        
        let updatedText = text.replacingCharacters(in: textRange, with: string).trim
        
        if textField == txtFName && updatedText.count > 16 {
            return false
        } else if textField == txtFMobileNo && updatedText.count > 13 {
            return false
        }
        
        buttonEnableDisable()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        buttonEnableDisable()
        
    }
    
}
