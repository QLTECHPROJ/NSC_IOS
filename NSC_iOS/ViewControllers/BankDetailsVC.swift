//
//  BankDetailsVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 06/05/22.
//

import UIKit

class BankDetailsVC: BaseViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var txtBankName: UITextField!
    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var txtAccountName: UITextField!
    @IBOutlet weak var txtIFSCCode: UITextField!
    
    @IBOutlet weak var lblErrBankName: UILabel!
    @IBOutlet weak var lblErrAccountNumber: UILabel!
    @IBOutlet weak var lblErrAccountName: UILabel!
    @IBOutlet weak var lblErrIFSCCode: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    
    
    // MARK: - VARIABLES
    var isFromEdit = false
    var arrayErrorLabels = [UILabel]()
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btnBack.isHidden = !isFromEdit
        
        setupUI()
        setupData()
        buttonEnableDisable()
    }
    
    
    // MARK: - FUNCTIONS
    override func setupUI() {
        arrayErrorLabels = [lblErrBankName, lblErrAccountNumber, lblErrAccountName, lblErrIFSCCode]
        
        for label in arrayErrorLabels {
            label.isHidden = true
        }
    }
    
    override func setupData() {
        guard let userData = LoginDataModel.currentUser else {
            return
        }
        
        if userData.Bank_Name.trim.count > 0 {
            txtBankName.text = userData.Bank_Name
        }
        
        if userData.Account_Number.trim.count > 0 {
            txtAccountNumber.text = userData.Account_Number
        }
        
        if userData.Account_Name.trim.count > 0 {
            txtAccountName.text = userData.Account_Name
        }
        
        if userData.IFSC_Code.trim.count > 0 {
            txtIFSCCode.text = userData.IFSC_Code
        }
        
        buttonEnableDisable()
    }
    
    override func buttonEnableDisable() {
        var shouldEnable = true
        
        if txtBankName.text?.trim.count == 0 || txtAccountNumber.text?.trim.count == 0 ||
            txtAccountName.text?.trim.count == 0 || txtIFSCCode.text?.trim.count == 0 {
            shouldEnable = false
        }
        
        if shouldEnable {
            btnConfirm.isUserInteractionEnabled = true
            btnConfirm.backgroundColor = Theme.colors.theme_dark
        } else {
            btnConfirm.isUserInteractionEnabled = false
            btnConfirm.backgroundColor = Theme.colors.gray_7E7E7E
            btnConfirm.removeGradient()
        }
    }
    
    func checkValidation() -> Bool {
        var isValid = true
        let strBankName = txtBankName.text?.trim ?? ""
        let strAccountNumber = txtAccountNumber.text?.trim ?? ""
        let strAccountName = txtAccountName.text?.trim ?? ""
        let strIFSCCode = txtIFSCCode.text?.trim ?? ""
        
        if strBankName.count == 0 {
            isValid = false
            lblErrBankName.isHidden = false
            lblErrBankName.text = Theme.strings.alert_blank_bankname_error
        }
        
        if strAccountNumber.count == 0 {
            isValid = false
            lblErrAccountNumber.isHidden = false
            lblErrAccountNumber.text = Theme.strings.alert_blank_accountnumber_error
        } else if strAccountNumber.count < 10 || strAccountNumber.count > 20 {
            isValid = false
            lblErrAccountNumber.isHidden = false
            lblErrAccountNumber.text = Theme.strings.alert_invalid_accountnumber_error
        } else if strAccountNumber.isNumber == false {
            isValid = false
            lblErrAccountNumber.isHidden = false
            lblErrAccountNumber.text = Theme.strings.alert_invalid_accountnumber_error
        }
        
        if strAccountName.count == 0 {
            isValid = false
            lblErrAccountName.isHidden = false
            lblErrAccountName.text = Theme.strings.alert_blank_accountname_error
        }
        
        if strIFSCCode.count == 0 {
            isValid = false
            lblErrIFSCCode.isHidden = false
            lblErrIFSCCode.text = Theme.strings.alert_blank_ifsccode_error
        } else if strIFSCCode.count < 6 || strIFSCCode.count > 10 {
            isValid = false
            lblErrIFSCCode.isHidden = false
            lblErrIFSCCode.text = Theme.strings.alert_invalid_ifsccode_error
        }
        
        return isValid
    }
    
    override func goNext() {
        let coachDetailVM = CoachDetailViewModel()
        coachDetailVM.callCoachDetailsAPI { success in
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: ProfileVC.self)
            aVC.makeRootController()
        }
    }
    
    
    // MARK: - ACTIONS
    @IBAction func backClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmClicked(_ sender: UIButton) {
        if checkValidation() {
            for label in arrayErrorLabels {
                label.isHidden = true
            }
            
            let parameters = ["coachId":LoginDataModel.currentUser?.ID ?? "",
                              "bankName":txtBankName.text ?? "",
                              "accountNumber":txtAccountNumber.text ?? "",
                              "accountName":txtAccountName.text ?? "",
                              "IFSCCode":txtIFSCCode.text ?? ""]
            
            let bankDetailVM = BankDetailViewModel()
            bankDetailVM.callUpdateBankDetailsAPI(parameters: parameters) { success in
                if success {
                    self.goNext()
                }
            }
        }
    }
    
}


// MARK: - UITextFieldDelegate
extension BankDetailsVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        for label in arrayErrorLabels {
            label.isHidden = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
              let textRange = Range(range, in: text) else {
            return false
        }
        
        let updatedText = text.replacingCharacters(in: textRange, with: string).trim
        
        if textField == txtIFSCCode && updatedText.count > 10 {
            return false
        } else if textField == txtAccountNumber {
            if !updatedText.isNumber || updatedText.count > 20 {
                return false
            }
        }
        
        buttonEnableDisable()
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        buttonEnableDisable()
    }
    
}
