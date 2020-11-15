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
import fluid_slider
import MarqueeLabel
import AGCircularPicker

class RunningViewController: UIViewController, TabItem {
    //MARK: VIEW
    
    
    
    //MARK: runningScrollView
    lazy var runningScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize.height = 820
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    //MARK: runningParametersBlockView
    lazy var runningParametersBlockView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 30
        return view
    }()
    
    //MARK: runningStoreBlockView
    lazy var runningStoreBlockView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 30
        return view
    }()
    
    //MARK: runningTargetTimeBlockView
    lazy var runningTargetTimeBlockView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.gray.cgColor
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
        let segmentView = BetterSegmentedControl(frame: CGRect(), segments: LabelSegment.segments(withTitles:["Week","Month"], normalTextColor: .lightGray,
        selectedTextColor: #colorLiteral(red: 0.3046965897, green: 0.3007525206, blue: 0.8791586757, alpha: 1)))
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.cornerRadius = 20
        segmentView.addTarget(self,
                              action: #selector(changeRunningActivityChart),
                              for: .valueChanged)
        return segmentView
    }()
    
    //MARK: runningBlockSwitchView
    lazy var runningBlockSwitchView: BetterSegmentedControl = {
        let segmentView = BetterSegmentedControl(frame: CGRect(), segments: IconSegment.segments(withIcons: [UIImage(named: "bar-chart.png")!, UIImage(named: "cloud-computing.png")!, UIImage(named: "target.png")!],
                                       iconSize: CGSize(width: 30, height: 30),
                                       normalIconTintColor: .lightGray,
                                       selectedIconTintColor: #colorLiteral(red: 0.3046965897, green: 0.3007525206, blue: 0.8791586757, alpha: 1)))
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.cornerRadius = 20
        segmentView.addTarget(self,
                              action: #selector(changeRunningBlock),
                              for: .valueChanged)
        return segmentView
    }()
    
    //MARK: runningNormSliderView
    lazy var runningNormSliderView:Slider = {
        let slider = Slider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.attributedTextForFraction = { fraction in
            let formatter = NumberFormatter()
            formatter.maximumIntegerDigits = 3
            formatter.maximumFractionDigits = 0
            let string = formatter.string(from: (fraction * 500) as NSNumber) ?? ""
            return NSAttributedString(string: string)
        }
        slider.setMinimumLabelAttributedText(NSAttributedString(string: "0"))
        slider.setMaximumLabelAttributedText(NSAttributedString(string: "500"))
        slider.contentViewCornerRadius = 25
        slider.fraction = 0.5
        slider.shadowOffset = CGSize(width: 0, height: 10)
        slider.shadowBlur = 5
        slider.shadowColor = UIColor(white: 0, alpha: 0.1)
        slider.contentViewColor = UIColor(red: 78/255.0, green: 77/255.0, blue: 224/255.0, alpha: 1)
        slider.valueViewColor = .white
        slider.addTarget(self, action: #selector(changeNormSlider), for: .valueChanged)
        return slider
    }()
    
    lazy var runningTargetTimePicker:AGCircularPicker = {
        let circularPicker = AGCircularPicker()
        let hourColor1 = UIColor.rgb_color(r: 0, g: 237, b: 233)
        let hourColor2 = UIColor.rgb_color(r: 0, g: 135, b: 217)
        let hourColor3 = UIColor.rgb_color(r: 138, g: 28, b: 195)
        let hourTitleOption = AGCircularPickerTitleOption(title: "hours")
        let hourValueOption = AGCircularPickerValueOption(minValue: 0, maxValue: 23, rounds: 2, initialValue: 15)
        let hourColorOption = AGCircularPickerColorOption(gradientColors: [hourColor1, hourColor2, hourColor3], gradientAngle: 20)
        let hourOption = AGCircularPickerOption(valueOption: hourValueOption, titleOption: hourTitleOption, colorOption: hourColorOption)
        
        let minuteColor1 = UIColor.rgb_color(r: 255, g: 141, b: 0)
        let minuteColor2 = UIColor.rgb_color(r: 255, g: 0, b: 88)
        let minuteColor3 = UIColor.rgb_color(r: 146, g: 0, b: 132)
        let minuteColorOption = AGCircularPickerColorOption(gradientColors: [minuteColor1, minuteColor2, minuteColor3], gradientAngle: -20)
        let minuteTitleOption = AGCircularPickerTitleOption(title: "minutes")
        let minuteValueOption = AGCircularPickerValueOption(minValue: 0, maxValue: 59)
        let minuteOption = AGCircularPickerOption(valueOption: minuteValueOption, titleOption: minuteTitleOption, colorOption: minuteColorOption)
        
        let secondTitleOption = AGCircularPickerTitleOption(title: "seconds")
        let secondColorOption = AGCircularPickerColorOption(gradientColors: [hourColor3, hourColor2, hourColor1])
        let secondOption = AGCircularPickerOption(valueOption: minuteValueOption, titleOption: secondTitleOption, colorOption: secondColorOption)
        
        circularPicker.options = [hourOption, minuteOption, secondOption]
        return circularPicker
    }()
    //MARK: LABEL
    
    
    
    //MARK: runningNormLabel
    lazy var runningNormLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "N"
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.bounds = CGRect(x: 0.0, y: 0.0, width: 35, height: 35)
        label.layer.cornerRadius = 35 / 2
        label.layer.borderWidth = 3.0
        label.layer.backgroundColor = UIColor.clear.cgColor
        label.layer.borderColor = #colorLiteral(red: 0.3046965897, green: 0.3007525206, blue: 0.8791586757, alpha: 1)
        label.textAlignment = .center
        label.layer.shadowColor = UIColor.gray.cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 4, height: 4)
        label.layer.masksToBounds = false
        return label
    }()
    
    //MARK: runningStatisticsLabel
    lazy var runningStatisticsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "S"
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.bounds = CGRect(x: 0.0, y: 0.0, width: 35, height: 35)
        label.layer.cornerRadius = 35 / 2
        label.layer.borderWidth = 3.0
        label.layer.backgroundColor = UIColor.clear.cgColor
        label.layer.borderColor = #colorLiteral(red: 0.3046965897, green: 0.3007525206, blue: 0.8791586757, alpha: 1)
        label.textAlignment = .center
        label.layer.shadowColor = UIColor.gray.cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 4, height: 4)
        label.layer.masksToBounds = false
        return label
    }()
    
    lazy var runningMotivationLabel:MarqueeLabel = {
        let label = MarqueeLabel(frame: CGRect(), duration: 8.0, fadeLength: 10.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "When you’re riding, only the race in which you’re riding is important."
        label.font = label.font.withSize(20)
        return label
    }()
    
    lazy var runningAllStatisticsLabel:MarqueeLabel = {
         let label = MarqueeLabel(frame: CGRect(), duration: 8.0, fadeLength: 10.0)
         label.translatesAutoresizingMaskIntoConstraints = false
         label.text = "The only way to prove that you’re a good sport is to lose."
         label.font = label.font.withSize(20)
        label.textColor = #colorLiteral(red: 0.3046965897, green: 0.3007525206, blue: 0.8791586757, alpha: 1)
         return label
     }()
    //MARK: BUTTON
    
    
    
    //MARK: runningStartButton
    lazy var runningStartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = #colorLiteral(red: 0.883168757, green: 0.2952281535, blue: 0.2945016026, alpha: 1)
        button.backgroundColor = .white
        button.frame = CGRect(x: 0, y: 0 , width: 100, height: 100)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"flame.png"), for: .normal)
        button.layer.borderWidth = 2
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
        runningScrollView.addSubview(runningBlockSwitchView)

        runningParametersBlockView.addSubview(runningMotivationLabel)
        runningParametersBlockView.addSubview(runningNormSliderView)
        runningParametersBlockView.addSubview(runningNormLabel)
        runningParametersBlockView.addSubview(runningStatisticsLabel)
        runningParametersBlockView.addSubview(runningAllStatisticsLabel)
        
        runningScrollView.addSubview(runningStoreBlockView)
        runningScrollView.addSubview(runningTargetTimeBlockView)
        runningScrollView.addSubview(runningParametersBlockView)
        runningScrollView.addSubview(runningStartButton)
        
        createConstraintscreateRunningActivityBarChartView()
        createConstraintsRunningFormatForChartSwitchView()
        createConstraintsRunningBlockSwitchView()
        createConstraintsRunningParameterBlockView()
        createConstraintsRunningMotivationLabel()
        createConstraintsRunningNormLabel()
        createConstraintsRunningNormSliderView()
        createConstraintsRunningStatisticsLabel()
        createConstraintsRunningAllStatisticsLabel()
        createConstraintsRunningStoreBlockView()
        createConstraintsRunningTargetTimeBlockView()
        createConstraintsRunningStartButton()
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
    
    //MARK: changeRunningBlock
    @objc func changeRunningBlock(){
        if runningBlockSwitchView.index == 0 {
            runningParametersBlockView.isHidden = false
            runningStoreBlockView.isHidden = true
            runningTargetTimeBlockView.isHidden = true
        }
        if runningBlockSwitchView.index == 1 {
            runningParametersBlockView.isHidden = true
            runningStoreBlockView.isHidden = false
            runningTargetTimeBlockView.isHidden = true
        }
        if runningBlockSwitchView.index == 2 {
            runningParametersBlockView.isHidden = true
            runningStoreBlockView.isHidden = true
            runningTargetTimeBlockView.isHidden = false
        }
    }
    
    @objc func endChangeNormSlider(){
        if runningNormSliderView.isTracking == false {
            runningMotivationLabel.isHidden = false
        }
    }
    
    @objc func changeNormSlider(){
        runningMotivationLabel.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            self.endChangeNormSlider()
        })
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
        runningParametersBlockView.topAnchor.constraint(equalTo: runningBlockSwitchView.bottomAnchor, constant: 10).isActive = true
        runningParametersBlockView.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
        runningParametersBlockView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        runningParametersBlockView.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    //MARK: ConstraintsRunningStoreBlockView
    func createConstraintsRunningStoreBlockView() {
        runningStoreBlockView.topAnchor.constraint(equalTo: runningBlockSwitchView.bottomAnchor, constant: 10).isActive = true
        runningStoreBlockView.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
        runningStoreBlockView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        runningStoreBlockView.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    //MARK: createConstraintsRunningTargetTimeBlockView
    func createConstraintsRunningTargetTimeBlockView() {
        runningTargetTimeBlockView.topAnchor.constraint(equalTo: runningBlockSwitchView.bottomAnchor, constant: 10).isActive = true
        runningTargetTimeBlockView.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
        runningTargetTimeBlockView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        runningTargetTimeBlockView.heightAnchor.constraint(equalToConstant: 180).isActive = true
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
        runningFormatForChartSwitchView.topAnchor.constraint(equalTo: runningActivityChartView.bottomAnchor, constant: 10).isActive = true
        runningFormatForChartSwitchView.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
        runningFormatForChartSwitchView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        runningFormatForChartSwitchView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    //MARK: createConstraintsRunningBlockSwitchView
    func createConstraintsRunningBlockSwitchView() {
        runningBlockSwitchView.topAnchor.constraint(equalTo: runningFormatForChartSwitchView.bottomAnchor, constant: 10).isActive = true
        runningBlockSwitchView.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
        runningBlockSwitchView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        runningBlockSwitchView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    //MARK: ConstraintsRunningNormSliderView
    func createConstraintsRunningNormSliderView() {
        runningNormSliderView.topAnchor.constraint(equalTo: runningMotivationLabel.bottomAnchor, constant: 10).isActive = true
        runningNormSliderView.trailingAnchor.constraint(equalTo: runningParametersBlockView.trailingAnchor,constant: -10).isActive = true
        runningNormSliderView.widthAnchor.constraint(equalToConstant: 230).isActive = true
        runningNormSliderView.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    //MARK: CONSTRAINTS LABEL
    
    
    
    //MARK: ConstraintsRunningNormLabel
    func createConstraintsRunningNormLabel() {
        runningNormLabel.centerYAnchor.constraint(equalTo: runningNormSliderView.centerYAnchor).isActive = true
        runningNormLabel.trailingAnchor.constraint(equalTo: runningNormSliderView.leadingAnchor, constant: -10).isActive = true
        runningNormLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        runningNormLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    //MARK: createConstraintsRunningStatisticsLabel
     func createConstraintsRunningStatisticsLabel() {
         runningStatisticsLabel.centerYAnchor.constraint(equalTo: runningAllStatisticsLabel.centerYAnchor).isActive = true
         runningStatisticsLabel.trailingAnchor.constraint(equalTo: runningAllStatisticsLabel.leadingAnchor, constant: -20).isActive = true
         runningStatisticsLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
         runningStatisticsLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true
     }
    
    //MARK: createConstraintsRunningMotivationLabel
    func createConstraintsRunningMotivationLabel() {
        runningMotivationLabel.topAnchor.constraint(equalTo: runningParametersBlockView.topAnchor, constant: 10).isActive = true
        runningMotivationLabel.centerXAnchor.constraint(equalTo: runningParametersBlockView.centerXAnchor).isActive = true
        runningMotivationLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        runningMotivationLabel.widthAnchor.constraint(equalToConstant: 260).isActive = true
    }
    
    //MARK: createConstraintsRunningAllStatisticsLabel
    func createConstraintsRunningAllStatisticsLabel() {
        runningAllStatisticsLabel.topAnchor.constraint(equalTo: runningNormSliderView.bottomAnchor, constant: 10).isActive = true
        runningAllStatisticsLabel.trailingAnchor.constraint(equalTo: runningParametersBlockView.trailingAnchor,constant: -20).isActive = true
        runningAllStatisticsLabel.widthAnchor.constraint(equalToConstant: 210).isActive = true
        runningAllStatisticsLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    //MARK:CONSTRAINTS BUTTON
    

    
    //MARK: ConstraintsRunningStartButton
    func createConstraintsRunningStartButton() {
        runningStartButton.topAnchor.constraint(equalTo: runningParametersBlockView.bottomAnchor, constant: 20).isActive = true
        runningStartButton.centerXAnchor.constraint(equalTo: runningScrollView.centerXAnchor).isActive = true
        runningStartButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        runningStartButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
}

extension RunningViewController:AGCircularPickerDelegate {
    func didChangeValues(_ values: Array<AGColorValue>, selectedIndex: Int) {
        let valueComponents = values.map { return String(format: "%02d", $0.value) }
        let fullString = valueComponents.joined(separator: ":")
        let attributedString = NSMutableAttributedString(string:fullString)
        let fullRange = (fullString as NSString).range(of: fullString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white.withAlphaComponent(0.5), range: fullRange)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.bold), range: fullRange)
        
        let range = NSMakeRange(selectedIndex * 2 + selectedIndex, 2)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: values[selectedIndex].color, range: range)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.black), range: range)
        
        //.attributedText = attributedString
    }
    
    
}
