//
//  BankDetailsVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 06/05/22.
//

import UIKit

class BankDetailsVC: ClearNaviagtionBarVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var txtBankName: UITextField!
    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var txtAccountName: UITextField!
    @IBOutlet weak var txtIFSCCode: UITextField!
    
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblAccountHolderName: UILabel!
    @IBOutlet weak var lblIFSCCode: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnConfirm: AppThemeButton!
    
    
    
    // MARK: - VARIABLES
    var isFromEdit = false

    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    
    // MARK: - FUNCTIONS
    private func setUpView(){
        self.configureUI()
        self.setUpData()
    }
    
    private func configureUI(){
        self.btnBack.isHidden = !isFromEdit
        
        self.lblBankName.applyLabelStyle(text: kBankName, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.lblAccountNumber.applyLabelStyle(text: kAccountNumber, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.lblAccountHolderName.applyLabelStyle(text: kAccountName, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.lblIFSCCode.applyLabelStyle(text: kIFSCCode, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        
        self.txtBankName.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        self.txtAccountNumber.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        self.txtAccountName.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        self.txtIFSCCode.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        
        self.btnConfirm.setTitle(kConfirm, for: .normal)
    }
    
    private func setUpData() {
        
        guard let userData = LoginDataModel.currentUser else {
            return
        }
        
        if userData.Bank_Name.trim.count > 0 {
            self.txtBankName.text = userData.Bank_Name
        }
        
        if userData.Account_Number.trim.count > 0 {
            self.txtAccountNumber.text = userData.Account_Number
        }
        
        if userData.Account_Name.trim.count > 0 {
            self.txtAccountName.text = userData.Account_Name
        }
        
        if userData.IFSC_Code.trim.count > 0 {
            self.txtIFSCCode.text = userData.IFSC_Code
        }
        
        if  userData.Bank_Name != "" {
            self.title = kBankDetails
        }else {
            self.title = kAddBankDetails
        }
        
        self.btnEnableDisable()
    }
    
    private func btnEnableDisable() {
        var shouldEnable = true
        
        let userData = LoginDataModel.currentUser
        
        let strBankName = self.txtBankName.text?.trim
        let strAccountNumber = self.txtAccountNumber.text?.trim
        let strAccountName = self.txtAccountName.text?.trim
        let strIFSCCode = self.txtIFSCCode.text?.trim
        
        
        if strBankName?.count == 0 || strAccountNumber?.count == 0 ||
            strAccountName?.count == 0 || strIFSCCode?.count == 0 {
            shouldEnable = false
        }
        
        if strBankName == userData?.Bank_Name &&
            strAccountNumber == userData?.Account_Number &&
            strAccountName == userData?.Account_Name &&
            strIFSCCode == userData?.IFSC_Code {
            shouldEnable = false
        }
        
        if shouldEnable {
            
            self.btnConfirm.isSelect = true
            
        } else {
            
            self.btnConfirm.isSelect = false
        }
    }
    
    func checkValidation() -> Bool {
        
        self.view.endEditing(true)
        
        var isValid = true
        let strBankName = self.txtBankName.text?.trim ?? ""
        let strAccountNumber = self.txtAccountNumber.text?.trim ?? ""
        let strAccountName = self.txtAccountName.text?.trim ?? ""
        let strIFSCCode = self.txtIFSCCode.text?.trim ?? ""
        
        if strBankName.count == 0 {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_blank_bankname_error)
        }
        
        if strAccountNumber.count == 0 {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_accountnumber_error)
            
        } else if strAccountNumber.count < 10 || strAccountNumber.count > 20 {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_accountnumber_error)
            
        } else if strAccountNumber.isNumber == false {
           
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_accountnumber_error)
            
        }
        
        if strAccountName.count == 0 {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_blank_accountname_error)
            
        }
        
        if strIFSCCode.count == 0 {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_ifsccode_error)
            
        } else if strIFSCCode.count < 6 || strIFSCCode.count > 20 {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_ifsccode_error)
        }
        
        return isValid
    }
    
    private func goNextScreen() {
        let coachDetailVM = CoachDetailViewModel()
        coachDetailVM.callCoachDetailsAPI { success in
            
            self.fetchCoachDetails()
            
            if self.isFromEdit {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.handleLoginUserRedirection()
            }
        }
    }
    
    
    // MARK: - ACTIONS
    @IBAction func backClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmClicked(_ sender: UIButton) {
        if checkValidation() {
           
            let parameters = ["coachId":LoginDataModel.currentUser?.ID ?? "",
                              "bankName":txtBankName.text ?? "",
                              "accountNumber":txtAccountNumber.text ?? "",
                              "accountName":txtAccountName.text ?? "",
                              "IFSCCode":txtIFSCCode.text ?? ""]
            
            let bankDetailVM = BankDetailViewModel()
            bankDetailVM.callUpdateBankDetailsAPI(parameters: parameters) { success in
                if success {
                    self.goNextScreen()
                }
            }
        }
    }
}


// MARK: - UITextFieldDelegate
extension BankDetailsVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
              let textRange = Range(range, in: text) else {
            return false
        }
        
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        
        if textField == self.txtIFSCCode && updatedText.count > 20 {
            return false
        } else if textField == self.txtAccountNumber {
            if !updatedText.isNumber || updatedText.count > 20 {
                return false
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtBankName {
            
            self.txtAccountNumber.becomeFirstResponder()
            
        } else if textField == self.txtAccountNumber {
            
            self.txtAccountName.becomeFirstResponder()
        }
        else if textField == self.txtAccountName {
            
            self.txtIFSCCode.becomeFirstResponder()
        }
        else if textField == self.txtIFSCCode {
            
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.btnEnableDisable()
    }
}
