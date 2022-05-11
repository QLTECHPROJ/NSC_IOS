//
//  ProfileVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 26/04/22.
//

import UIKit
import SDWebImage

class ProfileVC: BaseViewController {
    
    // MARK: - OUTLETS
    // UIImage
    @IBOutlet weak var imgUser: UIImageView!
    
    // UITextfield
    @IBOutlet weak var txtFName: UITextField!
    @IBOutlet weak var txtLName: UITextField!
    
    @IBOutlet weak var txtFMobileNo: UITextField!
    @IBOutlet weak var txtFEmailAdd: UITextField!
    
    // UIButton
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    
    // UILabel
    @IBOutlet weak var lblErrLastName: UILabel!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblErrName: UILabel!
    @IBOutlet weak var lblErrMobileNo: UILabel!
    @IBOutlet weak var lblErrEmail: UILabel!
    
    // MARK: - VARIABLES
    var isCountrySelected = false
    var strMobile:String?
    var coachData: LoginDataModel?
    var strImage:String?
    var imageData = UploadDataModel()
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgUser.contentMode = .scaleAspectFill
        if strMobile != "" {
            txtFMobileNo.text = strMobile
        }
        setupData()
        setupUI()
       
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
        lblErrLastName.isHidden = true
        
        txtFMobileNo.delegate = self
        txtFEmailAdd.delegate = self
        txtFName.delegate = self
        txtLName.delegate = self
        
    }
    
    override func setupData() {
        let countryText = AppVersionDetails.countryShortName + " " + "+" + AppVersionDetails.countryCode
        btnCountryCode.setTitle(countryText, for: .normal)
        
        let coachDetailVM = CoachDetailViewModel()
        coachDetailVM.callCoachDetailsAPI { success in
            
            self.txtFMobileNo.text = coachDetailVM.userData?.Mobile
            self.txtFName.text = coachDetailVM.userData?.Fname
            self.txtLName.text = coachDetailVM.userData?.Lname
            self.txtFEmailAdd.text = coachDetailVM.userData?.Email
            self.lblUser.text = coachDetailVM.userData?.Name
            if let strUrl = coachDetailVM.userData?.Profile_Image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imgUrl = URL(string: strUrl) {
                self.imgUser.sd_setImage(with: imgUrl, completed: nil)
                self.strImage = coachDetailVM.userData?.Profile_Image
            }
            self.coachData = coachDetailVM.userData
            self.txtFMobileNo.isEnabled = false
            self.txtFEmailAdd.isEnabled = false
            self.buttonEnableDisable()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.isCountrySelected {
                self.btnCountryCode.setTitleColor(Theme.colors.textColor, for: .normal)
            } else {
                self.btnCountryCode.setTitleColor(Theme.colors.black_40_opacity, for: .normal)
            }
        }
        
    }
    
    override func buttonEnableDisable() {
        if coachData?.Fname == txtFName.text && coachData?.Lname == txtLName.text && coachData?.Profile_Image == strImage {
            btnConfirm.isUserInteractionEnabled = true
            btnConfirm.backgroundColor = Theme.colors.theme_dark
            btnConfirm.setTitleColor(.white, for: .normal)
            btnUpdate.isUserInteractionEnabled = false
            btnUpdate.backgroundColor = Theme.colors.white
            btnUpdate.removeGradient()
            btnUpdate.setTitleColor(Theme.colors.theme_dark, for: .normal)
        }else {
            btnConfirm.isUserInteractionEnabled = false
            btnConfirm.backgroundColor = Theme.colors.white
            btnConfirm.setTitleColor(Theme.colors.theme_dark, for: .normal)
            btnConfirm.removeGradient()
            btnUpdate.isUserInteractionEnabled = true
            btnUpdate.backgroundColor = Theme.colors.theme_dark
            btnUpdate.setTitleColor(.white, for: .normal)
        }
    }
    
    func checkValidation() -> Bool {
        var isValid = true
        let strMobile = txtFMobileNo.text?.trim ?? ""
        if txtFName.text?.trim.count == 0 {
            isValid = false
            lblErrName.isHidden = false
            lblErrName.text = Theme.strings.alert_blank_firstname_error
        }
        
        if txtLName.text?.trim.count == 0 {
            isValid = false
            lblErrLastName.isHidden = false
            lblErrLastName.text = Theme.strings.alert_blank_lastname_error
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
            LoginDataModel.currentUser?.Profile_Image = ""
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
        self.setupData()
    }
    
    @IBAction func updateClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if checkValidation() {
            lblErrName.isHidden = true
            lblErrMobileNo.isHidden = true
            lblErrEmail.isHidden = true
            lblErrLastName.isHidden = true
            
            let parameters = ["coachId":LoginDataModel.currentUser?.ID ?? "",
                              "fname":txtFName.text ?? "",
                              "lname":txtLName.text ?? "",
                              "profileImage":strImage ?? ""]
            
            let profileVM = ProfileViewModel()
            profileVM.callProfileUpdateAPI(parameters: parameters, completion: { success in
                if success {
                    self.setupData()
                }
            })
        }
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
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblErrName.isHidden = true
        lblErrMobileNo.isHidden = true
        lblErrEmail.isHidden = true
        lblErrLastName.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text, let textRange = Range(range, in: text) else {
            return false
        }
        
        let updatedText = text.replacingCharacters(in: textRange, with: string).trim
        
        if textField == txtFName && updatedText.count > 16 {
            return false
        } else if textField == txtFMobileNo && updatedText.count > 15 {
            return false
        }
        
        buttonEnableDisable()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.buttonEnableDisable()
     
    }
    
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imgUser.image = image
           
            imageData = UploadDataModel(name: "image.jpeg", key: "ProfileImage", data: image.jpegData(compressionQuality: 0.5), extention: "jpeg", mimeType: "image/jpeg")
            self.strImage = imageData.name
            self.buttonEnableDisable()
            
        }
        else if let image = info[.originalImage] as? UIImage {
            imgUser.image = image
            imageData = UploadDataModel(name: "image.jpeg", key: "ProfileImage", data: image.jpegData(compressionQuality: 0.5), extention: "jpeg", mimeType: "image/jpeg")
            self.strImage = imageData.name
            self.buttonEnableDisable()
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


