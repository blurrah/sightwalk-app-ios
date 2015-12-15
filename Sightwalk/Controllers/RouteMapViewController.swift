//
//  RouteMapViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 15-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

class RouteMapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        print(RouteStore.sharedInstance.chosenRoute!)
        let path = GMSPath(fromEncodedPath: RouteStore.sharedInstance.chosenRoute!)
        print(path)
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = UIColor.redColor()
        polyline.strokeWidth = 5.0
        print(polyline)
        
        polyline.map = mapView
        
        path.coordinateAtIndex(0)
        
        mapView.camera = GMSCameraPosition(target: path.coordinateAtIndex(0), zoom: 15, bearing: 0, viewingAngle: 0)

    }

}
