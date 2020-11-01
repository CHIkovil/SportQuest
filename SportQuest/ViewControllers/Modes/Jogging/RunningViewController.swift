//
//  JoggingViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 13.10.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//

import UIKit
import AMTabView
import BetterSegmentedControl
import Charts

class RunningViewController: UIViewController, TabItem {
    
    //MARK: View
    lazy var runningScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize.height = 700
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var runningActivityBarChartView: CombinedChartView = {
        let barChartView = CombinedChartView()
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.backgroundColor = .lightGray
        return barChartView
    }()
    
    //MARK: Control
    lazy var formatForChartViewSwitchControl: BetterSegmentedControl = {
        let segmentControl = BetterSegmentedControl(frame: CGRect(), segments: LabelSegment.segments(withTitles:["Week","Month"]))
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.cornerRadius = 20
        segmentControl.addTarget(self,
        action: #selector(changeRunningActivityChart),
        for: .valueChanged)
        return segmentControl
    }()
    
    //MARK: Image
    var tabImage: UIImage? {
      return UIImage(named: "running.png")
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.addSubview(runningScrollView)
        createConstraintsRunningScrollView()
        runningScrollView.addSubview(formatForChartViewSwitchControl)
        runningScrollView.addSubview(runningActivityBarChartView)
        createConstraintsFormatForChartSwitchControl()
        createConstraintscreateRunningActivityBarChartView()
    }
    
    func setWeekDataForRunningActivityBarChartView() {
        let data = CombinedChartData()
        data.lineData = generateLineData()
        data.barData = generateBarData()
        data.bubbleData = generateBubbleData()
        data.scatterData = generateScatterData()
        data.candleData = generateCandleData()
        
        runningActivityBarChartView.xAxis.axisMaximum = data.xMax + 0.25
        
        runningActivityBarChartView.data = data
    }
    
    func setMonthDataRunningActivityBarChartView() {
        let data = CombinedChartData()
        data.lineData = generateLineData()
        data.barData = generateBarData()
        data.bubbleData = generateBubbleData()
        data.scatterData = generateScatterData()
        data.candleData = generateCandleData()
        
        runningActivityBarChartView.xAxis.axisMaximum = data.xMax + 0.25
        
        runningActivityBarChartView.data = data
    }
    
    func generateLineData() -> LineChartData {
        let entries = (0..<12).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i) + 0.5, y: Double(arc4random_uniform(15) + 5))
        }
        
        let set = LineChartDataSet(entries: entries, label: "Line DataSet")
        set.setColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        set.lineWidth = 2.5
        set.setCircleColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        set.circleRadius = 5
        set.circleHoleRadius = 2.5
        set.fillColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        set.mode = .cubicBezier
        set.drawValuesEnabled = true
        set.valueFont = .systemFont(ofSize: 10)
        set.valueTextColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        
        set.axisDependency = .left
        
        return LineChartData(dataSet: set)
    }
    
    func generateBarData() -> BarChartData {
        let entries1 = (0..<12).map { _ -> BarChartDataEntry in
            return BarChartDataEntry(x: 0, y: Double(arc4random_uniform(25) + 25))
        }
        let entries2 = (0..<12).map { _ -> BarChartDataEntry in
            return BarChartDataEntry(x: 0, yValues: [Double(arc4random_uniform(13) + 12), Double(arc4random_uniform(13) + 12)])
        }
        
        let set1 = BarChartDataSet(entries: entries1, label: "Bar 1")
        set1.setColor(UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1))
        set1.valueTextColor = UIColor(red: 60/255, green: 220/255, blue: 78/255, alpha: 1)
        set1.valueFont = .systemFont(ofSize: 10)
        set1.axisDependency = .left
        
        let set2 = BarChartDataSet(entries: entries2, label: "")
        set2.stackLabels = ["Stack 1", "Stack 2"]
        set2.colors = [UIColor(red: 61/255, green: 165/255, blue: 255/255, alpha: 1),
                       UIColor(red: 23/255, green: 197/255, blue: 255/255, alpha: 1)
        ]
        set2.valueTextColor = UIColor(red: 61/255, green: 165/255, blue: 255/255, alpha: 1)
        set2.valueFont = .systemFont(ofSize: 10)
        set2.axisDependency = .left
        
        let groupSpace = 0.06
        let barSpace = 0.02 // x2 dataset
        let barWidth = 0.45 // x2 dataset
        // (0.45 + 0.02) * 2 + 0.06 = 1.00 -> interval per "group"
        
        let data =  BarChartData()
        data.dataSets = [set1, set2]
        data.barWidth = barWidth
        
        // make this BarData object grouped
        data.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        
        return data
    }
    
    func generateScatterData() -> ScatterChartData {
        let entries = stride(from: 0.0, to: Double(12), by: 0.5).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: i+0.25, y: Double(arc4random_uniform(10) + 55))
        }
        
        let set = ScatterChartDataSet(entries: entries, label: "Scatter DataSet")
        set.colors = ChartColorTemplates.material()
        set.scatterShapeSize = 4.5
        set.drawValuesEnabled = false
        set.valueFont = .systemFont(ofSize: 10)
        
        return ScatterChartData(dataSet: set)
    }
    
    func generateCandleData() -> CandleChartData {
        let entries = stride(from: 0, to: 12, by: 2).map { (i) -> CandleChartDataEntry in
            return CandleChartDataEntry(x: Double(i+1), shadowH: 90, shadowL: 70, open: 85, close: 75)
        }
        
        let set = CandleChartDataSet(entries: entries, label: "Candle DataSet")
        set.setColor(UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1))
        set.decreasingColor = UIColor(red: 142/255, green: 150/255, blue: 175/255, alpha: 1)
        set.shadowColor = .darkGray
        set.valueFont = .systemFont(ofSize: 10)
        set.drawValuesEnabled = false
        
        return CandleChartData(dataSet: set)
    }
    
    func generateBubbleData() -> BubbleChartData {
        let entries = (0..<12).map { (i) -> BubbleChartDataEntry in
            return BubbleChartDataEntry(x: Double(i) + 0.5,
                                        y: Double(arc4random_uniform(10) + 105),
                                        size: CGFloat(arc4random_uniform(50) + 105))
        }
        
        let set = BubbleChartDataSet(entries: entries, label: "Bubble DataSet")
        set.setColors(ChartColorTemplates.vordiplom(), alpha: 1)
        set.valueTextColor = .white
        set.valueFont = .systemFont(ofSize: 10)
        set.drawValuesEnabled = true
        
        return BubbleChartData(dataSet: set)
    }
    
    //MARK: changeRunningActivityChart
       @objc func changeRunningActivityChart(_ sender: BetterSegmentedControl){
            if sender.index == 0 {
                setWeekDataForRunningActivityBarChartView()
            }else{
                setMonthDataRunningActivityBarChartView()
        }
    }
    
    //MARK: ConstraintsScrollView
    func createConstraintsRunningScrollView() {
        runningScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        runningScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        runningScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        runningScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }
    
    //MARK: ConstraintsSwitchControl
    func createConstraintsFormatForChartSwitchControl() {
        formatForChartViewSwitchControl.topAnchor.constraint(equalTo: runningActivityBarChartView.bottomAnchor, constant: 20).isActive = true
        formatForChartViewSwitchControl.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
        formatForChartViewSwitchControl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        formatForChartViewSwitchControl.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
     //MARK: ConstraintsChartView
     func createConstraintscreateRunningActivityBarChartView() {
        runningActivityBarChartView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        runningActivityBarChartView.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
        runningActivityBarChartView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        runningActivityBarChartView.widthAnchor.constraint(equalToConstant: 200).isActive = true
     }
}

