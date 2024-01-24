//
//  ContactVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 13/05/22.
//

import Foundation
import ContactsUI
import MessageUI
import EVReflection
import DZNEmptyDataSet

/**** Contact Model ****/

class ContactModel : EVObject {
    var contactName = ""
    var contactNumber = ""
    var contactImage : UIImage?
}


class ContactCell: UITableViewCell {
    
    // MARK: - OUTLETS
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblNumber : UILabel!
    @IBOutlet weak var btnInvite : UIButton!
    
    
    // MARK: - VARIABLES

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgView.layer.cornerRadius = 10.0
        self.lblName.applyLabelStyle(fontSize: 14.0, fontName: .SFProDisplaySemibold)
        self.lblNumber.applyLabelStyle(fontSize: 11.0, fontName: .SFProDisplayRegular, textColor: .colorAppTxtFieldGray)
        self.btnInvite.applystyle(fontname: .SFProDisplaySemibold, fontsize: 11.0, titleText: kInvite, titleColor: .colorAppThemeOrange)
    }
    

    // MARK: - FUNCTIONS
    // Configure Cell
    func configureCell(data : ContactModel) {
        lblName.text = data.contactName
        lblNumber.text = data.contactNumber
        imgView.image = UIImage(named: "defaultUserIcon")! //data.contactImage
        
        lblName.isHidden = (data.contactName.trim.count == 0)

    }
}

class ContactVC: ClearNaviagtionBarVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwSearch: AppShadowViewClass!
    
    // MARK: - VARIABLES
    var arrayContactList = [CNContact]()
    var arrayContacts = [ContactModel]()
    var arrayContactsSearch = [ContactModel]()
    
    var referCode = ""
    var referLink = ""
    
    private var emptyMessage : String = Theme.strings.no_contacts_to_display
    private var isAnimated = Bool()
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }
    
    
    // MARK: - FUNCTIONS
    private func setUpView(){
        self.configureUI()
        self.fetchContacts()
        self.setData()
    }
    
    private func configureUI(){
        self.title = kInvite
        self.isAnimated = true
        self.txtSearch.applyStyleTextField(placeholder : kSearchContactNumber,fontsize: 12.0, fontname: .SFProDisplayRegular)

        self.vwSearch.shadowColorVW =  UIColor(red: 0.827, green: 0.82, blue: 0.847, alpha: 0.7).cgColor
        self.vwSearch.shadowOffSetSize = CGSize(width: 9, height: 9)
        self.vwSearch.shadowRadiusSize = 18
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        tableView.reloadData()
    }
    
    
    private func setData() {
        arrayContacts = [ContactModel]()
        for contact in arrayContactList {
            let contactData = ContactModel()
            contactData.contactName = contact.givenName + " " + contact.familyName
            
            if let phoneNumber = contact.phoneNumbers.first?.value {
                contactData.contactNumber = phoneNumber.stringValue
            }
            
//            if let imageData = contact.thumbnailImageData, let contactImage = UIImage(data: imageData) {
//                contactData.contactImage = contactImage
//            } else {
//                contactData.contactImage = UIImage(named: "defaultUserIcon")
//            }
//
            arrayContacts.append(contactData)
        }
        
        arrayContacts = arrayContacts.filter { $0.contactNumber.trim.count > 0 }
        
        arrayContactsSearch = arrayContacts
        tableView.reloadData()
    }

    func fetchContacts() {
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactThumbnailImageDataKey
        ] as [Any]
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        fetchRequest.sortOrder = CNContactSortOrder.givenName
        let store = CNContactStore()
        do {
            try store.enumerateContacts(with: fetchRequest, usingBlock: { ( contact, stop) -> Void in
                self.arrayContactList.append(contact)
            })
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        self.setData()
    }
    
    func sendSMS(contact : ContactModel) {
        self.view.endEditing(true)
        
        let inviteVM = InviteViewModel()
        inviteVM.callInviteUserAPI(contact: contact) { success in
            if success {
                self.sendReferralMessage(contact: contact)
            }
        }
    }
    
    func sendReferralMessage(contact : ContactModel) {
        if (MFMessageComposeViewController.canSendText()) {
            
            let shareText = "You’re invited  for the position of coach in our sports camp. Apply Now!! \n\nDownload the NSC app now and use referral code \(referCode)!! \n\nGet the app now \(referLink)"
            
            let controller = MFMessageComposeViewController()
            controller.body = shareText
            controller.recipients = [contact.contactNumber]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_cannot_send_message)
        }
    }
    
    
    // MARK: - ACTIONS
    @IBAction func backClicked(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clearSearchClicked(_ sender: UIButton) {
        txtSearch.text = ""
        arrayContactsSearch = arrayContacts
        tableView.reloadData()
    }
    
}


// MARK: - UITextFieldDelegate
extension ContactVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            print("Search text :- ",updatedText)
            
            arrayContactsSearch = arrayContacts.filter({ (model:ContactModel) -> Bool in
                return model.contactName.lowercased().contains(updatedText.lowercased())
            })
            
            if updatedText.trim.count == 0 {
                arrayContactsSearch = arrayContacts
            }
            
            tableView.reloadData()
        }
        
        return true
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension ContactVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayContactsSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ContactCell.self)
        cell.configureCell(data: arrayContactsSearch[indexPath.row])
        cell.btnInvite.addTarget(self, action: #selector(self.btnInviteTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func btnInviteTapped(_ sender : UIButton){
        self.sendSMS(contact: self.arrayContactsSearch[sender.tag])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.isAnimated{
            cell.alpha = 0
            self.isAnimated = indexPath.row == (self.arrayContactsSearch.count-1) ? false : true
            UIView.animate(withDuration: 2, delay: 0.05*Double(indexPath.row), options: .transitionFlipFromBottom, animations: {
                cell.alpha = 1
            })
        }
    }
}

//-------------------------------------------------------------------
//MARK: - Empty TableView Methods
//-------------------------------------------------------------------
extension ContactVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource{
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.emptyMessage
        let attributes = [NSAttributedString.Key.font: UIFont.applyCustomFont(fontName: .SFProDisplayRegular, fontSize: 13.0), NSAttributedString.Key.foregroundColor: UIColor.colorAppTextBlack]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

// MARK: - MFMessageComposeViewControllerDelegate
extension ContactVC : MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled:
            
            GFunctions.shared.showSnackBar(message: kMessageSendingCancelled)
            
        case .sent:
            print("Message Sent")
        
        case .failed:
            
            GFunctions.shared.showSnackBar(message: kMessageSendingFailed)
            
        default:
        
            GFunctions.shared.showSnackBar(message: kMessageSendingFailed)
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
}
