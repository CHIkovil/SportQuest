//
//  RunViewController.swift
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
import CoreData
import  Foundation


class RunViewController: UIViewController, TabItem {
    //MARK: let, var
    
    let daysWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var runTimeStore: [String] = []
    var runDistanceStore: [String] = []
    var runDateStore: [String] = []
    var runCoordinatesStore: [[String]] = []
    var isWeek = true
    var weekStoreForCharts: [Double] = []
    var monthStoreForCharts: [Double] = []
    var runStoreForTable: [String] = []
    //MARK: VIEW
    
    //MARK: runStoreTableView
    lazy var runStoreTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.borderWidth = 2
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.layer.cornerRadius = 30
        tableView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(swipingRunStoreTableView)))
        return tableView
    }()

    
    
    //MARK: runScrollView
    lazy var runScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize.height = 850
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(swipingRunScrollView)))
        return scrollView
    }()
    
    //MARK: runningParametersBlockView
    lazy var runParametersBlockView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 30
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return view
    }()
    
    //MARK: runningTargetTimeBlockView
    lazy var runTargetTimeBlockView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 30
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        return view
    }()
    
    //MARK: runningActivityChartView
    lazy var runActivityChartView: CombinedChartView = {
        let chart = CombinedChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.backgroundColor = .lightGray
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.chartDescription?.enabled = false
        chart.highlightFullBarEnabled = false
        chart.xAxis.labelPosition = .bothSided
        chart.xAxis.axisMinimum = 0
        chart.xAxis.granularity = 1
        chart.xAxis.valueFormatter = self
        return chart
    }()
    
    //MARK: formatForChartSwitchView
    lazy var runFormatForChartSwitchView: BetterSegmentedControl = {
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
    lazy var runBlockSwitchView: BetterSegmentedControl = {
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
    lazy var runNormSliderView:Slider = {
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
    
    //MARK: runningTargetTimeView
    lazy var runTargetTimeView:AGCircularPicker = {
        let circularPicker = AGCircularPicker()
        let hourColor1 = UIColor.rgb_color(r: 0, g: 237, b: 233)
        let hourColor2 = UIColor.rgb_color(r: 0, g: 135, b: 217)
        let hourColor3 = UIColor.rgb_color(r: 138, g: 28, b: 195)
        let hourTitleOption = AGCircularPickerTitleOption(title: "Hor")
        let hourValueOption = AGCircularPickerValueOption(minValue: 0, maxValue: 23, rounds: 2, initialValue: 0)
        let hourColorOption = AGCircularPickerColorOption(gradientColors: [hourColor1, hourColor2, hourColor3], gradientAngle: 20)
        let hourOption = AGCircularPickerOption(valueOption: hourValueOption, titleOption: hourTitleOption, colorOption: hourColorOption)
        
        let minuteColor1 = UIColor.rgb_color(r: 255, g: 141, b: 0)
        let minuteColor2 = UIColor.rgb_color(r: 255, g: 0, b: 88)
        let minuteColor3 = UIColor.rgb_color(r: 146, g: 0, b: 132)
        let minuteColorOption = AGCircularPickerColorOption(gradientColors: [minuteColor1, minuteColor2, minuteColor3], gradientAngle: -20)
        let minuteTitleOption = AGCircularPickerTitleOption(title: "Min")
        let minuteValueOption = AGCircularPickerValueOption(minValue: 0, maxValue: 59)
        let minuteOption = AGCircularPickerOption(valueOption: minuteValueOption, titleOption: minuteTitleOption, colorOption: minuteColorOption)
        
        let secondTitleOption = AGCircularPickerTitleOption(title: "Sec")
        let secondColorOption = AGCircularPickerColorOption(gradientColors: [hourColor3, hourColor2, hourColor1])
        let secondOption = AGCircularPickerOption(valueOption: minuteValueOption, titleOption: secondTitleOption, colorOption: secondColorOption)
        
        circularPicker.options = [hourOption, minuteOption, secondOption]
        circularPicker.translatesAutoresizingMaskIntoConstraints = false
        circularPicker.delegate = self
        circularPicker.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressRunStoreTableView)))
        return circularPicker
    }()
    
    //MARK: LABEL
    
    
    
    //MARK: runningNormLabel
    lazy var runNormLabel: UILabel = {
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
    lazy var runStatisticsLabel: UILabel = {
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
    
    //MARK: runningMotivationLabel
    lazy var runMotivationLabel:MarqueeLabel = {
        let label = MarqueeLabel(frame: CGRect(), duration: 8.0, fadeLength: 10.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "When you’re riding, only the race in which you’re riding is important."
        label.font = label.font.withSize(20)
        return label
    }()
    
    //MARK: runningAllStatisticsLabel
    lazy var runAllStatisticsLabel:MarqueeLabel = {
         let label = MarqueeLabel(frame: CGRect(), duration: 8.0, fadeLength: 10.0)
         label.translatesAutoresizingMaskIntoConstraints = false
         label.text = "The only way to prove that you’re a good sport is to lose."
         label.font = label.font.withSize(20)
        label.textColor = #colorLiteral(red: 0.3046965897, green: 0.3007525206, blue: 0.8791586757, alpha: 1)
         return label
     }()
    
     //MARK: runningTargetTimeLabel
    lazy var runTargetTimeLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    //MARK: BUTTON
    
    
    
    //MARK: runningStartButton
    lazy var runStartButton: UIButton = {
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
        button.addTarget(self, action: #selector(showRunningProcess), for: .touchUpInside)
        return button
    }()
    
    //MARK: Image for AMTabsView
    var tabImage: UIImage? {
        return UIImage(named: "running.png")
    }
    
    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRunStore()
        parseRunStore()
        view.backgroundColor = .lightGray
        
        view.addSubview(runScrollView)
        createConstraintsRunningScrollView()
        
        runScrollView.addSubview(runActivityChartView)
        runScrollView.addSubview(runFormatForChartSwitchView)
        runScrollView.addSubview(runBlockSwitchView)
        runScrollView.addSubview(runParametersBlockView)
        runParametersBlockView.addSubview(runMotivationLabel)
        runParametersBlockView.addSubview(runNormSliderView)
        runParametersBlockView.addSubview(runNormLabel)
        runParametersBlockView.addSubview(runStatisticsLabel)
        runParametersBlockView.addSubview(runAllStatisticsLabel)
        
        runScrollView.addSubview(runStoreTableView)
        runScrollView.addSubview(runTargetTimeBlockView)
        
        runTargetTimeBlockView.addSubview(runTargetTimeLabel)
        runTargetTimeBlockView.addSubview(runTargetTimeView)
        

        runScrollView.addSubview(runStartButton)
        
        createConstraintscreateRunActivityBarChartView()
        createConstraintsRunFormatForChartSwitchView()
        createConstraintsRunBlockSwitchView()
        createConstraintsRunParameterBlockView()
        createConstraintsRunMotivationLabel()
        createConstraintsRunNormLabel()
        createConstraintsRunNormSliderView()
        createConstraintsRunStatisticsLabel()
        createConstraintsRunAllStatisticsLabel()
        createConstraintsRunStoreTableView()
        createConstraintsRunTargetTimeBlockView()
        createConstraintsRunTargetTimeLabel()
        createConstraintsRunTargetTimeView()
        createConstraintsRunStartButton()

        runParametersBlockView.isHidden = false
        runStoreTableView.isHidden = true
        runTargetTimeBlockView.isHidden = true
        
    }
    
    //MARK: viewDidAppear
     override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    //MARK: STUFF
    func setWeekDataForRunningActivityBarChartView() {
        let data = CombinedChartData()
        data.lineData = generateLineData()
        data.barData = generateBarData()
        
        runActivityChartView.xAxis.axisMaximum = data.xMax + 0.45
        runActivityChartView.xAxis.axisMinimum = data.xMin - 0.45
        runActivityChartView.data = data
    }
    
    
    func setMonthDataRunningActivityBarChartView() {
        let data = CombinedChartData()
        data.lineData = generateLineData()
        data.barData = generateBarData()
        
        runActivityChartView.xAxis.axisMaximum = data.xMax + 0.45
        runActivityChartView.xAxis.axisMinimum = data.xMin - 0.45
        runActivityChartView.data = data
    }
    
    func generateLineData() -> LineChartData {
        let entries = (0..<7).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: Double(arc4random_uniform(15) + 5))
        }
        
        let set = LineChartDataSet(entries: entries, label: "Percentage of completion")
        set.setColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        set.lineWidth = 2.5
        set.setCircleColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        set.circleRadius = 5
        set.circleHoleRadius = 2.5
        set.fillColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        set.mode = .cubicBezier
        set.drawValuesEnabled = true
        set.valueFont = .systemFont(ofSize: 13)
        set.valueTextColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        
        set.axisDependency = .left
        
        return LineChartData(dataSet: set)
    }
    
    func generateBarData() -> BarChartData {
        let entries = (0..<7).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), yValues: [Double(arc4random_uniform(13) + 12), Double(arc4random_uniform(13) + 12)])
        }

        
        let set = BarChartDataSet(entries: entries, label: "")
        set.stackLabels = ["Result", "Not performed"]
        set.colors = [UIColor(red: 61/255, green: 165/255, blue: 255/255, alpha: 1),
                       UIColor(red: 23/255, green: 197/255, blue: 255/255, alpha: 1)
        ]
        set.valueTextColor = .white
        set.valueFont = .systemFont(ofSize: 13)
        set.axisDependency = .left
        
        let data =  BarChartData()
        data.dataSets = [set]
        data.barWidth = 0.9
        
        return data
    }

    //MARK: FUNC
    
    
    
    //MARK: loadRunStore
    func loadRunStore() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RunData")
        request.returnsObjectsAsFaults = false
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                runCoordinatesStore.append(data.value(forKey: "coordinates") as! [String])
                runTimeStore.append(data.value(forKey: "time") as! String)
                runDistanceStore.append(data.value(forKey: "distance") as! String)
                runDateStore.append(data.value(forKey: "date") as! String)
            }
        } catch {
            print("Failed")
        }
    }
    
    //MARK: parseRunStore
    func  parseRunStore() {
//        if runStore.isEmpty == false{
//            var runTimeStore: [String] = []
//            var runDistanceStore: [String] = []
//            var runDateStore: [String] = []
//            var runCoordinatesStore: [[String]] = []
//
//            for data in runStore {
//                let masData = data.split(separator: ",").map {String($0)}
//                let coordinates = Array<String>(masData[0 ..< masData.count - 3])
//                let otherData = Array<String>(masData[masData.count - 3 ..< masData.count])
//                let time = otherData[0]
//                let distance = otherData[1]
//                let date = otherData[2]
//                runTimeStore.append(time)
//                runDistanceStore.append(distance)
//                runDateStore.append(date)
//                runCoordinatesStore.append(coordinates)
//            }
            
            
            let datesCurrentWeek = getAllDaysOfTheCurrentWeek()
            
//            for date in datesCurrentWeek  {
//                if runDateStore.contains(String(date.timeIntervalSinceReferenceDate)) {
//                    let allIndexRunStoreInCurrentDate = runDateStore.enumerated().filter({ String(date.timeIntervalSinceReferenceDate) == $0.element }).map({ $0.offset })
//                    let result = runDistanceStore.enumerated().filter({allIndexRunStoreInCurrentDate.contains($0.offset)}).map({ Int($0.element)! }).reduce(0, +)
//
//                    weekStoreForCharts.append(Double(result))
//                }
//                else {
//                    return weekStoreForCharts.append(0)
//                }
//            }

            let datesCurrentMonth = getAllDaysOfTheCurrentMonth()
        
    }
    
    
    //MARK: getAllDaysOfTheCurrentWeek
    func getAllDaysOfTheCurrentWeek() -> [Date] {
        var dates: [Date] = []
        guard let dateInterval = Calendar.current.dateInterval(of: .weekOfYear,
                                                               for: Date()) else {
            return dates
        }
        
        Calendar.current.enumerateDates(startingAfter: dateInterval.start,
                                        matching: DateComponents(hour:0),
                                        matchingPolicy: .nextTime) { date, _, stop in
                guard let date = date else {
                    return
                }
                if date <= dateInterval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
        }
        
        return dates
    }
    
    //MARK: getAllDaysOfTheCurrentMonth
    func getAllDaysOfTheCurrentMonth() -> [Date] {
         var dates: [Date] = []
        guard let dateInterval = Calendar.current.dateInterval(of: .month,
                                                                for: Date()) else {
             return dates
         }
         
         Calendar.current.enumerateDates(startingAfter: dateInterval.start,
                                         matching: DateComponents(hour:0),
                                         matchingPolicy: .nextTime) { date, _, stop in
                 guard let date = date else {
                     return
                 }
                 if date <= dateInterval.end {
                     dates.append(date)
                 } else {
                     stop = true
                 }
         }
         
         return dates
     }
    //MARK: @OBJC
    
    
    //MARK: longPressRunStoreTableView
    @objc func longPressRunStoreTableView() {
        if runScrollView.isScrollEnabled == true {
            runScrollView.isScrollEnabled = false
        }
    }
    //MARK: swipingRunStoreTableView
    @objc func swipingRunStoreTableView() {
        runStoreTableView.isScrollEnabled = true
        runScrollView.isScrollEnabled = false
    }
    
    //MARK: swipingRunScrollView
    @objc func swipingRunScrollView() {
        runStoreTableView.isScrollEnabled = false
        runScrollView.isScrollEnabled = true
    }
    
    //MARK: changeRunningActivityChart
    @objc func changeRunningActivityChart(){
        if runFormatForChartSwitchView.index == 0 {
            setWeekDataForRunningActivityBarChartView()
        }else{
            setMonthDataRunningActivityBarChartView()
        }
    }
    
    //MARK: changeRunningBlock
    @objc func changeRunningBlock(){
        if runBlockSwitchView.index == 0 {
            runParametersBlockView.isHidden = false
            runStoreTableView.isHidden = true
            runTargetTimeBlockView.isHidden = true
        }
        if runBlockSwitchView.index == 1 {
            runParametersBlockView.isHidden = true
            runStoreTableView.isHidden = false
            runTargetTimeBlockView.isHidden = true
        }
        if runBlockSwitchView.index == 2 {
            runParametersBlockView.isHidden = true
            runStoreTableView.isHidden = true
            runTargetTimeBlockView.isHidden = false
        }
    }
     //MARK: endChangeNormSlider
    @objc func endChangeNormSlider(){
        if runNormSliderView.isTracking == false {
            runMotivationLabel.isHidden = false
        }
    }
     //MARK: changeNormSlider
    @objc func changeNormSlider(){
        runMotivationLabel.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            self.endChangeNormSlider()
        })
    }

     //MARK: showRunningProcess
    @objc func showRunningProcess(){
        let viewController = RunProcessViewController()
        
        self.present(viewController, animated: true)
    }

    //MARK: CONSTRAINTS VIEW
    
    
    
    //MARK: ConstraintsRunningScrollView
    func createConstraintsRunningScrollView() {
        runScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        runScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        runScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        runScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    //MARK: ConstraintsRunningParameterBlockView
    func createConstraintsRunParameterBlockView() {
        runParametersBlockView.topAnchor.constraint(equalTo: runBlockSwitchView.bottomAnchor, constant: 10).isActive = true
        runParametersBlockView.centerXAnchor.constraint(equalTo: runScrollView.centerXAnchor).isActive = true
        runParametersBlockView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        runParametersBlockView.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    //MARK: ConstraintsRunningStoreBlockView
    func createConstraintsRunStoreTableView() {
        runStoreTableView.topAnchor.constraint(equalTo: runBlockSwitchView.bottomAnchor, constant: 10).isActive = true
        runStoreTableView.centerXAnchor.constraint(equalTo: runScrollView.centerXAnchor).isActive = true
        runStoreTableView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        runStoreTableView.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    //MARK: createConstraintsRunningTargetTimeBlockView
    func createConstraintsRunTargetTimeBlockView() {
        runTargetTimeBlockView.topAnchor.constraint(equalTo: runBlockSwitchView.bottomAnchor, constant: 10).isActive = true
        runTargetTimeBlockView.centerXAnchor.constraint(equalTo: runScrollView.centerXAnchor).isActive = true
        runTargetTimeBlockView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        runTargetTimeBlockView.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    //MARK: ConstraintsRunningActivityChartView
    func createConstraintscreateRunActivityBarChartView() {
        runActivityChartView.topAnchor.constraint(equalTo: runScrollView.topAnchor, constant: 50).isActive = true
        runActivityChartView.centerXAnchor.constraint(equalTo: runScrollView.centerXAnchor).isActive = true
        runActivityChartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        runActivityChartView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    //MARK: ConstraintsRunningFormatForChartSwitchView
    func createConstraintsRunFormatForChartSwitchView() {
        runFormatForChartSwitchView.topAnchor.constraint(equalTo: runActivityChartView.bottomAnchor, constant: 10).isActive = true
        runFormatForChartSwitchView.centerXAnchor.constraint(equalTo: runScrollView.centerXAnchor).isActive = true
        runFormatForChartSwitchView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        runFormatForChartSwitchView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    //MARK: createConstraintsRunningBlockSwitchView
    func createConstraintsRunBlockSwitchView() {
        runBlockSwitchView.topAnchor.constraint(equalTo: runFormatForChartSwitchView.bottomAnchor, constant: 10).isActive = true
        runBlockSwitchView.centerXAnchor.constraint(equalTo: runScrollView.centerXAnchor).isActive = true
        runBlockSwitchView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        runBlockSwitchView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    //MARK: ConstraintsRunningNormSliderView
    func createConstraintsRunNormSliderView() {
        runNormSliderView.topAnchor.constraint(equalTo: runMotivationLabel.bottomAnchor, constant: 10).isActive = true
        runNormSliderView.trailingAnchor.constraint(equalTo: runParametersBlockView.trailingAnchor,constant: -10).isActive = true
        runNormSliderView.widthAnchor.constraint(equalToConstant: 230).isActive = true
        runNormSliderView.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    //MARK: createConstraintsRunningRunningTargetTimeView
    func createConstraintsRunTargetTimeView() {
        runTargetTimeView.topAnchor.constraint(equalTo: runTargetTimeLabel.bottomAnchor, constant: -10).isActive = true
        runTargetTimeView.centerXAnchor.constraint(equalTo: runTargetTimeBlockView.centerXAnchor).isActive = true
        runTargetTimeView.widthAnchor.constraint(equalToConstant: 280).isActive = true
        runTargetTimeView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
 
    
    //MARK: CONSTRAINTS LABEL
    
    
    
    //MARK: ConstraintsRunningNormLabel
    func createConstraintsRunNormLabel() {
        runNormLabel.centerYAnchor.constraint(equalTo: runNormSliderView.centerYAnchor).isActive = true
        runNormLabel.trailingAnchor.constraint(equalTo: runNormSliderView.leadingAnchor, constant: -10).isActive = true
        runNormLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        runNormLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    //MARK: createConstraintsRunningStatisticsLabel
     func createConstraintsRunStatisticsLabel() {
         runStatisticsLabel.centerYAnchor.constraint(equalTo: runAllStatisticsLabel.centerYAnchor).isActive = true
         runStatisticsLabel.trailingAnchor.constraint(equalTo: runAllStatisticsLabel.leadingAnchor, constant: -20).isActive = true
         runStatisticsLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
         runStatisticsLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true
     }
    
    //MARK: createConstraintsRunningMotivationLabel
    func createConstraintsRunMotivationLabel() {
        runMotivationLabel.topAnchor.constraint(equalTo: runParametersBlockView.topAnchor, constant: 10).isActive = true
        runMotivationLabel.centerXAnchor.constraint(equalTo: runParametersBlockView.centerXAnchor).isActive = true
        runMotivationLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        runMotivationLabel.widthAnchor.constraint(equalToConstant: 260).isActive = true
    }
    
    //MARK: createConstraintsRunningAllStatisticsLabel
    func createConstraintsRunAllStatisticsLabel() {
        runAllStatisticsLabel.topAnchor.constraint(equalTo: runNormSliderView.bottomAnchor, constant: 10).isActive = true
        runAllStatisticsLabel.trailingAnchor.constraint(equalTo: runParametersBlockView.trailingAnchor,constant: -20).isActive = true
        runAllStatisticsLabel.widthAnchor.constraint(equalToConstant: 210).isActive = true
        runAllStatisticsLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    //MARK: createConstraintsRunningTargetTimeLabel
    func createConstraintsRunTargetTimeLabel() {
        runTargetTimeLabel.topAnchor.constraint(equalTo: runTargetTimeBlockView.topAnchor, constant: 20).isActive = true
        runTargetTimeLabel.centerXAnchor.constraint(equalTo: runTargetTimeBlockView.centerXAnchor).isActive = true
        runTargetTimeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        runTargetTimeLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    //MARK:CONSTRAINTS BUTTON
    

    
    //MARK: ConstraintsRunningStartButton
    func createConstraintsRunStartButton() {
        runStartButton.topAnchor.constraint(equalTo: runParametersBlockView.bottomAnchor, constant: 10).isActive = true
        runStartButton.centerXAnchor.constraint(equalTo: runScrollView.centerXAnchor).isActive = true
        runStartButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        runStartButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
}

//MARK: extension
extension RunViewController: AGCircularPickerDelegate {
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
        
        runTargetTimeLabel.attributedText = attributedString

    }
    
}


extension RunViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if runDistanceStore.isEmpty == false{
            return runDistanceStore.count
        }
        else{
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        
        if runDistanceStore.isEmpty == false{
            cell.textLabel?.text = runDistanceStore[indexPath.row]
            cell.textLabel?.textColor = .black
            return cell
        }else{
            cell.textLabel?.text = "1111"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RunViewController: IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if isWeek == true {
            return daysWeek[Int(value) % daysWeek.count]
        }
        else{
            return String(value)
        }
    }
}


