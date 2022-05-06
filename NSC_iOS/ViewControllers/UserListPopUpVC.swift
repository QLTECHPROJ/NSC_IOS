//
//  UserListPopUpVC.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/04/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class UserListPopUpVC: BaseViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewUserList: UIView!
    @IBOutlet weak var viewUserListTopConst: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var viewFooter: UIView!
    
    
    // MARK:- VARIABLES
    var tapGesture = UITapGestureRecognizer()
    var maxUsers = 2
    var totalUserCount = 1
    var didCompleteLogin : (() -> Void)?
    
    
    // MARK:- VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(nibWithCellClass: UserListCell.self)
        viewUserList.isHidden = true
        viewUserListTopConst.constant = 0
        self.view.layoutIfNeeded()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        
    }
    
    
    // MARK:- FUNCTIONS
    override func setupUI() {
        //viewUserList.roundCorners([.topLeft, .topRight], radius: 10)
        
        
       
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        viewFooter.addGestureRecognizer(tapGesture)
        viewFooter.isUserInteractionEnabled = true
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTappedback(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        viewBack.addGestureRecognizer(tapGesture)
        viewBack.isUserInteractionEnabled = true
    }
    
    override func setupData() {
        var heightConst = CGFloat(3 * 86) + CGFloat(70)
        
        heightConst = heightConst + 90
        if heightConst > SCREEN_HEIGHT - 200 {
            heightConst = SCREEN_HEIGHT - 200
        }
        viewUserListTopConst.constant = (SCREEN_HEIGHT) - heightConst
        
//        if let coUser = CoUserDataModel.currentUser {
//
//            if coUser.isMainAccount == "1" {
//                viewUserListTopConst.constant = (SCREEN_HEIGHT - 44) - heightConst
//            } else {
//                viewUserListTopConst.constant =  (SCREEN_HEIGHT + 44) - heightConst
//            }
//
//        }
        // Minus 44 for Safe Area
        viewUserList.backgroundColor = .white
        self.view.layoutIfNeeded()
        
        self.viewUserList.isHidden = false
        
        self.tableView.reloadData()
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
      
    }
    
    @objc func viewTappedback(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
   
}


// MARK:- UITableViewDelegate, UITableViewDataSource
extension UserListPopUpVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: UserListCell.self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
}
