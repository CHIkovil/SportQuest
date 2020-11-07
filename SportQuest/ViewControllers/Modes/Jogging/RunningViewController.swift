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
    //MARK: VIEW
    
    
    
    //MARK: runningScrollView
    lazy var runningScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize.height = 1020
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    //MARK: runningParametersBlockView
    lazy var runningParametersBlockView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 30
        return view
    }()
    
    //MARK: runningStoreBlockView
    lazy var runningStoreBlockView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 30
        return view
    }()
    
    //MARK: runningCycleBlockView
    lazy var runningCycleBlockView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.cornerRadius = 30
        return view
    }()
    
    //MARK: runningActivityChartView
    lazy var runningActivityChartView: CombinedChartView = {
        let barChartView = CombinedChartView()
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.backgroundColor = .lightGray
        return barChartView
    }()
    
    //MARK: formatForChartSwitchView
    lazy var runningFormatForChartSwitchView: BetterSegmentedControl = {
        let segmentView = BetterSegmentedControl(frame: CGRect(), segments: LabelSegment.segments(withTitles:["Week","Month"]))
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.cornerRadius = 20
        segmentView.addTarget(self,
                              action: #selector(changeRunningActivityChart),
                              for: .valueChanged)
        return segmentView
    }()
    
    //MARK: runningLevelСharacterView
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
    
    //MARK: runningNormSliderView
    lazy var runningNormSliderView:StepSlider = {
        let sliderView = StepSlider()
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.maxCount = 20
        sliderView.trackColor = .black
        sliderView.sliderCircleColor = .red
        sliderView.tintColor = .lightGray
        return sliderView
    }()
    
    //MARK: LABEL
    
    
    
    //MARK: runningNormLabel
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
    
    //MARK: BUTTON
    
    
    
    //MARK: runningParametersBlock
    lazy var runningParametersBlockButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Parameters", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(activationParametersBlock),
                                     for: .primaryActionTriggered)
        return button
    }()
    
    //MARK: runningStartButton
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
    
    //MARK: runningStoreBlockButton
    lazy var runningStoreBlockButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Store", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(activationStoreBlock),
                         for: .primaryActionTriggered)
        return button
    }()
    
    //MARK: runningСycleBlockButton
    lazy var runningСycleBlockButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cycle", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(activationСycleBlock),
                                     for: .primaryActionTriggered)
        return button
    }()
    
    //MARK: Image for AMTabsView
    var tabImage: UIImage? {
        return UIImage(named: "running.png")
    }
    
    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        view.addSubview(runningScrollView)
        createConstraintsRunningScrollView()
        
        runningScrollView.addSubview(runningActivityChartView)
        runningScrollView.addSubview(runningFormatForChartSwitchView)
        
        runningScrollView.addSubview(runningParametersBlockButton)
        runningScrollView.addSubview(runningParametersBlockView)
        
        runningScrollView.addSubview(runningStartButton)
        
        runningScrollView.addSubview(runningStoreBlockButton)
        runningScrollView.addSubview(runningStoreBlockView)
        
        runningScrollView.addSubview(runningСycleBlockButton)
        runningScrollView.addSubview(runningCycleBlockView)
        
        runningParametersBlockView.addSubview(runningLevelСharacterView)
        runningParametersBlockView.addSubview(runningNormSliderView)
        runningParametersBlockView.addSubview(runningNormLabel)
        
        createConstraintscreateRunningActivityBarChartView()
        createConstraintsRunningFormatForChartSwitchView()
        
        createConstraintsRunningParametersBlockButton()
        createConstraintsRunningParameterBlockView()
        createConstraintsRunningLevelСharacterView()
        createConstraintsRunningNormSliderView()
        createConstraintsRunningNormLabel()
        
        createConstraintsRunningStartButton()
        
        createConstraintsRunningStoreBlockButton()
        createConstraintsRunningStoreBlockView()
        
        createConstraintsRunningСycleBlockButton()
        createConstraintsRunningCycleBlockView()
    }
    
    //MARK: STUFF
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
    //MARK: @OBJC
    
    
    
    //MARK: changeRunningActivityChart
    @objc func changeRunningActivityChart(){
        if runningFormatForChartSwitchView.index == 0 {
            setWeekDataForRunningActivityBarChartView()
        }else{
            setMonthDataRunningActivityBarChartView()
        }
    }
    
    //MARK: activationParametersBlock
    @objc func activationParametersBlock() {
    }
    
    //MARK: activationStoreBlock
    @objc func activationStoreBlock() {
    }
    
    //MARK: activationСycleBlock
    @objc func activationСycleBlock() {

    }
    //MARK: CONSTRAINTS VIEW
    
    
    
    //MARK: ConstraintsRunningScrollView
    func createConstraintsRunningScrollView() {
        runningScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        runningScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        runningScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        runningScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    //MARK: ConstraintsRunningParameterBlockView
    func createConstraintsRunningParameterBlockView() {
        runningParametersBlockView.topAnchor.constraint(equalTo: runningParametersBlockButton.bottomAnchor, constant: 10).isActive = true
        runningParametersBlockView.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
        runningParametersBlockView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        runningParametersBlockView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    //MARK: ConstraintsRunningStoreBlockView
    func createConstraintsRunningStoreBlockView() {
        runningStoreBlockView.topAnchor.constraint(equalTo: runningStoreBlockButton.bottomAnchor, constant: 10).isActive = true
        runningStoreBlockView.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
        runningStoreBlockView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        runningStoreBlockView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    //MARK: ConstraintsRunningCycleBlockView
    func createConstraintsRunningCycleBlockView() {
        runningCycleBlockView.topAnchor.constraint(equalTo: runningСycleBlockButton.bottomAnchor, constant: 10).isActive = true
        runningCycleBlockView.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
        runningCycleBlockView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        runningCycleBlockView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    //MARK: ConstraintsRunningActivityChartView
    func createConstraintscreateRunningActivityBarChartView() {
        runningActivityChartView.topAnchor.constraint(equalTo: runningScrollView.topAnchor, constant: 50).isActive = true
        runningActivityChartView.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
        runningActivityChartView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        runningActivityChartView.widthAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    //MARK: ConstraintsRunningFormatForChartSwitchView
    func createConstraintsRunningFormatForChartSwitchView() {
        runningFormatForChartSwitchView.topAnchor.constraint(equalTo: runningActivityChartView.bottomAnchor, constant: 20).isActive = true
        runningFormatForChartSwitchView.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
        runningFormatForChartSwitchView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        runningFormatForChartSwitchView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    //MARK: ConstraintsRunningLevelСharacterView
    func createConstraintsRunningLevelСharacterView() {
        runningLevelСharacterView.topAnchor.constraint(equalTo: runningParametersBlockView.topAnchor, constant: 20).isActive = true
        runningLevelСharacterView.leadingAnchor.constraint(equalTo: runningParametersBlockView.leadingAnchor, constant: 20).isActive = true
        runningLevelСharacterView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        runningLevelСharacterView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    //MARK: ConstraintsRunningNormSliderView
    func createConstraintsRunningNormSliderView() {
        runningNormSliderView.topAnchor.constraint(equalTo: runningParametersBlockView.topAnchor, constant: 30).isActive = true
        runningNormSliderView.trailingAnchor.constraint(equalTo: runningParametersBlockView.trailingAnchor,constant: -20).isActive = true
        runningNormSliderView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        runningNormSliderView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    //MARK: CONSTRAINTS LABEL
    
    
    
    //MARK: ConstraintsRunningNormLabel
    func createConstraintsRunningNormLabel() {
        runningNormLabel.topAnchor.constraint(equalTo: runningNormSliderView.bottomAnchor, constant: 5).isActive = true
        runningNormLabel.centerXAnchor.constraint(equalTo: runningNormSliderView.centerXAnchor).isActive = true
        runningNormLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        runningNormLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //MARK:CONSTRAINTS BUTTON
    
    //MARK: createConstraintsRunningParametersBlockButton
    func createConstraintsRunningParametersBlockButton() {
        runningParametersBlockButton.topAnchor.constraint(equalTo: runningFormatForChartSwitchView.bottomAnchor, constant: 10).isActive = true
        runningParametersBlockButton.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
        runningParametersBlockButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        runningParametersBlockButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    //MARK: ConstraintsRunningStartButton
    func createConstraintsRunningStartButton() {
        runningStartButton.topAnchor.constraint(equalTo: runningParametersBlockView.bottomAnchor, constant: 20).isActive = true
        runningStartButton.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
        runningStartButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        runningStartButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    //MARK: createConstraintsRunningStoreBlockButton
    func createConstraintsRunningStoreBlockButton() {
        runningStoreBlockButton.topAnchor.constraint(equalTo: runningStartButton.bottomAnchor, constant: 10).isActive = true
        runningStoreBlockButton.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
        runningStoreBlockButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        runningStoreBlockButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    //MARK: createConstraintsRunningСycleBlockButton
    func createConstraintsRunningСycleBlockButton() {
        runningСycleBlockButton.topAnchor.constraint(equalTo: runningStoreBlockView.bottomAnchor, constant: 10).isActive = true
        runningСycleBlockButton.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
        runningСycleBlockButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        runningСycleBlockButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
