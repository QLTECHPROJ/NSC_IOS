//
//  ApplyForCampVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 13/05/22.
//

import UIKit
import DZNEmptyDataSet

class ApplyForCampCell: UITableViewCell {
    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var imgCamp: UIImageView!
    
    @IBOutlet weak var btnSelect: UIButton!
    
    @IBOutlet weak var stackVAddress: UIStackView!
    @IBOutlet weak var stackVDate: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        self.btnSelect.isUserInteractionEnabled = false
        self.imgCamp.layer.cornerRadius = 5.0
        
        self.lblName.applyLabelStyle(fontSize: 13.0, fontName: .SFProDisplaySemibold)
        self.lblAddress.applyLabelStyle(fontSize: 10.0, fontName: .SFProDisplayRegular, textColor: .colorAppTextBlack)
        self.lblAddress.numberOfLines = 3
        
        self.lblDate.applyLabelStyle(fontSize: 10.0, fontName: .SFProDisplayRegular, textColor: .colorAppTextBlack)
        self.viewBack.dropShadow(shadowRadius : 5)
    }
    
    // Configure Cell
    func configureSelectionCell(data : ApplyCampModel) {
        self.lblName.text = data.Name
        self.lblAddress.text = data.Address
        self.lblDate.text = data.CampDates
        
        self.stackVAddress.isHidden = data.Address.trim.isEmpty
        self.stackVDate.isHidden = data.CampDates.trim.isEmpty
        
        self.btnSelect.isSelected = JSON(data.Selected as Any).boolValue
        
        self.imgCamp.sd_setImage(with: JSON(data.CampImage as Any).stringValue.url(), placeholderImage: nil, context: nil)
    }
    
}


class ApplyForCampVC: BaseViewController {
    
    //-------------------------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------------------------
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwSearch: AppShadowViewClass!
    @IBOutlet weak var btnApply: AppThemeButton!
    
    //-------------------------------------------------------------------------------
    // MARK: - Variables
    //-------------------------------------------------------------------------------
    var maxCount = 0
    var arrayCamp = [ApplyCampModel]()
    var arrayCampSearch = [ApplyCampModel]()
    
    private var emptyMessage : String = Theme.strings.no_camps_to_display
    private var isAnimated = Bool()
    
    //-------------------------------------------------------------------------------
    // MARK: - View Life Cycle
    //-------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    //-------------------------------------------------------------------------------
    // MARK: - Functions
    //-------------------------------------------------------------------------------
    private func setUpView(){
        self.configureUI()
        self.btnEnableDisable()
        self.apiCallItemList(true)
    }
    
    private func configureUI(){
        
        self.title = kApplyForACamp
        
        self.isAnimated = true
        self.txtSearch.applyStyleTextField(placeholder : kSearchByCampSportLocation,fontsize: 12.0, fontname: .SFProDisplayRegular)

        self.vwSearch.shadowColorVW =  UIColor(red: 0.827, green: 0.82, blue: 0.847, alpha: 0.7).cgColor
        self.vwSearch.shadowOffSetSize = CGSize(width: 9, height: 9)
        self.vwSearch.shadowRadiusSize = 18
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
    }
    
    private func btnEnableDisable() {
        
        let selectedArray = self.arrayCamp.filter({ $0.Selected == "1" })
        self.btnApply.isSelect = !selectedArray.isEmpty
        self.tableView.reloadData()
    }
    
    //-------------------------------------------------------------------------------
    // MARK: - Actions
    //-------------------------------------------------------------------------------
    @IBAction func backClicked(_ sender : UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyClicked(_ sender : UIButton) {
        self.view.endEditing(true)
        
        let selectedCamps = arrayCamp.filter({ $0.Selected == "1" })
        let selectedIDs = selectedCamps.map({ $0.ID })
        
        if selectedIDs.count > 0 {
            let strCampIDs = selectedIDs.joined(separator: ",")
            print("selectedIDs - \(strCampIDs)")
            
            let saveAppliedCampsVM = SaveAppliedCampsViewModel()
            saveAppliedCampsVM.callSaveAppliedCampsAPI(campIds: strCampIDs) { success in
                if success {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            GFunctions.shared.showSnackBar(message: Theme.strings.alert_select_camp)
        }
    }
    
}

//-------------------------------------------------------------------------------
// MARK: - UITextField Methods
//-------------------------------------------------------------------------------
extension ApplyForCampVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            print("Search text :- ",updatedText)
            
            self.arrayCampSearch = self.arrayCamp.filter({ (model:ApplyCampModel) -> Bool in
                return model.Name.lowercased().contains(updatedText.lowercased())
            })
            
            if updatedText.trim.count == 0 {
                self.arrayCampSearch = self.arrayCamp
            }
            
            self.btnEnableDisable()
        }
        
        return true
    }
    
}

//-------------------------------------------------------------------------------
// MARK: - UITableView Methods
//-------------------------------------------------------------------------------
extension ApplyForCampVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayCampSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withClass: ApplyForCampCell.self)
        
        cell.configureSelectionCell(data: self.arrayCampSearch[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.arrayCampSearch[indexPath.row].Selected == "1" {
            
            self.arrayCampSearch[indexPath.row].Selected = "0"
            
        } else {
            
            let count = self.arrayCamp.filter({ $0.Selected == "1" }).count
            
            if count < self.maxCount {
            
                self.arrayCampSearch[indexPath.row].Selected = "1"
                
            } else {
              
                GFunctions.shared.showSnackBar(message: "You can pick up to \(self.maxCount) camps. They can be changed anytime.")
            }
        }
        self.btnEnableDisable()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//-------------------------------------------------------------------------------
//MARK: - Empty TableView Methods
//-------------------------------------------------------------------------------
extension ApplyForCampVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource{
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.emptyMessage
        let attributes = [NSAttributedString.Key.font: UIFont.applyCustomFont(fontName: .SFProDisplayRegular, fontSize: 13.0), NSAttributedString.Key.foregroundColor: UIColor.colorAppTextBlack]
        return NSAttributedString(string: text, attributes: attributes)
    }
}
//-------------------------------------------------------------------------------
//MARK: - API Calling Methods
//-------------------------------------------------------------------------------
extension ApplyForCampVC{
    
    private func apiCallItemList(_ isLoader : Bool = false){
        
        let applyForACampVM = ApplyForACampViewModel()
        
        applyForACampVM.callItemListAPI(isLoader : isLoader) { success in
            
            self.refreshControl.endRefreshing()
            if success {
                self.maxCount = applyForACampVM.maxCount
                self.arrayCamp = applyForACampVM.arrayCamps ?? [ApplyCampModel]()
                self.arrayCampSearch = self.arrayCamp
            }
            
            self.btnEnableDisable()
        }
    }
}
