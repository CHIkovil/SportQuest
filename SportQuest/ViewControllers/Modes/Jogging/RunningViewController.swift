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
import BatteryView
import StepSlider

class RunningViewController: UIViewController, TabItem {
    
    //MARK: View
    lazy var runningScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize.height = 800
//        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var runningActivityChartView: CombinedChartView = {
        let barChartView = CombinedChartView()
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.backgroundColor = .lightGray
        return barChartView
    }()
    
    lazy var formatForChartSwitchView: BetterSegmentedControl = {
        let segmentView = BetterSegmentedControl(frame: CGRect(), segments: LabelSegment.segments(withTitles:["Week","Month"]))
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.cornerRadius = 20
        segmentView.addTarget(self,
        action: #selector(changeRunningActivityChart),
        for: .valueChanged)
        return segmentView
    }()
    
    lazy var runningLevelСharacterView:BatteryView = {
        let batteryView = BatteryView()
        batteryView.translatesAutoresizingMaskIntoConstraints = false
        batteryView.level = 70
        batteryView.lowThreshold = 25
        batteryView.gradientThreshold = 20
        batteryView.borderWidth = 2.5
        batteryView.cornerRadius = 20
        batteryView.highLevelColor = .black
        batteryView.lowLevelColor  = .red
        batteryView.noLevelColor   = .gray
        return batteryView
    }()
    
    lazy var runningNormSliderView:StepSlider = {
        let sliderView = StepSlider()
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.maxCount = 20
        sliderView.trackColor = .black
        sliderView.sliderCircleColor = .red
        sliderView.tintColor = .lightGray
        return sliderView
    }()
    
    //MARK: Label
    lazy var runningNormLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1000m"
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.cornerRadius = 20
        label.layer.borderWidth = 2
        label.textAlignment = .center
        return label
    }()
    
    //MARK: Button
    lazy var runningStartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 30
        button.layer.borderWidth = 2
        return button
    }()
    
    lazy var runningStoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Store", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        return button
    }()
    
    lazy var runningСycleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cycle", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        return button
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
        runningScrollView.addSubview(runningActivityChartView)
        runningScrollView.addSubview(formatForChartSwitchView)
        runningScrollView.addSubview(runningLevelСharacterView)
        runningScrollView.addSubview(runningNormSliderView)
        runningScrollView.addSubview(runningNormLabel)
        runningScrollView.addSubview(runningStartButton)
        runningScrollView.addSubview(runningStoreButton)
        runningScrollView.addSubview(runningСycleButton)
        createConstraintscreateRunningActivityBarChartView()
        createConstraintsFormatForChartSwitchControl()
        createConstraintsRunningLevelСharacterView()
        createConstraintsRunningNormSliderView()
        createConstraintsRunningNormLabel()
        createConstraintsRunningStartButton()
        createConstraintsRunningStoreButton()
        createConstraintsRunningСycleButton()
    }
    
    func setWeekDataForRunningActivityBarChartView() {
        let data = CombinedChartData()
        data.lineData = generateLineData()
        data.barData = generateBarData()
        data.bubbleData = generateBubbleData()
        data.scatterData = generateScatterData()
        data.candleData = generateCandleData()
        
        runningActivityChartView.xAxis.axisMaximum = data.xMax + 0.25
        
        runningActivityChartView.data = data
    }
    
    func setMonthDataRunningActivityBarChartView() {
        let data = CombinedChartData()
        data.lineData = generateLineData()
        data.barData = generateBarData()
        data.bubbleData = generateBubbleData()
        data.scatterData = generateScatterData()
        data.candleData = generateCandleData()
        
        runningActivityChartView.xAxis.axisMaximum = data.xMax + 0.25
        
        runningActivityChartView.data = data
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
    
    //MARK: ConstraintsView
    func createConstraintsRunningScrollView() {
        runningScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        runningScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        runningScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        runningScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80).isActive = true
    }
    
    func createConstraintscreateRunningActivityBarChartView() {
       runningActivityChartView.topAnchor.constraint(equalTo: runningScrollView.topAnchor, constant: 50).isActive = true
       runningActivityChartView.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
       runningActivityChartView.heightAnchor.constraint(equalToConstant: 200).isActive = true
       runningActivityChartView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func createConstraintsFormatForChartSwitchControl() {
        formatForChartSwitchView.topAnchor.constraint(equalTo: runningActivityChartView.bottomAnchor, constant: 20).isActive = true
        formatForChartSwitchView.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
        formatForChartSwitchView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        formatForChartSwitchView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    
    func createConstraintsRunningLevelСharacterView() {
        runningLevelСharacterView.topAnchor.constraint(equalTo: formatForChartSwitchView.bottomAnchor, constant: 20).isActive = true
        runningLevelСharacterView.leadingAnchor.constraint(equalTo: formatForChartSwitchView.leadingAnchor).isActive = true
        runningLevelСharacterView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        runningLevelСharacterView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
     
    func createConstraintsRunningNormSliderView() {
        runningNormSliderView.topAnchor.constraint(equalTo: formatForChartSwitchView.bottomAnchor, constant: 30).isActive = true
        runningNormSliderView.trailingAnchor.constraint(equalTo: formatForChartSwitchView.trailingAnchor).isActive = true
        runningNormSliderView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        runningNormSliderView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    //MARK: ConstraintsLabel
    func createConstraintsRunningNormLabel() {
        runningNormLabel.topAnchor.constraint(equalTo: runningNormSliderView.bottomAnchor, constant: 5).isActive = true
        runningNormLabel.centerXAnchor.constraint(equalTo: runningNormSliderView.centerXAnchor).isActive = true
        runningNormLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        runningNormLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //MARK: ConstraintsButton
     func createConstraintsRunningStartButton() {
         runningStartButton.topAnchor.constraint(equalTo: runningNormLabel.bottomAnchor, constant: 20).isActive = true
         runningStartButton.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
         runningStartButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
         runningStartButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
     }
    
    func createConstraintsRunningStoreButton() {
        runningStoreButton.topAnchor.constraint(equalTo: runningStartButton.bottomAnchor, constant: 10).isActive = true
        runningStoreButton.centerXAnchor.constraint(equalTo: runningStartButton.centerXAnchor).isActive = true
        runningStoreButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        runningStoreButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func createConstraintsRunningСycleButton() {
        runningСycleButton.topAnchor.constraint(equalTo: runningStoreButton.bottomAnchor, constant: 10).isActive = true
        runningСycleButton.centerXAnchor.constraint(equalTo: runningStartButton.centerXAnchor).isActive = true
        runningСycleButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        runningСycleButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
