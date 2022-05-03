//
//  LoginVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class LoginVC: BaseViewController {
    
    // MARK: - OUTLETS
    //UILabel
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblErrMobileNo: UILabel!
    @IBOutlet weak var lblPrivacy: TTTAttributedLabel!
    @IBOutlet weak var lblSupport: TTTAttributedLabel!
    
    //UIButton
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var btnGetSMSCode: UIButton!
    
    //UITextfield
    @IBOutlet weak var txtFMobileNo: UITextField!
    
    //UIStackView
    @IBOutlet weak var stackView: UIStackView!
    
    // MARK: - VARIABLES
    var mobileNo = ""
    var isFromOTP = false
    var isCountrySelected = false
   // var selectedCountry = CountrylistDataModel(id: "0", name: "Australia", shortName: "AU", code: "61")
   
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPrivacyLabel(lblPrivacy: lblPrivacy)
        setupSupportLabel(lblSupport: lblSupport)
        setupData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFromOTP {
            txtFMobileNo.becomeFirstResponder()
        } else {
            txtFMobileNo.text = ""
           // selectedCountry = CountrylistDataModel(id: "0", name: "Australia", shortName: "AU", code: "61")
           // let countryText = selectedCountry.ShortName.uppercased() + " +" + selectedCountry.Code
            btnCountryCode.setTitle("+ 61", for: .normal)
            self.btnCountryCode.setTitleColor(Theme.colors.black_40_opacity, for: .normal)
        }
        
        buttonEnableDisable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    // MARK: - FUNCTIONS
    override func setupUI() {
        txtFMobileNo.delegate = self
        lblTitle.text = Theme.strings.login_title
        lblSubTitle.attributedText = Theme.strings.login_subtitle.attributedString(alignment: .center, lineSpacing: 5)
    }
    
    override func setupData() {
        if mobileNo.trim.count > 0 {
            txtFMobileNo.text = mobileNo
            mobileNo = ""
        }
        
        let countryText = ""
        btnCountryCode.setTitle(countryText, for: .normal)
        
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
        let mobile = txtFMobileNo.text?.trim
        
        if mobile?.count == 0 {
            btnGetSMSCode.isUserInteractionEnabled = false
            btnGetSMSCode.backgroundColor = Theme.colors.gray_7E7E7E
            btnGetSMSCode.removeGradient()
        } else {
            btnGetSMSCode.isUserInteractionEnabled = true
            btnGetSMSCode.backgroundColor = Theme.colors.theme_dark
        }
    }
    
    func checkValidation() -> Bool {
        var isValid = true
        let strMobile = txtFMobileNo.text?.trim ?? ""
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
        
        return isValid
    }
    
    // MARK: - ACTIONS
    @IBAction func countryCodeClicked(_ sender: UIButton) {
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
    
    @IBAction func loginClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if checkValidation(){
            lblErrMobileNo.isHidden = true
            isFromOTP = true
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:OTPVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
}


// MARK: - UITextFieldDelegate
extension LoginVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.lblErrMobileNo.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        buttonEnableDisable()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string).trim
            if !updatedText.isNumber || updatedText.count > 13 {
                return false
            }
        }
        
        let inValidCharacterSet = NSCharacterSet.whitespaces
        guard let firstChar = string.unicodeScalars.first else {
            return true
        }
        
        return !inValidCharacterSet.contains(firstChar)
    }
    
}

