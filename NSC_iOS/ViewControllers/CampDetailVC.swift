//
//  CampDetailVC.swift
//  NSC_iOS
//
//  Created by Mac Mini on 27/04/22.
//

import UIKit

class CampDayFeesCell: UITableViewCell {
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblFees: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblDay.applyLabelStyle(fontSize: 12.0, fontName: .PoppinsRegular, textColor: .colorAppTxtFieldGray)
        self.lblDate.applyLabelStyle(fontSize: 12.0, fontName: .PoppinsRegular, textColor: .colorAppTxtFieldGray)
        self.lblFees.applyLabelStyle(fontSize: 12.0, fontName: .SFProDisplaySemibold, textColor: .colorAppThemeOrange)
    }
    
    
    func configureCellWith(_ data : DayAvialabilityModel){
        debugPrint(data)
        
        self.lblDay.text = "\(kDay) \(JSON(data.day as Any).stringValue)"
        self.lblDate.text = JSON(data.coachAvailability as Any).stringValue == "1" ? kYes : kNo
        self.lblFees.text = JSON(data.dayPrice as Any).stringValue
    }
}

class CampDetailVC: ClearNaviagtionBarVC {
    
    //--------------------------------------------------------------------------------------
    // MARK: - Outlets
    //--------------------------------------------------------------------------------------
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCampDate: UILabel!
    
    @IBOutlet weak var lblFees: UILabel!
    @IBOutlet weak var lblFeesValue: UILabel!
    
    @IBOutlet weak var lblDayAvailable: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnStatus: UIButton!
    
    @IBOutlet weak var vwStatus: UIView!
    
    @IBOutlet weak var btnKids: AppThemeButton!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //--------------------------------------------------------------------------------------
    // MARK: - Variables
    //--------------------------------------------------------------------------------------
    
    var strCampID = ""
    var campDetails: CampDetailModel?
    var arrAvailablity = [DayAvialabilityModel]()
    
    deinit {
        guard let _ = self.tableView else {return}
        self.tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    //--------------------------------------------------------------------------------------
    // MARK: - VIew Life Cycle
    //--------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        self.setUpView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.apiCallCampDetails()
    }
    
    //--------------------------------------------------------------------------------------
    // MARK: - Custom Methods
    //--------------------------------------------------------------------------------------
    
    private func setUpView(){
        self.configureUI()
    }
    
    private func configureUI(){
        
        self.vwStatus.isHidden = true
        self.scrollView.alpha = 0
        self.title = kCampDetails
        
        self.imgView.layer.cornerRadius = 15
        self.lblAddress.numberOfLines = 2
        
        self.btnStatus.applystyle(isApsectRadio : false ,fontname: .SFProDisplaySemibold, fontsize: 12.0)
        self.btnStatus.setContentEdges(titleEngesLeft : 10)
        
        self.lblName.applyLabelStyle(fontSize: 16.0, fontName: .SFProDisplaySemibold)
        
        self.lblDescription.applyLabelStyle(fontSize: 12.0, fontName: .SFProDisplayRegular,textColor: .colorAppTxtFieldGray)
        self.lblAddress.applyLabelStyle(fontSize: 12.0, fontName: .SFProDisplayRegular, textColor : .colorAppTxtFieldGray)
        self.lblCampDate.applyLabelStyle(fontSize: 12.0, fontName: .SFProDisplayRegular,textColor :.colorAppTxtFieldGray)
        
        self.lblFees.applyLabelStyle(text : kFees,fontSize: 12.0, fontName: .SFProDisplaySemibold)
        self.lblFeesValue.applyLabelStyle(text : "₹ 00.00",fontSize: 16.0, fontName: .SFProDisplayBold,textColor: .colorAppThemeOrange)
        self.lblDayAvailable.applyLabelStyle(text : kDaysAvailable,fontSize: 12.0, fontName: .SFProDisplaySemibold)
        
        self.tableView.isScrollEnabled = false
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: [.new ], context: nil)
        
        self.btnKids.setTitle(kKids, for: .normal)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", let newSize = change?[.newKey] as? CGSize {
                
            self.tableViewHeight.constant = newSize.height
        }
    }
    
    private func setData() {
        
        guard let campDetails = self.campDetails else {
            return
        }
        
        if let strUrl = campDetails.CampImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let imgUrl = URL(string: strUrl) {
            imgView.sd_setImage(with: imgUrl, completed: nil)
        }
        
        self.lblName.text = campDetails.CampName
        self.lblAddress.text = campDetails.CampAddress
        self.lblDescription.text = campDetails.CampDetail
        self.lblCampDate.text = campDetails.CampDates
        self.lblFeesValue.text = campDetails.totalPrice
        
        if campDetails.isWorkingDay == "1" && !campDetails.dayshift.trim.isEmpty{
            self.btnKids.isSelect = true
        }
        else{
            self.btnKids.isSelect = false
        }
        self.arrAvailablity = campDetails.dayAvialability
        self.tableView.reloadData()
        
        UIView.animate(withDuration: 1) {
            self.scrollView.alpha = 1
        }
    }
    
    //--------------------------------------------------------------------------------------
    // MARK: - Actions
    //--------------------------------------------------------------------------------------
    @IBAction func backClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func kidsClicked(_ sender: UIButton) {
        guard let campDetails = campDetails else {
            return
        }
        let aVC = AppStoryBoard.main.viewController(viewControllerClass:KidsAttendanceVC.self)
        aVC.campID = campDetails.CampId
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}

//--------------------------------------------------------------------------------------
// MARK: - UITableView Methods
//--------------------------------------------------------------------------------------
extension CampDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAvailablity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: CampDayFeesCell.self)
        cell.configureCellWith(self.arrAvailablity[indexPath.row])
        return cell
    }
    
}

//--------------------------------------------------------------------------------------
// MARK: - API Calling Methods
//--------------------------------------------------------------------------------------
extension CampDetailVC{
    
    private func apiCallCampDetails() {
        
        let campDetailVM = CampDetailViewModel()
        campDetailVM.callCampDetailsAPI(campId: self.strCampID) { success in
            if success {
                self.campDetails = campDetailVM.campDetails
                self.setData()
            }
        }
    }
}
