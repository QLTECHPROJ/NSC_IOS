//
//  PersonalDetailsVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 06/05/22.
//

import UIKit

class PersonalDetailsVC: BaseViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    
    // TextFields
    @IBOutlet weak var txtDOB: DJPickerView!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
    @IBOutlet weak var txtCamps: UITextField!
    @IBOutlet weak var txtRole: UITextField!
    
    // Error Labels
    @IBOutlet weak var lblErrDOB: UILabel!
    @IBOutlet weak var lblErrStreet: UILabel!
    @IBOutlet weak var lblErrState: UILabel!
    @IBOutlet weak var lblErrCity: UILabel!
    @IBOutlet weak var lblErrPostCode: UILabel!
    @IBOutlet weak var lblErrCamps: UILabel!
    @IBOutlet weak var lblErrRole: UILabel!
    @IBOutlet weak var lblErrVaccinated: UILabel!
    
    // Vaccinated - Yes / No
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    
    
    // MARK: - VARIABLES
    var isFromEdit = false
    var arrayErrorLabels = [UILabel]()
    
    var selectedDOB = Date()
    var selectedState : ListItem?
    var selectedCity : ListItem?
    var selectedCamps : ListItem?
    var selectedRole : ListItem?
    var vaccinated = ""
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btnBack.isHidden = !isFromEdit
        
        setupUI()
        setupData()
    }
    
    
    // MARK: - FUNCTIONS
    override func setupUI() {
        arrayErrorLabels = [lblErrDOB, lblErrStreet, lblErrState, lblErrCity, lblErrPostCode, lblErrCamps, lblErrRole, lblErrVaccinated]
        
        for label in arrayErrorLabels {
            label.isHidden = true
        }
        
        btnYes.setImage(UIImage(named: "CheckDeselect"), for: .normal)
        btnNo.setImage(UIImage(named: "CheckDeselect"), for: .normal)
        
        txtState.isEnabled = false
        txtCity.isEnabled = false
        txtCamps.isEnabled = false
        txtRole.isEnabled = false
    }
    
    override func setupData() {
        if vaccinated == "1" {
            btnYes.setImage(UIImage(named: "CheckSelect"), for: .normal)
            btnNo.setImage(UIImage(named: "CheckDeselect"), for: .normal)
        } else if vaccinated == "0" {
            btnYes.setImage(UIImage(named: "CheckDeselect"), for: .normal)
            btnNo.setImage(UIImage(named: "CheckSelect"), for: .normal)
        }
        
        if let strName = selectedState?.Name {
            txtState.text = strName
        }
        
        if let strName = selectedCity?.Name {
            txtCity.text = strName
        }
        
        if let strName = selectedRole?.Name {
            txtRole.text = strName
        }
        
        initDOBPickerView()
        buttonEnableDisable()
    }
    
    private func initDOBPickerView() {
        let prevDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        var dob : Date?
        
        txtDOB.type = .date
        txtDOB.pickerDelegate = self
        txtDOB.datePicker?.datePickerMode = .date
        txtDOB.datePicker?.maximumDate = prevDate
        txtDOB.dateFormatter.dateFormat = Theme.dateFormats.DOB_App
        
        let strDOB = LoginDataModel.currentUser?.DOB ?? ""
        
        if strDOB.count > 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Theme.dateFormats.DOB_App
            dob = dateFormatter.date(from: strDOB)
            selectedDOB = dob ?? Date()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Theme.dateFormats.DOB_App
        dateFormatter.timeZone = TimeZone.current
        
        if let DOB = dob {
            txtDOB.text = dateFormatter.string(from: DOB)
            txtDOB.datePicker?.date = DOB
        } else {
            txtDOB.text = dateFormatter.string(from: prevDate)
            txtDOB.datePicker?.date = prevDate
        }
    }
    
    func setSelectedListItem(listType : ListItemType ,selectedItem : ListItem) {
        switch listType {
        case .state:
            self.selectedState = selectedItem
        case .city:
            self.selectedCity = selectedItem
        case .camp:
            self.selectedCamps = selectedItem
        case .role:
            self.selectedRole = selectedItem
        default:
            break
        }
        
        self.setupData()
    }
    
    override func buttonEnableDisable() {
        var shouldEnable = true
        
        if txtStreet.text?.trim.count == 0 || txtPostCode.text?.trim.count == 0 || vaccinated.trim.count == 0 {
            shouldEnable = false
        }
        
        if selectedState == nil || selectedCity == nil || selectedCamps == nil || selectedRole == nil {
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
        let strStreet = txtStreet.text?.trim ?? ""
        let strPostCode = txtPostCode.text?.trim ?? ""
        
        if txtDOB.text?.trim.count != 0 && selectedDOB.differenceWith(Date(), inUnit: NSCalendar.Unit.day) < 1 {
            isValid = false
            lblErrDOB.isHidden = false
            lblErrDOB.text = Theme.strings.alert_dob_error
        }
        
        if strStreet.count == 0 {
            isValid = false
            lblErrStreet.isHidden = false
            lblErrStreet.text = Theme.strings.alert_blank_lastname_error
        }
        
        if selectedState == nil {
            isValid = false
            lblErrState.isHidden = false
            lblErrState.text = Theme.strings.alert_blank_lastname_error
        }
        
        if selectedCity == nil {
            isValid = false
            lblErrCity.isHidden = false
            lblErrCity.text = Theme.strings.alert_blank_lastname_error
        }
        
        if strPostCode.count == 0 {
            isValid = false
            lblErrPostCode.isHidden = false
            lblErrPostCode.text = Theme.strings.alert_blank_lastname_error
        } else if strPostCode.count > 8 {
            isValid = false
            lblErrPostCode.isHidden = false
            lblErrPostCode.text = Theme.strings.alert_invalid_mobile_error
        } else if strPostCode.isNumber == false {
            isValid = false
            lblErrPostCode.isHidden = false
            lblErrPostCode.text = Theme.strings.alert_invalid_mobile_error
        }
        
        if selectedCamps == nil {
            isValid = false
            lblErrCamps.isHidden = false
            lblErrCamps.text = Theme.strings.alert_blank_lastname_error
        }
        
        if selectedRole == nil {
            isValid = false
            lblErrRole.isHidden = false
            lblErrRole.text = Theme.strings.alert_blank_lastname_error
        }
        
        if vaccinated.trim.count == 0 {
            isValid = false
            lblErrVaccinated.isHidden = false
            lblErrVaccinated.text = Theme.strings.alert_blank_lastname_error
        }
        
        return isValid
    }
    
    // MARK: - ACTIONS
    @IBAction func listViewClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        var listType = ListItemType(rawValue: sender.tag) ?? .state
        var strID = ""
        
        switch listType {
        case .country:
            break
        case .state:
            strID = AppVersionDetails.countryID
        case .city:
            if selectedState == nil {
                showAlertToast(message: "Please select state first")
                return
            }
            strID = selectedState?.ID ?? ""
        case .camp:
            listType = .role
            // showAlertToast(message: Theme.strings.alert_something_went_wrong)
            // return
        case .role:
            break
        }
        
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:ListItemVC.self)
        aVC.listType = listType
        aVC.strID = strID
        aVC.didSelectItem = { selectedItem in
            self.setSelectedListItem(listType: listType, selectedItem: selectedItem)
        }
        aVC.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(aVC, animated: true, completion: nil)
    }
    
    @IBAction func vaccinatedOptionClicked(_ sender: UIButton) {
        if sender == btnYes {
            vaccinated = "1"
        } else {
            vaccinated = "0"
        }
        
        setupData()
    }
    
    @IBAction func confirmClicked(_ sender: UIButton) {
        if checkValidation() {
            for label in arrayErrorLabels {
                label.isHidden = true
            }
            
            print("Call API")
        }
    }
    
}


// MARK: - UITextFieldDelegate
extension PersonalDetailsVC : UITextFieldDelegate {
    
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
        
        if textField == txtStreet && updatedText.count > 100 {
            return false
        } else if textField == txtPostCode {
            if !updatedText.isNumber || updatedText.count > 8 {
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


// MARK: - DJPickerViewDelegate
extension PersonalDetailsVC : DJPickerViewDelegate {
    
    func textPickerView(_ textPickerView: DJPickerView, didSelectDate date: Date) {
        self.view.endEditing(true)
        print("DOB :- ",date)
        selectedDOB = date
    }
    
}
