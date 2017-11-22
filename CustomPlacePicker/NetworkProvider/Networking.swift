//
//  Provider.swift
//  EnCollect
//
//  Created by Kanwarpal Singh on 30/08/17.
//  Copyright © 2017 Kanwarpal Singh. All rights reserved.
//

import UIKit
import Alamofire

class Networking {
    
    class func getRequestApi(urlStr: String, completionHandler: @escaping (_ success:AnyObject) -> Void)  {
        
        guard let encodedUrl = urlStr.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else{
            let error = NSError.init(domain: "Error in url", code: 400, userInfo: [NSLocalizedDescriptionKey: "Error in url"])
            completionHandler(error as AnyObject)
            return
        }
        let url = URL(string: encodedUrl)
        var request = URLRequest(url: url!)
        request.httpMethod = Alamofire.HTTPMethod.get.rawValue
        
        Alamofire.request(request)
            .validate()
            .responseJSON { response in
                
                switch response.result {
                case .success:
                    print("Validation Successful")
                    
                    if let value = response.result.value {
                            print(value)
                    completionHandler(value as AnyObject)
                    }
                    
                case .failure(let error):
                    print(error)
                    completionHandler(error as AnyObject)
                }
            }
 
        
    }
}









