//
//  DailyReportVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 27/04/22.
//

import UIKit

class DailyReportVC: UIViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(nibWithCellClass: CountryCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    //MARK:- ACTION
    @IBAction func backClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension DailyReportVC: UITableViewDelegate , UITableViewDataSource {
    
    // MARK - UITableView Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withClass: CountryCell.self)
        cell.lblCountryName.text = "  DAY - 1"
        cell.lblCountryName.font = UIFont(name: "Poppins-SemiBold", size: 14)
        cell.btnSelect.setImage(UIImage(named: "OrangeArrow"), for: .selected)
        cell.backgroundColor = .clear
        return cell
        
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
            
            let label = UILabel()
            label.frame = CGRect.init(x: 16, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            if section == 0 {
                label.text = "Basket Ball Camp"
            }
            label.textColor = .black
            label.font = .boldSystemFont(ofSize: 16)
            headerView.backgroundColor = .clear
            headerView.addSubview(label)
            
            return headerView
        }else {
            let header = UIView()
            header.isUserInteractionEnabled = false
            header.backgroundColor = UIColor.clear
            return header
        }
        
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 60
        }else {
            return 30
        }
       
    }
    
}
