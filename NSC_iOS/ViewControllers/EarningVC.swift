//
//  EarningVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 17/05/22.
//

import UIKit
import DZNEmptyDataSet

class TransationsCell: UITableViewCell {
    
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var lblAmount : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgView.layer.cornerRadius = 10.0
        self.lblName.applyLabelStyle(fontSize: 14.0, fontName: .SFProDisplaySemibold)
        self.lblDate.applyLabelStyle(fontSize: 11.0, fontName: .SFProDisplayRegular, textColor: .colorAppTxtFieldGray)
        self.lblAmount.applyLabelStyle(fontSize: 11.0, fontName: .SFProDisplaySemibold, textColor: .colorAppThemeOrange)

    }
    
    // Configure Cell
    func configureDataCell(with data : JSON) {
        debugPrint(data)
        lblName.text = data["Name"].stringValue
        lblDate.text = data["Date"].stringValue
        lblAmount.text = data["Amount"].stringValue

        self.imgView.sd_setImage(with:data["Profile_Image"].stringValue.url() , placeholderImage: UIImage(named: "defaultUserIcon")!, context: nil)
    }
    
}



class EarningVC: ClearNaviagtionBarVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblYourTotalBalance: UILabel!
    @IBOutlet weak var lblBalanceValue: UILabel!
    
    @IBOutlet weak var lblTransactions: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - VARIABLES
    var arrTransactions : [JSON] = []
    
    private var isAnimated = Bool()
    private var emptyMessage : String = Theme.strings.no_earnings
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiCallMyEarning()
    }
    
    
    // MARK: - FUNCTIONS
    private func setUpView(){
        
        self.configureUI()
    }
    
    private func configureUI(){
        self.title = kMyEarning
        
        self.isAnimated = true
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        self.lblYourTotalBalance.applyLabelStyle(text: kYourTotalEarnings, fontSize: 16.0, fontName: .SFProDisplaySemibold, textColor: .colorAppDarkGray)
        
        self.lblBalanceValue.applyLabelStyle(text: "₹ 0.00", fontSize: 25.0, fontName: .SFProDisplaySemibold, textColor: .colorAppThemeOrange)
        
        self.lblTransactions.applyLabelStyle(text: kTransactions, fontSize: 18.0, fontName: .SFProDisplaySemibold)
    }
    
   
    
    
    // MARK: - ACTIONS
    @IBAction func backClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension EarningVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: TransationsCell.self)
        cell.configureDataCell(with: self.arrTransactions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.isAnimated{
            cell.alpha = 0
            self.isAnimated = indexPath.row == (self.arrTransactions.count-1) ? false : true
            UIView.animate(withDuration: 2, delay: 0.05*Double(indexPath.row), options: .transitionFlipFromBottom, animations: {
                cell.alpha = 1
            })
        }
    }
}

//-------------------------------------------------------------------
//MARK: - Empty TableView Methods
//-------------------------------------------------------------------
extension EarningVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource{
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.emptyMessage
        let attributes = [NSAttributedString.Key.font: UIFont.applyCustomFont(fontName: .SFProDisplayRegular, fontSize: 13.0), NSAttributedString.Key.foregroundColor: UIColor.colorAppTextBlack]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

extension EarningVC{
    
    func apiCallMyEarning(){
        let earningVM = EarningViewModel()
        
        earningVM.callMyEarningAPI { responseJson, statusCode, message, completion in
            
            if completion, let data = responseJson{
                self.lblBalanceValue.text = "\(data["ResponseData"]["TotalBalance"].stringValue)"
                self.arrTransactions = data["ResponseData"]["transactions"].arrayValue
            }
            self.tableView.reloadData()
        }
    }
}


