//
//  APIRouter.swift
//  NSC_iOS
//
//  Created by Dhruvit on 28/04/22.
//

import Foundation
import CryptoKit
import Alamofire


enum APIRouter : URLRequestConvertible {
    
    case appversion([String:String])
    case countrylist
    case logincheck([String:String])
    
    case login([String:String])
    case coachregister([String:String])
    case coachdetails([String:String])
    
    
    var route: APIRoute {
        switch self {
        case .appversion(let data):
            return APIRoute(path: "app-version", method: .post, data: data)
        case .countrylist:
            return APIRoute(path: "country-listing", method: .get)
        case .logincheck(let data):
            return APIRoute(path: "logincheck", method: .post, data: data)
        
        case .login(let data):
            return APIRoute(path: "login", method: .post, data: data)
        case .coachregister(let data):
            return APIRoute(path: "coachregister", method: .post, data: data)
        case .coachdetails(let data):
            return APIRoute(path: "coachdetails", method: .post, data: data)
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        let route = self.route
        let url = URL(string: API_BASE_URL)!
        var mutableURLRequest = URLRequest(url: url.appendingPathComponent(route.path))
        mutableURLRequest.httpMethod = route.method.rawValue
        
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        // mutableURLRequest.setValue("1", forHTTPHeaderField: "Test")
        mutableURLRequest.setValue(APIManager.shared.generateToken(), forHTTPHeaderField: "Oauth")
        mutableURLRequest.setValue(DEVICE_UUID, forHTTPHeaderField: "Yaccess")
        
        print("API Parameters :- ", route.data ?? "")
        print("API Path :- ", API_BASE_URL + route.path)
        
        if let data = route.data {
            if route.method == .get {
                return try Alamofire.URLEncoding.default.encode(mutableURLRequest, with: data)
            }
            return try Alamofire.JSONEncoding.default.encode(mutableURLRequest, with: data)
        }
        return mutableURLRequest
    }
    
}


extension Dictionary {
    var queryString: String {
        var output: String = ""
        for (key,value) in self {
            output +=  "\(key)=\(value)&"
        }
        output = String(output.dropLast())
        return output
    }
}
