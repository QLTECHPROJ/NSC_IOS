//
//  File.swift
//  NSC_iOS
//
//  Created by Dhruvit on 12/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import Foundation
import SVProgressHUD

// Theme Did Change notification object
extension Notification.Name {
    static let ThemeDidChangeNotification = Notification.Name("themeDidChangeNotfication")
    static let likedOrDownloadedAudio = Notification.Name("likedOrDownloadedAudio")
    static let refreshLikedList = Notification.Name("refreshLikedList")
}

// SET APP THEME
var isSystemDarkMode: Bool = false {
    didSet {
        NotificationCenter.default.post(name: .ThemeDidChangeNotification, object: nil)
        SVProgressHUD.setDefaultStyle( isSystemDarkMode ? .dark : .light)
    }
}

// MARK: - Application Theme Color Palette
class ColorPalette: NSObject {

    let isDark: Bool
    let name: String
    let statusBarStyle: UIStatusBarStyle
    let navigationbarColor: UIColor
    let navigationbarTextColor: UIColor
    let background: UIColor
    let oppBackground: UIColor
    let primaryTextColor: UIColor
    let secondnaryTextColor: UIColor
    let cellBackgroundA: UIColor
    let cellBackgroundB: UIColor
    let cellDetailTextColor: UIColor
    let cellTextColor: UIColor
    let lightTextColor: UIColor
    let sectionHeaderTextColor: UIColor
    let separatorColor: UIColor
    let borderColor: UIColor
    let mediaCategorySeparatorColor: UIColor
    let tabBarColor: UIColor
    let themeUI: UIColor
    let gradientBlueDark = UIColor(0x1E88E5)
    let gradientBlueLight = UIColor(0x26C6DA)
    let toolBarStyle: UIBarStyle

    init(isDark: Bool,
                name: String,
                statusBarStyle: UIStatusBarStyle,
                navigationbarColor: UIColor,
                navigationbarTextColor: UIColor,
                background: UIColor,
                oppBackground: UIColor,
                primaryTextColor: UIColor,
                secondnaryTextColor: UIColor,
                cellBackgroundA: UIColor,
                cellBackgroundB: UIColor,
                cellDetailTextColor: UIColor,
                cellTextColor: UIColor,
                lightTextColor: UIColor,
                sectionHeaderTextColor: UIColor,
                separatorColor: UIColor,
                borderColor: UIColor,
                mediaCategorySeparatorColor: UIColor,
                tabBarColor: UIColor,
                themeUI: UIColor,
                toolBarStyle: UIBarStyle) {
        self.isDark = isDark
        self.name = name
        self.statusBarStyle = statusBarStyle
        self.navigationbarColor = navigationbarColor
        self.navigationbarTextColor = navigationbarTextColor
        self.background = background
        self.oppBackground = oppBackground
        self.primaryTextColor = primaryTextColor
        self.secondnaryTextColor = secondnaryTextColor
        self.cellBackgroundA = cellBackgroundA
        self.cellBackgroundB = cellBackgroundB
        self.cellDetailTextColor = cellDetailTextColor
        self.cellTextColor = cellTextColor
        self.lightTextColor = lightTextColor
        self.sectionHeaderTextColor = sectionHeaderTextColor
        self.separatorColor = separatorColor
        self.borderColor = borderColor
        self.mediaCategorySeparatorColor = mediaCategorySeparatorColor
        self.tabBarColor = tabBarColor
        self.themeUI = themeUI
        self.toolBarStyle = toolBarStyle
    }
}
let brightPalette = ColorPalette(isDark: false,
                                 name: "Default",
                                 statusBarStyle: .autoDarkContent,
                                 navigationbarColor: UIColor(0xFFFFFF),
                                 navigationbarTextColor: UIColor(0x000000),
                                 background: UIColor(0xFFFFFF),
                                 oppBackground: UIColor(0x1C1C1C),
                                 primaryTextColor: UIColor(0x000000),
                                 secondnaryTextColor: UIColor(0x84929C),
                                 cellBackgroundA: UIColor(0xFFFFFF),
                                 cellBackgroundB: UIColor(0xE5E5E3),
                                 cellDetailTextColor: UIColor(0x84929C),
                                 cellTextColor: UIColor(0x000000),
                                 lightTextColor: UIColor(0x888888),
                                 sectionHeaderTextColor: UIColor(0x25292C),
                                 separatorColor: UIColor(0xDADADA),
                                 borderColor: UIColor(0x707070),
                                 mediaCategorySeparatorColor: UIColor(0xECF2F6),
                                 tabBarColor: UIColor(0xFFFFFF),
                                 themeUI: UIColor(0x2BBDDE),
                                 toolBarStyle: UIBarStyle.default)

let darkPalette = ColorPalette(isDark: true,
                               name: "Dark",
                               statusBarStyle: .lightContent,
                               navigationbarColor: UIColor(0x1B1E21),
                               navigationbarTextColor: UIColor(0xFFFFFF),
                               background: UIColor(0x1C1C1C),
                               oppBackground: UIColor(0xFFFFFF),
                               primaryTextColor: UIColor(0xFFFFFF),
                               secondnaryTextColor: UIColor(0x84929C),
                               cellBackgroundA: UIColor(0x1B1E21),
                               cellBackgroundB: UIColor(0x494B4D),
                               cellDetailTextColor: UIColor(0x84929C),
                               cellTextColor: UIColor(0xFFFFFF),
                               lightTextColor: UIColor(0xB8B8B8),
                               sectionHeaderTextColor: UIColor(0x828282),
                               separatorColor: UIColor(0xDADADA),
                               borderColor: UIColor(0x707070),
                               mediaCategorySeparatorColor: UIColor(0x25292C),
                               tabBarColor: UIColor(0x25292C),
                               themeUI: UIColor(0x2BBDDE),
                               toolBarStyle: UIBarStyle.black)

// MARK: - Application Theme
struct Theme {
    
    static var shared = Theme()
    
    static var colors = AppColors()
    static var images = AppImages()
    static var strings = AppStrings()
    static var fonts = AppFonts()
    static var dateFormats = AppDateFormats()
    
    func changeTheme() {
        Theme.colors = AppColors()
        Theme.images = AppImages()
        Theme.strings = AppStrings()
        Theme.fonts = AppFonts()
        Theme.dateFormats = AppDateFormats()
    }
    
}


// MARK: - Application Images
struct AppImages {
    let btnBgWOShadow = UIImage(named: "btnBgWOShadow")
}


// MARK: - Application Colors
struct AppColors {
    
//    var themeColors: ColorPalette {
//        get {
//            if isSystemDarkMode {
//                return darkPalette
//            }
//            return brightPalette
//        }
//    }
    
    let white = UIColor.white
    let black = UIColor.black
    let blue = UIColor.blue
    let red = UIColor.red
    
    let black_40_opacity = UIColor.black.withAlphaComponent(0.4)
    let white_40_opacity = UIColor.black.withAlphaComponent(0.4)
    
    let off_white_F9F9F9 = UIColor(hex: "F9F9F9")
    
    let gray_7E7E7E = UIColor(hex: "7E7E7E")
    let gray_666666 = UIColor(hex: "666666")
    let gray_707070 = UIColor(hex: "707070")
    let gray_999999 = UIColor(hex: "999999")
    let gray_CDD4D9 = UIColor(hex: "CDD4D9")
    let gray_DDDDDD = UIColor(hex: "DDDDDD")
    let gray_EEEEEE = UIColor(hex: "EEEEEE")
    
    let black_404040 = UIColor(hex: "404040")
    
    // NSC Coach App Colors
    let textColor = UIColor(hex: "1D272E")
    let theme_dark = UIColor(hex: "F39200")
    let theme_light = UIColor(hex: "FFF7EC")
    
}


// MARK: - Application Fonts
struct AppFonts {
    
    // Font Family
    let fontFamily = "Poppins"
    
    // Fonts
    let extraLight = "Poppins-ExtraLight"
    let light = "Poppins-Light"
    let medium = "Poppins-Medium"
    let semiBold = "Poppins-SemiBold"
    let bold = "Poppins-Bold"
    let regular = "Poppins-Regular"
    
    func appFont(ofSize size : CGFloat, weight : UIFont.Weight) -> UIFont {
        switch weight {
        case .ultraLight:
            return UIFont(name: extraLight, size: size) ?? UIFont.systemFont(ofSize: size, weight: .ultraLight)
        case .light:
            return UIFont(name: light, size: size) ?? UIFont.systemFont(ofSize: size, weight: .light)
        case .medium:
            return UIFont(name: medium, size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
        case .semibold:
            return UIFont(name: semiBold, size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
        case .bold:
            return UIFont(name: bold, size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
        default:
            return UIFont(name: regular, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
        }
    }
    
}


// MARK: - Application Date Formats
struct AppDateFormats {
    let backend = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
    let backend2 = "yyyy-MM-dd HH:mm:ss"
    let common = "dd/MM/yyyy"
    let navigationBarFormat = "EEEE, MMMM dd"
    let eventsFormat = "MMM dd, yyyy"
    let eventStartDateFormat = "yyyy-MM-dd hh:mm:ss"
    let comment = "MMM dd, yyyy, hh:mm a"
    let DOB_Backend = "yyyy-MM-dd"
    let DOB_App = "dd MMM, yyyy"
    let Billing_Order_App = "dd MMMM, yyyy"
}


// MARK: - Application Strings
struct AppStrings {
    
    /* Disclaimer Popup */
    let disclaimer_title = "Disclaimer"
    let disclaimer_description = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd"
    
    /* UserDefault Keys */
    let logged_in_user = "logged_in_user"
    
    /* Button Titles */
    let ok = "OK"
    let cancel = "CANCEL"
    let cancel_small = "Cancel"
    let resend_small = "Resend"
    let yes = "YES"
    let no = "NO"
    let logout = "Log Out"
    let delete = "DELETE"
    let close = "CLOSE"
    let confirm = "CONFIRM"
    let goBack = "GO BACK"
    let settings = "Settings"
    let deleteCoach = "Delete Coach"
    
    
    /* App Update Popup */
    let cancel_plan_alert_title = "Cancel Plan"
    let cancel_plan_alert_description = "Since you'd originally purchased the plan from an Android device, please cancel your plan from the Play Store."
    let cancel_plan_alert_subtitle = "Are you sure you want to cancel your subscription?"
    
    /* App Update Popup */
    let update = "UPDATE"
    let not_now = "NOT NOW"
    
    let normal_update_title = "Update NSC Coach App"
    let normal_update_subtitle = "NSC Coach App recommends that you update to the latest version"
    
    let force_update_title = "Update Required"
    let force_update_subtitle = "To keep using NSC Coach App, download the latest version"
    
    let delete_account_alert_title = "Are you sure you want to permanently delete this account?"
    let delete_account_alert_subtitle = "You can't undo this action"
    
    let delete_user_alert_title = "Are you sure you want to remove user?"
    let delete_user_alert_subtitle = "You can't undo this action"
    
    /* Common Strings */
    let please_wait = "Please wait"
    
    let request_sent = "Request sent"
    let request_expired = "Request expired"
    
    let alert_title_allow_notifications = "We're unable to reach out!"
    let alert_subtitle_allow_notifications = "Please enable notifications, so we can pass on important info, as well as messages that lift you up."
    
    let comming_soon_title = "Coming Soon"
    let comming_soon_subtitle = "The next steps forward in your journey will be available shortly."
    
    let date_of_birth = "Date of Birth"
    
    let no_contacts_to_display = "No contacts to display."
    
    let take_a_photo = "Take a Photo"
    let choose_from_gallary = "Choose from Gallary"
    let remove_photo = "Remove Photo"
    let profile_image_options = "Profile Image Options"
    
    /* Screen Contents */
    let welcome_title = "NSC Coach App"
    let welcome_subtitle = "Your one-stop solution for mental & emotional health challenges"
    
    let register_title = "Sign Up"
    let register_subtitle = "We just need few details to get you started!!"
    
    let otp_subtitle = "Please enter the OTP to begin your journey towards better mental health."
    
    let login_title = "Log In"
    let login_subtitle = "Hope you're feeling much better than you felt before!!"
    
    let forgot_password_title = "Forgot your password"
    let forgot_password_subtitle = "Give us your registered email ID and we'll send you everything that you'll need to change your password"
    
    let couser_listing_title = "Welcome to NSC Coach App"
    let couser_listing_subtitle = "Simply sign-in to your account and continue your journey towards mental & emotional transformation"
    
    let couser_welcome_subtitle = "It's good to have you here..."
    
    let tap_anywhere_to_continue = "TAP anywhere to continue"
    
    let thank_you_subtitle = "Congratulations on joining NSC Coach App Family."
    
    /* Billing order */
    let Last_Renewed = "Last Renewed"
    let upgradePlan_subtitle = "Get the most out of NSC Coach App. Now you can add additional accounts get your loved ones started on their journey towards mental & emotional transformation. Upgrade your subscription plan right now!!"
    
    /* Alert Strings */
    let alert_check_internet = "Internet connection seems to be offline."
    let alert_something_went_wrong = "Something went wrong"
    
    let alert_logout_message = "Are you sure you want to log out \nNSC Coach App??"
    let alert_blank_inputField_error = "Please fill required details"
    
    let alert_search_term_not_found = "Please try again with another search term."
    let alert_country_search = "Sorry we are not available in this country yet"
    
    /* Auth & Profile */
    let alert_blank_mobile_error = "Please enter your mobile number"
    let alert_invalid_mobile_error = "Please provide a valid mobile number"
    let alert_blank_email_error = "Email address is required"
    let alert_invalid_email_error = "Please provide a valid email address"
    let alert_invalid_otp = "Please use a valid PIN to access your account"
    
    let alert_blank_firstname_error = "Please provide First Name"
    let alert_blank_lastname_error = "Please provide Last Name"
    let alert_blank_dob_error = "Date of Birth should not be blank"
    let alert_dob_error = "Please confirm whether you are above 1 day"
    let alert_invalid_fullname_error = "Please enter valid Name"
    
    /* Personal Details */
    let alert_blank_street_error = "Please provide Street Address"
    let alert_select_state = "Please select State"
    let alert_select_city = "Please select City"
    let alert_blank_postcode_error = "Please provide Post Code"
    let alert_invalid_postcode_error = "Please provide a valid Post Code"
    let alert_select_camp = "Please select Camp"
    let alert_select_role = "Please select Role"
    let alert_blank_vaccination_error = "Please provide Vaccination Status"
    
    /* Bank Details */
    let alert_blank_bankname_error = "Please provide Bank Name"
    let alert_blank_accountnumber_error = "Please provide Account Number"
    let alert_invalid_accountnumber_error = "Please provide a valid Account Number"
    let alert_blank_accountname_error = "Please provide Account Name"
    let alert_blank_ifsccode_error = "Please provide IFSC Code"
    let alert_invalid_ifsccode_error = "Please provide a valid IFSC Code"
    
    /* Alert Popup */
    let alert_camera_not_available = "Camera is not available on this device."
    
    let alert_blank_password_error = "Please enter password"
    let alert_invalid_password_error = "Password should contain at least one uppercase, one lowercase, one special symbol and minimum 8 character long"
    let alert_password_not_match = "Please check if both the passwords are same"
    
    let alert_blank_pin_error = "Please provide 4 digit PIN"
    let alert_black_new_pin = "Please provide the latest 4 digit PIN to login"
    let alert_pin_not_match = "Please check if both the PINs are same"
    
    let alert_select_login_user = "Please select atleast one to proceed"
    
    let alert_cannot_send_message = "Cannot send the message"
    
    let alert_blank_search = "Please enter search text"
    let alert_select_category = "Please select a category"
    
    /* Membership Plan */
    let alert_reactivate_plan = "Please activate your membership plan"
    let alert_plan_already_canceled = "Your membership plan has been already canceled."
    let alert_upgrade_plan = "Please upgrade your current plan"
    let alert_cannot_open_subscription_setting = "Cannot open the subscription settings"
    
    let alert_select_day_and_time = "Please select days and Time"
    
    /* Add User */
    let same_num_title = "Invite a Friend or Family Member"
    let same_num_desc = "Happiness is sweeter when shared. That's why we're eager for you to share your subscription with someone you care for." + "\n" + "The first person invited gets the same benefits as you at no additional cost."
    
}

// MARK: - UIStatusBarStyle - autoDarkContent

extension UIStatusBarStyle {
    static var autoDarkContent: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
}

@objc extension UIColor {

    convenience init(_ rgbValue: UInt32, _ alpha: CGFloat = 1.0) {
        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0xFF00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }

    private func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            assertionFailure()
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count == 4 {
            a = Float(components[3])
        }

        if alpha {
            return String(format: "#%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }

    var toHex: String? {
        return toHex()
    }
}
