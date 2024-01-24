//
//  CountryListVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 07/05/22.
//

import UIKit
import DZNEmptyDataSet

enum ListItemType : Int {
    case country = 0
    case state
    case city
    case sport
    case role
    
}

class ListItemCell: UITableViewCell {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var lblTitle : UILabel!
    
    // MARK: - FUNCTIONS
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblTitle.applyLabelStyle(fontSize: 12.0, fontName: .SFProDisplayMedium)
    }
    
    func configureCell(data : ListItem, listType: ListItemType) {
        
        self.lblTitle.text = data.Name
    }
    
}


class ListItemVC: BaseViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - VARIABLES
    
    var listType : ListItemType = .country
    var strID = ""
    
    var arrayItem = [ListItem]()
    var arrayItemSearch = [ListItem]()
    
    private var isAnimated = Bool()
    private var emptyMessage : String = Theme.strings.alert_search_term_not_found
    var completionBlock : ((ListItem?,Bool,ListItemType)->Void)?
    
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.apiCallList()
    }
    
    
    // MARK: - FUNCTIONS
    
    private func setUpView(){
        self.configureUI()
        self.setData()
    }
    
    private func configureUI(){
        self.view.backgroundColor = .clear
        self.view.alpha = 0
        self.lblTitle.applyLabelStyle(text : "",fontSize: 14.0, fontName: .SFProDisplaySemibold)
        self.txtSearch.applyStyleTextField(fontsize: 12.0, fontname: .SFProDisplayRegular)
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        self.txtSearch.addTarget(self, action: #selector(self.searchValueChanged(_:)), for: .allEditingEvents)

    }
    

    @objc func searchValueChanged(_ sender : UITextField){
        
        self.arrayItemSearch = self.arrayItem.compactMap({ obj -> ListItem? in
        
            return JSON(obj.Name as Any).stringValue.lowercased().contains(string: JSON(sender.text as Any).stringValue.lowercased()) ? obj : nil
        })
        
        if sender.text!.trim.isEmpty{
            self.arrayItemSearch = self.arrayItem
        }
        
        self.tableView.reloadData()
        
    }
    
    func openPopUpVisiable(){
        UIView.animate(withDuration: 0.5, delay: 0.0) {
            self.view.alpha = 1
        }
    }
    
    private func closePopUpVisiable(isCompletion : Bool = false, data : ListItem?){
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
            
            self.view.alpha = 0
            
        }, completion: { (finished: Bool) in
            self.dismiss(animated: false) {
                
                if let _ = self.completionBlock, let _ = data{
                    self.completionBlock!(data! ,isCompletion,self.listType)
                }
            }
        })
    }
    
    
    func apiCallList() {
       
        let listDataVM = ListDataViewModel()
        listDataVM.callItemListAPI(strID: self.strID, listType: self.listType) { success in
            if success {
                self.arrayItem = listDataVM.listItemData ?? [ListItem]()
                self.arrayItemSearch = self.arrayItem
            }
            self.tableView.reloadData()
        }
   }
    
    private func setData() {
       
        switch listType {
            
        case .country:
            lblTitle.text = "Choose your country"
            txtSearch.placeholder = "Search for country"
        case .state:
            lblTitle.text = "Choose your state"
            txtSearch.placeholder = "Search for state"
        case .city:
            lblTitle.text = "Choose your city"
            txtSearch.placeholder = "Search for city"
        case .sport:
            lblTitle.text = "Choose your sport"
            txtSearch.placeholder = "Search for sport"
        case .role:
            lblTitle.text = "Choose your role"
            txtSearch.placeholder = "Search for role"
        }
    }

    
    
    
    // MARK: - ACTIONS
    @IBAction func btnDismissTapped( _ sender : UIButton){
        self.closePopUpVisiable(data: nil)
    }
    
}




// MARK: - UITableViewDelegate, UITableViewDataSource
extension ListItemVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayItemSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: ListItemCell.self)
        cell.configureCell(data: arrayItemSearch[indexPath.row], listType: self.listType)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.closePopUpVisiable(isCompletion : false, data: self.arrayItemSearch[indexPath.row])
    }
}

//-------------------------------------------------------------------
//MARK: - Empty TableView Methods
//-------------------------------------------------------------------
extension ListItemVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource{
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.emptyMessage
        let attributes = [NSAttributedString.Key.font: UIFont.applyCustomFont(fontName: .SFProDisplayRegular, fontSize: 13.0), NSAttributedString.Key.foregroundColor: UIColor.colorAppTextBlack]
        return NSAttributedString(string: text, attributes: attributes)
    }
}
