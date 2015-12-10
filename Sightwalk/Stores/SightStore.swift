//
//  SightStore.swift
//  Sightwalk
//
//  Created by Boris Besemer on 10-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import Foundation
import Alamofire

class SightStore {
    class var sharedInstance: SightStore {
        struct Singleton {
            static let instance = SightStore()
        }
        return Singleton.instance
    }
    
    var sights = [Sight]()
    var userPriority = 0
    
    func getImage(id: Int, onCompletion: (NSData) -> ()) {
        Alamofire.request(.GET, sights[id].imgurl)
        .responseData({ request in
            onCompletion(request.data!)
        })
    }
}