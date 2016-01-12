//
//  StatisticViewController.swift
//  Sightwalk
//
//  Created by Nigel de Mie on 17/11/15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit
import Charts

class StatisticViewController: UIViewController {
    
    @IBOutlet var segmentedControlView: UIView!
    @IBOutlet var barChartView: BarChartView!
    
    let days = ["Ma", "Di", "Wo", "Do", "Vr", "Za", "Zo"]
    let weeks = ["Week 1", "Week 2", "Week 3", "Week 4"]
    
    let testKilometers = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    
    @IBAction func changeSegmentedControl(sender: AnyObject) {
        switch sender.selectedSegmentIndex {
        case 0:
            setChart(days, values: testKilometers)
            break;
        case 1:
            setChart(weeks, values: testKilometers)
            break;
        default:
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        barChartView.noDataText = "Er is nog geen data beschikbaar!"
        
        setChart(weeks, values: testKilometers)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Kilometers gelopen")
        chartDataSet.colors = [UIColor(red:0.102, green:0.788, blue:0.341, alpha:1)]
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        barChartView.descriptionText = ""
        barChartView.data = chartData
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

}
