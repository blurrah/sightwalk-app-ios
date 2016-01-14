//
//  StatisticViewController.swift
//  Sightwalk
//
//  Created by Nigel de Mie on 17/11/15.
//  Copyright © 2015 Sightwalk. All rights reserved.
//

import UIKit
import Charts
import SwiftDate

class StatisticViewController: UIViewController {
    
    @IBOutlet var segmentedControlView: UIView!
    @IBOutlet var barChartView: BarChartView!
    
    private var activities : [Activity]! = []
    private let activityStore : RouteStore = RouteStore.sharedInstance
    
    let days = ["Zo", "Ma", "Di", "Wo", "Do", "Vr", "Za"]
    let weeks = ["Week 1", "Week 2", "Week 3", "Week 4"]
    
    let testKilometers = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
    
    @IBAction func changeSegmentedControl(sender: AnyObject) {
        switch sender.selectedSegmentIndex {
        case 0:
            setChart(days, values: getWeekStatistics())
            break;
        case 1:
            setChart(weeks, values: getMonthStatistics())
            break;
        default:
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        barChartView.noDataText = "Er is nog geen data beschikbaar!"
        
        setChart(days, values: getWeekStatistics())
    }
    
    func setChart(dataPoints: [String], values: [Int: Double]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i] ?? 0, xIndex: i)
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
    
    private func getWeekStatistics() -> [Int: Double] {
        let beginningOfWeek = DatetimeHelper.getBeginDate(.Week)
        
        var activityPerDay: [Int: Double] = [:]
        
        // Pak alle activities
        activities = activityStore.getAllActivities()

        var withinTimeframe: [Activity] = []
        
        for activity in activities {
            let activityDate = activity.getDate()
            if (activityDate >= beginningOfWeek) {
                withinTimeframe.append(activity)
            }
        }
        
        var day: NSDate? = beginningOfWeek!
        
        for i in 0...6 {
            if i > 0 {
                day = (day! + 1.days)
            }
            
            for item in withinTimeframe {
                if (item.getDate() >= day! && item.getDate() <= (day! + 1.days)) {
                    let distance = Double(item.getTotalDistance())
                    
                    if var currentDistance = activityPerDay[i] {
                        currentDistance += distance!
                        activityPerDay[i] = currentDistance
                    } else {
                        activityPerDay[i] = distance!
                    }
                }
            }
        }
        
        return activityPerDay
    }
    
    private func getMonthStatistics() -> [Int: Double] {
        let beginningOfMonth = DatetimeHelper.getBeginDate(.Month)
        
        var activityPerWeek: [Int: Double] = [:]
        
        activities = activityStore.getAllActivities()
        
        var withinTimeframe: [Activity] = []
        
        for activity in activities {
            let activityDate = activity.getDate()
            if (activityDate >= beginningOfMonth) {
                withinTimeframe.append(activity)
            }
        }
        
        var week: NSDate? = beginningOfMonth!
        
        for i in 0...3 {
            if i > 0 {
                week = (week! + 1.weeks)
            }
        
            for item in withinTimeframe {
                if (item.getDate() >= week! && item.getDate() <= (week! + 1.weeks)) {
                    let distance = Double(item.getTotalDistance())
                
                    if var currentDistance = activityPerWeek[i] {
                        currentDistance += distance!
                        activityPerWeek[i] = currentDistance
                    } else {
                        activityPerWeek[i] = distance!
                    }
                }
            }
        }
        return activityPerWeek
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
