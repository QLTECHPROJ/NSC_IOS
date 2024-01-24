//
//  EditProfileVC.swift
//  NSC_iOS
//
//  Created by vishal parmar on 21/10/23.
//

import UIKit
import AVFoundation

class EditProfileVC: ClearWhiteNaviagtionBarVC {
    
    // MARK: - OUTLETS
    // UIImage
    @IBOutlet weak var vwTopCurve : SemiCirleView!
    
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var imgUser: ProfileImageViewWithBorder!
    
    // UITextfield
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var txtMobileNo: UITextField!
    @IBOutlet weak var txtFName: UITextField!
    @IBOutlet weak var txtLName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    // UIButton
    
    @IBOutlet weak var btnUpdate: AppThemeButton!
    @IBOutlet weak var btnDeleteAccount: AppThemeBorderButton!
    
    // UILabel
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblMobileNo: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    
    // MARK: - VARIABLES
    
    var strImage : String?
    var imageData = UploadDataModel()
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }
    
    
    // MARK: - FUNCTIONS
    
    private func setUpView(){
        self.configureUI()
        self.setUpData()
        self.fetchCoachDetails {
            self.setUpData()
        }
    }
    
    private func configureUI(){
        self.title = "" //kEditProfile
        
        self.lblMobileNo.applyLabelStyle(text: kMobileNumber, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.lblFirstName.applyLabelStyle(text: kFirstName, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.lblLastName.applyLabelStyle(text: kLastName, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.lblEmail.applyLabelStyle(text: kEmailAddress, fontSize: 13.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        
        self.txtCountryCode.applyStyleTextField(textColor :.colorAppTxtFieldGray ,fontsize: 13.0, fontname: .SFProDisplayMedium)
        
        self.txtCountryCode.isEnabled = false
        
        
        self.txtMobileNo.applyStyleTextField(textColor :.colorAppTxtFieldGray ,fontsize: 13.0, fontname: .SFProDisplayMedium)
        self.txtMobileNo.isEnabled = false
        
        self.txtFName.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        
        self.txtLName.applyStyleTextField(placeholder : "", fontsize: 13.0, fontname: .SFProDisplayMedium)
        
        self.txtEmail.applyStyleTextField(textColor :.colorAppTxtFieldGray ,fontsize: 13.0, fontname: .SFProDisplayMedium)
        self.txtEmail.isEnabled = false
        self.btnDeleteAccount.setTitle(kDeleteAccount, for: .normal)
        self.btnDeleteAccount.setContentEdges(titleEngesLeft:  10)
        self.btnDeleteAccount.borderColorForBtn = .clear
    }
    
    private func setUpData(){
        
        self.txtCountryCode.text = "\(JSON(AppVersionDetails.countryShortName as Any).stringValue) +\(JSON(AppVersionDetails.countryCode as Any).stringValue)"
        self.imgFlag.sd_setImage(with: JSON(AppVersionDetails.countryIcon as Any).stringValue.url(), placeholderImage: nil, context: nil)
        
        if let userData = LoginDataModel.currentUser {
            txtMobileNo.text = userData.Mobile
            txtFName.text = userData.Fname
            txtLName.text = userData.Lname
            txtEmail.text = userData.Email
        
            strImage = userData.Profile_Image
            self.imgUser.image = UIImage()
            self.imgUser.sd_setImage(with: userData.Profile_Image.url(), placeholderImage: UIImage(named: "defaultUserIcon")!, context: nil)
        }
        
        self.btnEnableDisable()
    }

    
    private func btnEnableDisable() {
        var shouldEnable = false
        
        if LoginDataModel.currentUser?.Fname != txtFName.text && txtFName.text?.trim.count != 0 {
            shouldEnable = true
        }
        
        if LoginDataModel.currentUser?.Lname != txtLName.text && txtLName.text?.trim.count != 0 {
            shouldEnable = true
        }
        
        if LoginDataModel.currentUser?.Profile_Image != strImage && strImage?.trim.count != 0 {
            shouldEnable = true
        }
        
        self.btnUpdate.isSelect = shouldEnable
        
    }
    
    func checkValidation() -> Bool {
        self.view.endEditing(true)
        var isValid = true
        
        if txtFName.text?.trim.count == 0 {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_blank_firstname_error)

        }
        
        if txtLName.text?.trim.count == 0 {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_blank_lastname_error)
    
        }
        
        if self.txtMobileNo.text?.trim.count == 0 {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_mobile_error)
            
        }
        else if self.txtMobileNo.text!.trim.count < AppVersionDetails.mobileMinDigits || self.txtMobileNo.text!.trim.count > AppVersionDetails.mobileMaxDigits {
        
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_mobile_error)
            
        } else if self.txtMobileNo.text?.trim.isPhoneNumber == false {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_mobile_error)
            
        }
        
        if txtEmail.text?.trim.count == 0 {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_email_error)
            
        } else if !txtEmail.text!.isValidEmail {
            
            isValid = false
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_invalid_email_error)
            
        }
        
        return isValid
    }
    
    
    //MARK:- IMAGE UPLOAD
    func handleImageOptions(buttonTitle : String) {
        
        switch buttonTitle {
        case Theme.strings.take_a_photo:
            checkCameraAccess()
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
            LoginDataModel.currentUser?.Profile_Image = ""
        default:
            break
        }
    }
    
    func checkCameraAccess() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .notDetermined:
            requestCameraPermission()
            
        case .authorized:
            presentCamera()
            
        case .restricted, .denied:
            presentCameraSettings()
        default:
            break
        }
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
            self.presentCamera()
        })
    }
    
    func presentCamera() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
            } else {
            
                GFunctions.shared.showSnackBar(message: Theme.strings.alert_camera_not_available)
            }
        }
    }

    func presentCameraSettings() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Need Camera Access",
            message: "Camera access is required to make full use of this app.",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:]
                                      , completionHandler: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - ACTION
    @IBAction func backClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updateClicked(_ sender: UIButton) {
        
        if checkValidation() {
           
            let parameters = ["coachId":LoginDataModel.currentUser?.ID ?? "",
                              "fname":txtFName.text ?? "",
                              "lname":txtLName.text ?? "",
                              "profileImage":strImage ?? ""]
            
            let profileVM = ProfileViewModel()
            profileVM.callProfileUpdateAPI(parameters: parameters, uploadParameters: [imageData]) { success in
                if success {
                    self.fetchCoachDetails {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func editClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        if checkInternet(showToast: true) == false {
            return
        }
        
        let arrayTitles = [Theme.strings.take_a_photo, Theme.strings.choose_from_gallary]
        
        showActionSheet(title: "", message: Theme.strings.profile_image_options, titles: arrayTitles, cancelButtonTitle: Theme.strings.cancel_small) { (buttonTitle) in
            DispatchQueue.main.async {
                self.handleImageOptions(buttonTitle: buttonTitle)
            }
        }
    }
    
    @IBAction func onTappedDeleteAccount(_ sender: UIButton) {
        
        if checkInternet(showToast: true) == false {
            return
        }
        
        let vc = AppStoryBoard.main.viewController(viewControllerClass: AlertPopUpVC.self)
        vc.alertType = .deleteAccount
        vc.modalPresentationStyle = .overFullScreen
        
        UIApplication.topViewController()?.present(vc, animated: false, completion :{
            vc.openPopUpVisiable()
        })
        
        vc.completionBlock = { completion , type in
            
            if completion , type == .deleteAccount{
                
                if checkInternet(showToast: true) == false {
                    return
                }
                
                let deleteCoachVM = DeleteCoachViewModel()
                deleteCoachVM.callDeleteCoachAPI(completion: { success in
                    APPDELEGATE.logout()
                })
            }
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension EditProfileVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
     
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtFName {
            
            self.txtLName.becomeFirstResponder()
        } else if textField == self.txtLName {
            
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text, let textRange = Range(range, in: text) else {
            return false
        }
        
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        
        if textField == txtFName || textField == txtLName {
            if updatedText.count > 16 {
                return false
            }
        } else if textField == txtMobileNo {
            if !updatedText.isNumber || updatedText.count > AppVersionDetails.mobileMaxDigits {
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.btnEnableDisable()
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension EditProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imgUser.image = image
            
            imageData = UploadDataModel(name: "image.jpeg", key: "profileImage", data: image.jpegData(compressionQuality: 0.5), extention: "jpeg", mimeType: "image/jpeg")
            self.strImage = imageData.name
            
            self.btnEnableDisable()
            
        } else if let image = info[.originalImage] as? UIImage {
            imgUser.image = image
            imageData = UploadDataModel(name: "image.jpeg", key: "profileImage", data: image.jpegData(compressionQuality: 0.5), extention: "jpeg", mimeType: "image/jpeg")
            self.strImage = imageData.name
            
            self.btnEnableDisable()
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

//----------------------------------------------------------------------------
//MARK: - Class observers Methods
//----------------------------------------------------------------------------
extension EditProfileVC{
    
    func addClassObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationGetAppVersionsDetails(notification:)), name: NSNotification.Name.appVersionDetails, object: nil)
    }
    
    func removeClassObservers() {
        NotificationCenter.default.removeObserver(NSNotification.Name.appVersionDetails)
    }
    
    @objc func notificationGetAppVersionsDetails(notification : NSNotification) {
        
        if let object = notification.object as? JSON {
            if object["isDone"].boolValue{
                
                self.txtCountryCode.text = "\(JSON(AppVersionDetails.countryShortName as Any).stringValue) +\(JSON(AppVersionDetails.countryCode as Any).stringValue)"
                self.imgFlag.sd_setImage(with: JSON(AppVersionDetails.countryIcon as Any).stringValue.url(), placeholderImage: nil, context: nil)
            }
           
        }
    }
}
