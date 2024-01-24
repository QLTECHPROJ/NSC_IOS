//
//  PersonalDetailsVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 06/05/22.
//

import UIKit

class PersonalDetailsVC: ClearNaviagtionBarVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnConfirm: AppThemeButton!
    
    // TextFields
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPostCode: UITextField!
    @IBOutlet weak var txtCamps: UITextField!
    @IBOutlet weak var txtRole: UITextField!
    
    // Error Labels
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var lblStreetAddress: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblPostCode: UILabel!
    @IBOutlet weak var lblSelectCamps: UILabel!
    @IBOutlet weak var lblSelectYourRole: UILabel!
    @IBOutlet weak var lblVaccinated: UILabel!
    
    // Vaccinated - Yes / No
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    
    
    // MARK: - VARIABLES
   
    var isFromEdit = false
    
    var selectedDOB = Date()
    var selectedState : ListItem?
    var selectedCity : ListItem?
    var selectedCamps : ListItem?
    var selectedRole : ListItem?

    var vaccinated = ""
    let bodDatePicker = UIDatePicker()
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    
    // MARK: - FUNCTIONS
    private func setUpView(){
        self.configureUI()
        self.initDatePicker()
        self.setUpData()
        self.setupInitialData()
    }
    
    
    private func configureUI(){
        self.title = kPersonalDetails
        
        self.btnBack.isHidden = !isFromEdit
                
        self.lblDOB.applyLabelStyle(text: kDOB, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.lblStreetAddress.applyLabelStyle(text: kStreetAddress, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.lblState.applyLabelStyle(text: kState, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.lblCity.applyLabelStyle(text: kCity, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.lblPostCode.applyLabelStyle(text: kPostCode, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.lblSelectCamps.applyLabelStyle(text: kSport, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.lblSelectYourRole.applyLabelStyle(text: kRole, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.lblVaccinated.applyLabelStyle(text: kAreYouVaccinated, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        
        self.txtDOB.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        
        self.txtStreet.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        
        self.txtState.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        self.txtState.isEnabled = false
        
        self.txtCity.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        self.txtCity.isEnabled = false
        
        self.txtPostCode.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        
        self.txtCamps.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        self.txtCamps.isEnabled = false
        
        self.txtRole.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        self.txtRole.isEnabled = false
        
        self.btnYes.applystyle(fontname: .SFProDisplayRegular, fontsize: 13.0, titleText: kYes, titleColor: .colorAppTextBlack)
        self.btnNo.applystyle(fontname: .SFProDisplayRegular, fontsize: 13.0, titleText: kNo, titleColor: .colorAppTextBlack)
        self.btnConfirm.setTitle(kConfirm, for: .normal)
        
        self.btnYes.setContentEdges(titleEngesLeft:  -20, ImageEngesLeft:  -30, titleEngesRight:  0, ImageEngesRight: 0)
        
        self.btnNo.setContentEdges(titleEngesLeft:  -20, ImageEngesLeft:  -30, titleEngesRight:  0, ImageEngesRight: 0)
    }
    
    private func setUpData(){
        
        if let strName = selectedState?.Name {
            txtState.text = strName
        } else {
            txtState.text = ""
        }
        
        if let strName = selectedCity?.Name {
            txtCity.text = strName
        } else {
            txtCity.text = ""
        }
        
        if let strName = selectedCamps?.Name {
            txtCamps.text = strName
        } else {
            txtCamps.text = ""
        }
        
        if let strName = selectedRole?.Name {
            txtRole.text = strName
        } else {
            txtRole.text = ""
        }
        
        if  txtState.text != "" {
            self.title = kPersonalDetails
        }else {
            self.title = kAddPersonalDetails
        }
        
        self.btnEnableDisable()
    }
    
    func setupInitialData() {
        if let userData = LoginDataModel.currentUser {
            if userData.Address.trim.count > 0 {
                txtStreet.text = userData.Address
            }
            
            if userData.State.trim.count > 0 && userData.StateName.trim.count > 0 {
                selectedState = ListItem(id: userData.State, name: userData.StateName)
            }
            
            if userData.City.trim.count > 0 && userData.CityName.trim.count > 0 {
                selectedCity = ListItem(id: userData.City, name: userData.CityName)
            }
            
            if userData.SportId.trim.count > 0 && userData.SportName.trim.count > 0 {
                selectedCamps = ListItem(id: userData.SportId, name: userData.SportName)
            }
            
            if userData.RoleId.trim.count > 0 && userData.Role.trim.count > 0 {
                selectedRole = ListItem(id: userData.RoleId, name: userData.Role)
            }
            
            if userData.PostCode.trim.count > 0 {
                txtPostCode.text = userData.PostCode
            }
            
            if self.vaccinated.trim.count == 0 {
                vaccinated = userData.Vaccinated
                
                self.setVaccinatedUser(userData.Vaccinated == "1" ? 1 : 0)
            }
            
            if userData.DOB.trim.count  > 0 {
                txtDOB.text = userData.DOB
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = Theme.dateFormats.DOB_App
                if let _ = dateFormatter.date(from: userData.DOB){
                    self.selectedDOB = dateFormatter.date(from: userData.DOB)!
                }
            }
        }
        
        self.setUpData()
    }
    
    func initDatePicker(){
        self.bodDatePicker.datePickerMode = .date
        self.bodDatePicker.maximumDate = Date()
        self.txtDOB.inputView = self.bodDatePicker
        
        if #available(iOS 14, *) {// Added condition for iOS 14
            self.bodDatePicker.preferredDatePickerStyle  = .wheels
            self.bodDatePicker.sizeToFit()
        }
        
        let dateFormattor = DateFormatter()
        self.bodDatePicker.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Theme.dateFormats.DOB_App
        self.txtDOB.text = dateFormatter.string(from: sender.date)
        let dob = dateFormatter.date(from: txtDOB.text ?? "")
        selectedDOB = dob ?? Date()
    }
    
    func setSelectedListItem(listType : ListItemType ,selectedItem : ListItem) {
        switch listType {
        case .state:
            self.selectedState = selectedItem
            self.selectedCity = nil
        case .city:
            self.selectedCity = selectedItem
        case .sport:
            self.selectedCamps = selectedItem
        case .role:
            self.selectedRole = selectedItem
       
        default:
            break
        }
        
        self.setUpData()
    }
    
    private func btnEnableDisable() {
        
        var shouldEnable = true
        
        if self.txtStreet.text!.trim.isEmpty || self.txtPostCode.text!.trim.isEmpty || self.vaccinated.trim.isEmpty {
            shouldEnable = false
        }
        
        if self.selectedState == nil || self.selectedCity == nil || self.selectedCamps == nil || self.selectedRole == nil {
            shouldEnable = false
        }
        self.btnConfirm.isSelect = shouldEnable
    }
    
    func checkValidation() -> Bool {
        
        self.view.endEditing(true)
        
        var isValid = true
        let strStreet = txtStreet.text?.trim ?? ""
        let strPostCode = txtPostCode.text?.trim ?? ""
        
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = Theme.dateFormats.DOB_App
        let dOBTemp = dateformattor.date(from: self.txtDOB.text!)
        
        if txtDOB.text?.trim.count == 0{
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_dob_error)
            
        }
        
        if let _ = dOBTemp, selectedDOB.differenceWith(Date(), inUnit: NSCalendar.Unit.year) < 18{
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_dob_error)
        }
        
        if strStreet.count == 0 {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_blank_street_error)
            
        }
        
        if selectedState == nil {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_select_state)
        }
        
        if selectedCity == nil {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_select_city)
            
        }
        
        if strPostCode.count == 0 {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_postcode_error)
            
        } else if strPostCode.count < AppVersionDetails.postCodeMinDigits || strPostCode.count > AppVersionDetails.postCodeMaxDigits {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_postcode_error)
            
        } else if strPostCode.isNumber == false {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_postcode_error)
        }
        
        if selectedCamps == nil {
    
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_select_sport)
        }
        
        if selectedRole == nil {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_select_role)
        }
        
        if vaccinated.trim.count == 0 {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_blank_vaccination_error)
        }
        
        return isValid
    }
    
    private func goNextScreen(){
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
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func listViewClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let listType = ListItemType(rawValue: sender.tag) ?? .state
        var strID = ""
        
        switch listType {
        case .country:
            break
        case .state:
            strID = AppVersionDetails.countryID
        case .city:
            if selectedState == nil {
                
                GFunctions.shared.showSnackBar(message: kPleaseSelectStateFirst)
                return
            }
            strID = selectedState?.ID ?? ""
        case .sport:
            break
        case .role:
            break
        }
        
        
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:ListItemVC.self)
        aVC.listType = listType
        aVC.strID = strID
        aVC.modalPresentationStyle = .overFullScreen
        UIApplication.topViewController()?.present(aVC, animated: false, completion :{
            aVC.openPopUpVisiable()
        })
        aVC.completionBlock = { receviceData , completion , type in
            if let data = receviceData , type == listType{
                self.setSelectedListItem(listType: listType, selectedItem: data)
            }
        }
    }
    
    @IBAction func vaccinatedOptionClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.setVaccinatedUser(sender.tag)
    }
    
    private func setVaccinatedUser(_ tag : Int = 1){
        if tag == 1{
            vaccinated = "1"
            self.btnYes.isSelected = true
            self.btnNo.isSelected = false
        }
        else{
            vaccinated = "0"
            self.btnNo.isSelected = true
            self.btnYes.isSelected = false
        }
        self.btnEnableDisable()
    }
    
    @IBAction func confirmClicked(_ sender: UIButton) {
        if checkValidation() {
           
            var parameters = ["coachId":LoginDataModel.currentUser?.ID ?? "",
                              "dob":txtDOB.text ?? "",
                              "country":AppVersionDetails.countryCode,
                              "state":selectedState?.ID ?? "",
                              "city":selectedCity?.ID ?? ""]
            
            parameters["address"] = txtStreet.text ?? ""
            parameters["postCode"] = txtPostCode.text ?? ""
            parameters["role"] = selectedRole?.ID ?? ""
            parameters["vaccinated"] = vaccinated
            parameters["sport_id"] = selectedCamps?.ID ?? ""
            
            let personalDetailVM = PersonalDetailViewModel()
            personalDetailVM.callUpdatePersonalDetailsAPI(parameters: parameters) { success in
                if success {
                    self.goNextScreen()
                }
            }
        }
    }
    
}


// MARK: - UITextFieldDelegate
extension PersonalDetailsVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      
        if self.txtDOB == textField, self.txtDOB.text!.trim.isEmpty{
            let dateformattor = DateFormatter()
            dateformattor.dateFormat = Theme.dateFormats.DOB_App
            self.txtDOB.text = dateformattor.string(from: Date())
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text,
              let textRange = Range(range, in: text) else {
            return false
        }
        
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        
        if textField == txtStreet && updatedText.count > 100 {
            return false
        } else if textField == txtPostCode {
            if !updatedText.isNumber || updatedText.count > AppVersionDetails.postCodeMaxDigits {
                return false
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtDOB {
            
            self.txtStreet.becomeFirstResponder()
            
        } else if textField == self.txtStreet {
            
            self.txtPostCode.becomeFirstResponder()
        }
        else if textField == self.txtPostCode {
            
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.btnEnableDisable()
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
