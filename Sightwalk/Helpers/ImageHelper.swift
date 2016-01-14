//
//  ImageHelper.swift
//  Sightwalk
//
//  Created by frank kuipers on 1/14/16.
//  Copyright © 2016 Sightwalk. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ImageHelper: NSObject {

    private var image : UIImage?
    private var path : NSURL?
    
    func setImage(image : UIImage) {
        self.image = image
        storeTemporarily()
    }
    
    private func storeTemporarily() {
        if image == nil {
            return
        }
        
        let photoUrl = getSightPathFor("_")
        let imageData = NSData(data: UIImagePNGRepresentation(image!)!)
        
        _ = imageData.writeToURL(photoUrl!, atomically: true)
        path = photoUrl
    }
    
    func uploadFor(sightId : Int, success: (response : JSON) -> (), failure: (errorCode : Int) -> ()) {
        if image == nil {
            print("select image first")
            return
        }
        
        if path == nil {
            print("could not read file")
            return
        }
        
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            doUploadFor(sightId, success: success, failure: failure)
        #else
            let newPath = getPathFor(sightId)
            let fm = NSFileManager.defaultManager()
            do {
                print(path!.fileURL ? "file" : "nofile")
                try fm.moveItemAtPath(path!.path!, toPath: newPath!.path!)
                path = newPath
                doUploadFor(sightId, success: success, failure: failure)
            } catch {
                print("cannot move file")
            }
        #endif
    }
    
    private func doUploadFor(sightId : Int, success: (response : JSON) -> (), failure: (errorCode : Int) -> ()) {
        let URL = NSURL(string: ServerConstants.address)!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(ServerConstants.Sight.store + String(sightId) + "/photo"))
    
        LoginPersistenceHelper.SharedInstance.accessToken({ token in
            let headers = [
                "AuthToken": token
            ]
            
            //todo remove
            self.path = NSBundle.mainBundle().URLForResource("koala", withExtension: "jpg")
            
            Alamofire.upload(Method.POST, URLRequest, headers: headers, multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: self.path!, name: "sightImage")
            }, encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)
                        }
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
            })
        })
        
    }
    
    private func getPathFor(sightId : Int) -> NSURL? {
        return getSightPathFor(String(sightId))
    }
    
    private func getSightPathFor(name : String) -> NSURL? {
        let manager = NSFileManager.defaultManager()
        do {
            let directoryURL = try manager.URLForDirectory(.PicturesDirectory, inDomain:.UserDomainMask, appropriateForURL:nil, create:true)
            return directoryURL.URLByAppendingPathComponent("sight/" + name + ".png")
        } catch {
            print("could not store image")
        }
        
        return nil
    }

}
