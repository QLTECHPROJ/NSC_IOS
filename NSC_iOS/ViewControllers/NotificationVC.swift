//
//  NotificationVC.swift
//  NSC_iOS
//
//  Created by Dhruvit on 19/07/22.
//

import UIKit
import DZNEmptyDataSet

enum NotificationTags : String{
    
    case earning = "Earning"
    case kidCheckIn = "kidCheckIn"
    case swapGroup = "SwapGroup"
}

class NotificationHeaderTblCell : UITableViewCell{
    @IBOutlet weak var lblTitle : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .white
        self.lblTitle.applyLabelStyle(fontSize: 14.0, fontName: .SFProDisplayMedium, textColor: .colorAppTxtFieldGray)
    }
}

class NotificationListCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgView: ProfileRoundImageViewClass!
    
    @IBOutlet weak var imgSeperator: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgView.contentMode = .scaleAspectFit
        self.imgView.backgroundColor = .colorAppThemeOrange.withAlphaComponent(0.1)
        self.lblTitle.applyLabelStyle(fontSize: 14.0, fontName: .SFProDisplaySemibold)
        self.lblDesc.applyLabelStyle(fontSize: 11.0, fontName: .SFProDisplayMedium)
        self.lblDate.applyLabelStyle(fontSize: 11.0, fontName: .SFProDisplayMedium, textColor: .colorAppTxtFieldGray)
    }
    
    // Configure Cell
    func configureCell(data : JSON) {
        self.lblTitle.text = data["Title"].stringValue
        self.lblDesc.text = data["Desc"].stringValue
        self.lblDate.text = data["time"].stringValue
        
        self.imgView.sd_setImage(with: data["Image"].stringValue.url(), placeholderImage: nil, progress: nil)
    }
    
}

class NotificationVC: ClearNaviagtionBarVC {
    
    // MARK: - OUTLETS
    @IBOutlet weak var tblNotifications: UITableView!
    
    
    // MARK: - VARIABLES
    private var arrNotification : [JSON] = []
    private var arrMain : [JSON] = []
    
    private var emptyMessage : String = Theme.strings.no_data_found
    private var isAnimated = Bool()
    
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
    }
    
    
    // MARK: - FUNCTIONS
    private func setUpView(){
        self.configureUI()
        self.apiCallNotificationList(true)
    }
    
    private func configureUI(){
        
        self.title = kNotifications
        self.isAnimated = true
        self.tblNotifications.refreshControl = self.refreshControl
        
        self.tblNotifications.emptyDataSetSource = self
        self.tblNotifications.emptyDataSetDelegate = self
    }
    
    override func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.apiCallNotificationList()
    }
    
    func apiCallNotificationList(_ isLoader : Bool = false){
        let notificationListVM = NotificationListViewModel()
        notificationListVM.callNotificationListAPI(isLoader : isLoader) { responseJson, statusCode, message, completion in
           
            self.refreshControl.endRefreshing()
            if completion, let data = responseJson{
                debugPrint(data)
                self.arrNotification = data["ResponseData"].arrayValue
                self.manageAsendingData()
            }
        }
    }
    
    
    // MARK: - ACTIONS
    @IBAction func backClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrMain.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationHeaderTblCell") as! NotificationHeaderTblCell
        
        let dateObject = GFunctions.shared.relativeDateForChat(dateString: self.arrMain[section]["date"].stringValue, inputFormat: DateTimeFormaterEnum.dd_MM_yyyy.rawValue, returnDateFormat: DateTimeFormaterEnum.ddmm_yyyy.rawValue)
        
        if dateObject.isToday{
            
            cell.lblTitle.text = kTODAY
            
        }
        else if dateObject.isYesterday{
            
            cell.lblTitle.text =  kYESTERDAY
            
        }else{
            
            cell.lblTitle.text = JSON(dateObject.returnDate as Any).stringValue
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.arrMain[section]["data"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: NotificationListCell.self)
        cell.configureCell(data: self.arrMain[indexPath.section]["data"][indexPath.row])
        cell.imgSeperator.alpha = (self.arrMain[indexPath.section]["data"].count-1) == indexPath.row ? 0 : 1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.arrMain[indexPath.section]["data"][indexPath.row]["Flag"].stringValue == NotificationTags.kidCheckIn.rawValue{
            
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:KidsAttendanceVC.self)
            aVC.campID = self.arrMain[indexPath.section]["data"][indexPath.row]["FlagID"].stringValue
            self.navigationController?.pushViewController(aVC, animated: true)
        }
        else if self.arrMain[indexPath.section]["data"][indexPath.row]["Flag"].stringValue == NotificationTags.earning.rawValue{
            
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:EarningVC.self)
            self.navigationController?.pushViewController(aVC, animated: true)
        }
        else if self.arrMain[indexPath.section]["data"][indexPath.row]["Flag"].stringValue == NotificationTags.swapGroup.rawValue{
            
            let aVC = AppStoryBoard.main.viewController(viewControllerClass:KidsAttendanceVC.self)
            aVC.campID = self.arrMain[indexPath.section]["data"][indexPath.row]["FlagID"].stringValue
            self.navigationController?.pushViewController(aVC, animated: true)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.isAnimated{
            cell.alpha = 0
            self.isAnimated = indexPath.row == (self.arrMain[indexPath.section]["data"][indexPath.row].count-1) ? false : true
            UIView.animate(withDuration: 2, delay: 0.05*Double(indexPath.row), options: .transitionFlipFromBottom, animations: {
                cell.alpha = 1
            })
        }
    }
}

//-------------------------------------------------------------------
//MARK: - Empty TableView Methods
//-------------------------------------------------------------------
extension NotificationVC : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource{
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString {
        
        let text = self.emptyMessage
        let attributes = [NSAttributedString.Key.font: UIFont.applyCustomFont(fontName: .SFProDisplayRegular, fontSize: 13.0), NSAttributedString.Key.foregroundColor: UIColor.colorAppTextBlack]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

//----------------------------------------------------------------------------
//MARK: - Notification manage Methods
//----------------------------------------------------------------------------
extension NotificationVC{
    
    func manageAsendingData(_ scrollToTop : Bool = true) {
        let arrayOfAllDates = self.arrNotification.compactMap({ return GFunctions.shared.convertDateFormat(dt: $0["Date"].stringValue, inputFormat: DateTimeFormaterEnum.dd_MM_yyyy.rawValue, outputFormat: DateTimeFormaterEnum.dd_MM_yyyy.rawValue, status: .NOCONVERSION).str})
        
        let arrayOfUniqueDates = arrayOfAllDates.unique
        
        let arraySorted = arrayOfUniqueDates.sorted { (strDate1, strDate2) -> Bool in
            
            let date1 = GFunctions.shared.convertDateFormat(dt: strDate1, inputFormat: DateTimeFormaterEnum.dd_MM_yyyy.rawValue, outputFormat: DateTimeFormaterEnum.dd_MM_yyyy.rawValue, status: .NOCONVERSION)
            
            let date2 = GFunctions.shared.convertDateFormat(dt: strDate2, inputFormat: DateTimeFormaterEnum.dd_MM_yyyy.rawValue, outputFormat: DateTimeFormaterEnum.dd_MM_yyyy.rawValue, status: .NOCONVERSION)
            
            return date1.date.compare(date2.date) ==  .orderedDescending//.orderedAscending
            
        }
        
        self.arrMain = []
        _ = arraySorted.compactMap { (objDate) -> Void in
            
            let predict = NSPredicate(format: "date LIKE %@", objDate)
            let result = self.arrMain.filter{$0["date"].stringValue == objDate}
            
            if result.count <= 0 {
                
                let array = self.arrNotification.compactMap { (subObjJson) -> JSON? in
                    let subObjDate = GFunctions.shared.convertDateFormat(dt: subObjJson["Date"].stringValue, inputFormat: DateTimeFormaterEnum.dd_MM_yyyy.rawValue, outputFormat: DateTimeFormaterEnum.dd_MM_yyyy.rawValue, status: .NOCONVERSION).str
                    
                    let subObjTime = GFunctions.shared.convertDateFormat(dt: subObjJson["Date"].stringValue, inputFormat: DateTimeFormaterEnum.dd_MM_yyyy.rawValue, outputFormat: DateTimeFormaterEnum.hhmma.rawValue, status: .NOCONVERSION).str
                    
                    if objDate == subObjDate {
                        return subObjJson
                    } else {
                        return nil
                    }
                }
                
                let dict : JSON = [
                    "date" : objDate,
                    "data" : array
                ]
                if !array.isEmpty{
                    self.arrMain.append(dict)
                }
            }
        }
        
        print(self.arrMain)
        
        self.tblNotifications.reloadData()
        
        if scrollToTop {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.scrollToFirst()
            }
            self.tblNotifications.reloadData()
        }
        
       
    }
    
    func scrollToFirst() {
        if self.arrMain.count > 0 {
            
//            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
}
