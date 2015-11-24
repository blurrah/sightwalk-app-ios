//
//  LoadingOverlayView.swift
//  
//
//  Created by Boris Besemer on 24-11-15.
//
//

import Foundation
import UIKit

public class LoadingOverlayView {
    class var sharedInstance: LoadingOverlayView {
        struct Singleton {
            static let instance = LoadingOverlayView()
        }
        return Singleton.instance
    }
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    public func showOverlayView(view: UIView!) {
        overlayView = UIView(frame: UIScreen.mainScreen().bounds)
        overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicator.center = overlayView.center
        
        overlayView.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        view.addSubview(overlayView)
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        
        overlayView.removeFromSuperview()
    }

}
