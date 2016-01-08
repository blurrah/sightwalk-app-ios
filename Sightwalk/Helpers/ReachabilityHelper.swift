//
//  ReachabilityHelper.swift
//  Sightwalk
//
//  Created by Nigel de Mie on 08/01/16.
//  Copyright © 2016 Sightwalk. All rights reserved.
//

import Foundation

public class ReachabilityHelper {
    
    class func isConnectedToNetwork()->Bool{
        var Status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        let session = NSURLSession.sharedSession()
        
        session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            print("data \(data)")
            print("response \(response)")
            print("error \(error)")
            
            if let httpResponse = response as? NSHTTPURLResponse {
                print("httpResponse.statusCode \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    Status = true
                }
            }
            
        }).resume()
        
        return Status
    }
}
