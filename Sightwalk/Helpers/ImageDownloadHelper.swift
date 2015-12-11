//
//  ImageDownloadHelper.swift
//  Sightwalk
//
//  Created by Boris Besemer on 11-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import Foundation
import Alamofire

/**
 * ImageDownloadHelper
 * Downloads images asynchronously using Alamofire
 * accepts URL string and returns image as NSData
*/

class ImageDownloadHelper {
    func downloadImage(url: String, onCompletion: (NSData) -> ()) {
        Alamofire.request(.GET, url)
        .responseData({ request in
            onCompletion(request.data!)
        })
    }
}