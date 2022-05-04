//
//  CountryListVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 23/03/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import UIKit

class CountryListVC: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var btnClear: UIButton!
    
    
    // MARK: - VARIABLES
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(nibWithCellClass: CountryCell.self)
       
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }
    
    @objc func textFieldValueChanged(textField : UITextField ) {
        btnClear.isHidden = textField.text?.count == 0
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - ACTIONS
    @IBAction func clearSearchClicked(sender: UIButton) {
        txtSearch.text = ""
        btnClear.isHidden = true
        lblNoData.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CountryListVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CountryCell.self)
        cell.btnSelect.setImage(nil, for: .normal)
        cell.backgroundColor = .white
        cell.viewBack.cornerRadius = 0
        cell.viewBack.layer.shadowOpacity = 0
        cell.viewBack.layer.shadowColor = UIColor.clear.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        self.dismiss(animated: true, completion: nil)
    }
    
}
