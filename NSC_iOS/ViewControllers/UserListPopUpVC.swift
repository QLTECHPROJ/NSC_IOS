//
//  UserListPopUpVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class UserListPopUpVC: BaseViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - VARIABLES
    var tapGesture = UITapGestureRecognizer()
    var arrMenu = ["Edit Profile", "Bank Details" ,"Personal Details" ,"My Earnings","Apply For a Camp","Refer a Coach" , "Logout"]
    var arrImage = ["Profile", "BankDetails" ,"PersonalDetails","Earnings","ApplyCamp","ReferCoach" ,"Logout"]
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(nibWithCellClass: UserListCell.self)
        tableView.reloadData()
    }
    
    
    // MARK: - ACTIONS
    @IBAction func onTappedBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension UserListPopUpVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: UserListCell.self)
        cell.lblName.text = arrMenu[indexPath.row]
        cell.imgView.image = UIImage(named: arrImage[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: ProfileVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        } else if indexPath.row == 1 {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: BankDetailsVC.self)
            aVC.isFromEdit = true
            self.navigationController?.pushViewController(aVC, animated: true)
        } else if indexPath.row == 2 {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: PersonalDetailsVC.self)
            aVC.isFromEdit = true
            self.navigationController?.pushViewController(aVC, animated: true)
        } else if indexPath.row == 3 {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: EarningVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        } else if indexPath.row == 4 {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: ApplyForCampVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        } else if indexPath.row == 5 {
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: ReferVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        } else if indexPath.row == 6 {
            if checkInternet(showToast: true) == false {
                return
            }
            
            let aVC = AppStoryBoard.main.viewController(viewControllerClass: AlertPopUpVC.self)
            aVC.titleText = Theme.strings.logout
            aVC.detailText = Theme.strings.alert_logout_message
            aVC.firstButtonTitle = Theme.strings.ok
            aVC.secondButtonTitle = Theme.strings.close
            aVC.modalPresentationStyle = .overFullScreen
            aVC.delegate = self
            self.present(aVC, animated: false, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
}


// MARK: - AlertPopUpVCDelegate
extension UserListPopUpVC : AlertPopUpVCDelegate {
    
    func handleAction(sender: UIButton, popUpTag: Int) {
        if sender.tag == 0 {
            if checkInternet(showToast: true) == false {
                return
            }
            
            let logoutVM = LogoutViewModel()
            logoutVM.callLogoutAPI(completion: { success in
                APPDELEGATE.logout()
            })
            
        }
    }
    
}
