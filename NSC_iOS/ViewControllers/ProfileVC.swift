//
//  ProfileVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 26/04/22.
//

import UIKit

class ProfileVC: BaseViewController {
    
    // MARK: - OUTLETS
    // UIImage
    @IBOutlet weak var imgUser: UIImageView!
    
    // UITextfield
    @IBOutlet weak var txtFDOB: DJPickerView!
    @IBOutlet weak var txtFMobileNo: UITextField!
    @IBOutlet weak var txtFEmailAdd: UITextField!
    
    // UIButton
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    
    // UILabel
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblErrName: UILabel!
    @IBOutlet weak var lblErrMobileNo: UILabel!
    @IBOutlet weak var lblErrEmail: UILabel!
    
    // MARK: - VARIABLES
    var isCountrySelected = false
    //var selectedCountry = CountrylistDataModel(id: "0", name: "Australia", shortName: "AU", code: "61")
    var strMobile:String?
    var selectedDOB = Date()
    var showDOBPopUp = true
   
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgUser.contentMode = .scaleAspectFill
        if strMobile != "" {
            txtFMobileNo.text = strMobile
        }
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    // MARK: - FUNCTIONS
    override func setupUI() {
       
        lblErrName.isHidden = true
        lblErrMobileNo.isHidden = true
        lblErrEmail.isHidden = true
        txtFDOB.delegate = self
        txtFMobileNo.delegate = self
        txtFEmailAdd.delegate = self
        txtFDOB.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: .editingChanged)
        
        //lblDOB.text = Theme.strings.date_of_birth
        //lblDOB.numberOfLines = 0
        buttonEnableDisable()
    }
    
    override func setupData() {
        showDOBPopUp = true
       // let countryText = selectedCountry.ShortName.uppercased() + " +" + selectedCountry.Code
        btnCountryCode.setTitle("+ 16", for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.isCountrySelected {
                self.btnCountryCode.setTitleColor(Theme.colors.textColor, for: .normal)
            } else {
                self.btnCountryCode.setTitleColor(Theme.colors.black_40_opacity, for: .normal)
            }
        }
        
        initDOBPickerView()
        
        buttonEnableDisable()
    }
    
    override func buttonEnableDisable() {
        let name = txtFDOB.text?.trim
        let mobile = txtFMobileNo.text?.trim
        let email = txtFEmailAdd.text?.trim
        
        
        if name?.count == 0 || mobile?.count == 0 || email?.count == 0 {
            btnConfirm.isUserInteractionEnabled = false
            btnConfirm.backgroundColor = Theme.colors.gray_7E7E7E
            btnConfirm.removeGradient()
        } else {
            btnConfirm.isUserInteractionEnabled = true
            btnConfirm.backgroundColor = Theme.colors.theme_dark
        }
    }
    
    func checkValidation() -> Bool {
        var isValid = true
        let strMobile = txtFMobileNo.text?.trim ?? ""
        
        if txtFDOB.text?.trim.count != 0 && selectedDOB.differenceWith(Date(), inUnit: NSCalendar.Unit.day) < 1 {
            isValid = false
            lblErrName.isHidden = false
            lblErrName.text = Theme.strings.alert_dob_error
            return false
        }
        
        if strMobile.count == 0 {
            isValid = false
            self.lblErrMobileNo.isHidden = false
            self.lblErrMobileNo.text = Theme.strings.alert_invalid_mobile_error
        } else if strMobile.count < 4 || strMobile.count > 15 {
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
   
    private func initDOBPickerView() {
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let currentDate = calendar.date(from: components)!
        
        let dateComponents = DateComponents()
        //        dateComponents.year = -4
        
        var tenYearsAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        txtFDOB.type = .date
        txtFDOB.pickerDelegate = self
        txtFDOB.datePicker?.datePickerMode = .date
        txtFDOB.datePicker?.maximumDate = tenYearsAgo
        txtFDOB.dateFormatter.dateFormat = Theme.dateFormats.DOB_App
        
       // if let userData = CoUserDataModel.currentUser {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Theme.dateFormats.DOB_App
        let dateValue = dateFormatter.string(from:currentDate)
        tenYearsAgo = dateFormatter.date(from:dateValue)
      //  }
        
        //let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Theme.dateFormats.DOB_App
        dateFormatter.timeZone = TimeZone.current
        if tenYearsAgo != nil {
            txtFDOB.text = dateFormatter.string(from: tenYearsAgo!)
            txtFDOB.datePicker?.date = tenYearsAgo!
            selectedDOB = tenYearsAgo!
           // lblDOB.isHidden = txtFDOB.text?.count == 0
           // CoUserDataModel.currentUser?.DOB = txtFDOB.text ?? ""
        }
        
        //txtDOBTopConst.constant = (txtFDOB.text?.count == 0) ? 0 : 10
    }
    @objc func textFieldValueChanged(textField : UITextField ) {
       // lblDOB.text = (txtFDOB.text?.count == 0) ? "" : Theme.strings.date_of_birth
        self.view.layoutIfNeeded()
    }
    
    func showAlertForDOB() {
//        let aVC = AppStoryBoard.manage.viewController(viewControllerClass: AlertPopUpVC.self)
//        aVC.titleText = ""
//        aVC.detailText = Theme.strings.alert_dob_slab_change
//        aVC.firstButtonTitle = Theme.strings.ok
//        aVC.hideSecondButton = true
//        aVC.modalPresentationStyle = .overFullScreen
//        aVC.delegate = self
//        self.present(aVC, animated: true, completion: nil)
    }
    //MARK:- IMAGE UPLOAD
    func handleImageOptions(buttonTitle : String) {
        switch buttonTitle {
        case Theme.strings.take_a_photo:
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                    let picker = UIImagePickerController()
                    picker.sourceType = .camera
                    picker.delegate = self
                    picker.allowsEditing = true
                    self.present(picker, animated: true, completion: nil)
                }
                else {
                    showAlertToast(message: Theme.strings.alert_camera_not_available)
                }
            }
        case Theme.strings.choose_from_gallary:
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            }
        case Theme.strings.remove_photo:
            print("Remove photo")
            //self.callRemoveProfileImageAPI()
        default:
            break
        }
        
    }
    
    // MARK: - ACTION
    @IBAction func backClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if checkValidation() {
            lblErrName.isHidden = true
            lblErrMobileNo.isHidden = true
            lblErrEmail.isHidden = true
            
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:ProfileStatusVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
    }
    
    @IBAction func updateClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func editClicked(_ sender: UIButton) {
        if checkInternet(showToast: true) == false {
            return
        }
        
        self.view.endEditing(true)
        var arrayTitles = [Theme.strings.take_a_photo, Theme.strings.choose_from_gallary]
        if let imageStr = LoginDataModel.currentUser?.Profile_Image, imageStr.trim.count > 0 {
            arrayTitles.append(Theme.strings.remove_photo)
        }
        
        showActionSheet(title: "", message: Theme.strings.profile_image_options, titles: arrayTitles, cancelButtonTitle: Theme.strings.cancel_small) { (buttonTitle) in
            DispatchQueue.main.async {
                self.handleImageOptions(buttonTitle: buttonTitle)
            }
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension ProfileVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFDOB && showDOBPopUp {
            showDOBPopUp = false
            showAlertForDOB()
            return false
        }
        return true
    }
    
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
        
        if textField == txtFDOB && updatedText.count > 16 {
            return false
        } else if textField == txtFMobileNo && updatedText.count > 15 {
            return false
        }
        
        buttonEnableDisable()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        buttonEnableDisable()
        
    }
    
}
// MARK: - DJPickerViewDelegate
extension ProfileVC : DJPickerViewDelegate {
    
    func textPickerView(_ textPickerView: DJPickerView, didSelectDate date: Date) {
        print("Date :- ",date)
        selectedDOB = date
        //lblDOB.text = (txtFDOB.text?.count == 0) ? "" : Theme.strings.date_of_birth
        self.view.layoutIfNeeded()
        
        buttonEnableDisable()
    }
    
}


// MARK: - AlertPopUpVCDelegate
//extension ProfileVC : AlertPopUpVCDelegate {
//
//    func handleAction(sender: UIButton, popUpTag: Int) {
//        if sender.tag == 0 {
//            txtFDOB.becomeFirstResponder()
//        }
//    }
//
//}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imgUser.image = image
            //imageData = UploadDataModel(name: "image.jpeg", key: "ProfileImage", data: image.jpegData(compressionQuality: 0.5), extention: "jpeg", mimeType: "image/jpeg")
            //self.callAddProfileImageAPI()
        }
        else if let image = info[.originalImage] as? UIImage {
            imgUser.image = image
            //imageData = UploadDataModel(name: "image.jpeg", key: "ProfileImage", data: image.jpegData(compressionQuality: 0.5), extention: "jpeg", mimeType: "image/jpeg")
            //self.callAddProfileImageAPI()
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       
        picker.dismiss(animated: true, completion: nil)
    }
    
}


