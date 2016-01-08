//
//  RouteDetailDirectionsViewController.swift
//  Sightwalk
//
//  Created by Boris Besemer on 17-12-15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit

protocol RouteDetailDirectionsViewControllerDelegate {
    func routeDetailDirectionsViewControllerButtonPressed(controller: UIViewController, info: AnyObject?)
}

class RouteDetailDirectionsViewController: UIViewController, UIScrollViewDelegate {
    
    var delegate: RouteDetailDirectionsViewControllerDelegate?
    
    let chosenSights = SightStore.sharedInstance.userChosen
    var scrollView: UIScrollView!
    var containerView: UIView!
    var spacer: CGFloat = 30

    @IBAction func tapSightsButton(sender: AnyObject) {
        delegate!.routeDetailDirectionsViewControllerButtonPressed(self, info: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let directions = RouteStore.sharedInstance.directions
        
        // Set up scroll and container view
        self.scrollView = UIScrollView(frame: view.bounds)
        self.containerView = UIView()
        
        self.scrollView.delegate = self
        self.scrollView.contentSize = self.containerView.bounds.size
        self.scrollView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        
        
        
        self.scrollView.addSubview(self.containerView)
        self.view.addSubview(scrollView)
        
        // Loop and add sight names + directions
        for (var i = 0; i < chosenSights.count; i++) {
            
            for direction in directions[i]! {
                let label = UILabel(frame: CGRectMake(0, 0, 300, 21))
                label.textColor = UIColor.blackColor()
                label.center = CGPointMake(160, 50 + self.spacer)
                label.font = UIFont(name: label.font.fontName, size: 12)
                label.text = direction.htmlToString
                
                self.containerView.addSubview(label)
                
                self.spacer += 30
            }
            let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
            label.textColor = UIColor(red:0.102, green:0.788, blue:0.341, alpha:1)
            label.center = CGPointMake(160, 50 + self.spacer)
            label.text = chosenSights[i].title
            
            self.containerView.addSubview(label)
            
            self.spacer += 30
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = self.spacer + 80
        self.scrollView.contentSize = CGSize(width: 0, height: height)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = dataUsingEncoding(NSUTF8StringEncoding) else {
            return nil
        }
        
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
