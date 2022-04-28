//
//  KidsAttendanceVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 27/04/22.
//

import UIKit

class KidsAttendanceVC: UIViewController {
    
    //MARK:- UIOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(nibWithCellClass: KidsAttendenceCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    //MARK:- Functions
    @IBAction func onTappedBack(_ sender: UIButton) {
    }
    
}
extension KidsAttendanceVC : UITableViewDelegate , UITableViewDataSource {
    
    // MARK - UITableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withClass: KidsAttendenceCell.self)
        return cell
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 180
    }

    
    
}
