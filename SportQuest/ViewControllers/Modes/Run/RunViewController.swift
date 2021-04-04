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
import MarqueeLabel
import AGCircularPicker
import CoreData
import Foundation
import MapKit


class RunViewController: UIViewController, TabItem {
    
    //MARK: let, var
    let daysWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var runTimeStore: [Int]?
    var runDistanceStore: [Int]?
    var runDateStore: [String]?
    var runCoordinateStore: [String]?
    var runRegionImageStore: [Data]?
    
    var weekDataForChart: [Double]?
    var monthDataForChart: [Double]?
    var showValueCharts: Bool = false
    
    var tableStore: [NSMutableAttributedString]?
    //MARK: VIEW
    
    //MARK: scrollView
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize.height = 950
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(swipingScrollView)))
        return scrollView
    }()
    
    //MARK: runStoreTableView
    lazy var runStoreTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .lightGray
        tableView.rowHeight = 58
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = .clear
        tableView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(swipingRunStoreTableView)))
        return tableView
    }()
    
    //MARK: runTargetTimeBlockView
    lazy var runTargetTimeBlockView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 30
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.isHidden = false
        return view
    }()
    
    //MARK: runStoreBlockView
    lazy var runStoreBlockView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.isHidden = true
        return view
    }()
    
    //MARK: runActivityChartView
    lazy var runActivityChartView: CombinedChartView = {
        let chart = CombinedChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.backgroundColor = .lightGray
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.chartDescription?.enabled = false
        chart.highlightFullBarEnabled = false
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.valueFormatter = self
        chart.noDataText = "Not data"
        chart.noDataFont = UIFont(name: "TrebuchetMS", size: 18)!
        chart.noDataTextColor = .white
        return chart
    }()
    
    //MARK: formatForChartSwitchView
    lazy var formatForChartSwitchView: BetterSegmentedControl = {
        let segmentView = BetterSegmentedControl(frame: CGRect(), segments: LabelSegment.segments(withTitles:["Week","Month"], normalTextColor: .lightGray,
                                                                                                  selectedTextColor: #colorLiteral(red: 0.3046965897, green: 0.3007525206, blue: 0.8791586757, alpha: 1)))
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.cornerRadius = 20
        segmentView.addTarget(self,
                              action: #selector(changeRunActivityChart),
                              for: .valueChanged)
        return segmentView
    }()
    
    //MARK: blockSwitchView
    lazy var targetBlockSwitchView: BetterSegmentedControl = {
        let segmentView = BetterSegmentedControl(frame: CGRect(), segments: IconSegment.segments(withIcons: [UIImage(named: "target.png")!, UIImage(named: "cloud-computing.png")!],
                                                                                                 iconSize: CGSize(width: 30, height: 30),
                                                                                                 normalIconTintColor: .lightGray,
                                                                                                 selectedIconTintColor: #colorLiteral(red: 0.3046965897, green: 0.3007525206, blue: 0.8791586757, alpha: 1)))
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.cornerRadius = 20
        segmentView.addTarget(self,
                              action: #selector(changeTargetBlock),
                              for: .valueChanged)
        return segmentView
    }()
    
    //MARK: PICKER
    
    
    
    //MARK: runTargetTimePicker
    lazy var runTargetTimePicker:AGCircularPicker = {
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
        return circularPicker
    }()
    
    //MARK: LABEL
    
    //MARK: motivationLabel
    lazy var motivationLabel:MarqueeLabel = {
        let text = "When you’re riding, only the race in which you’re riding is important."
        let label = MarqueeLabel(frame: CGRect(), duration: 8.0, fadeLength: CGFloat(text.count))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = label.font.withSize(20)
        return label
    }()
    
    //MARK: runningStatisticsLabel
    lazy var runStatisticsLabel:MarqueeLabel = {
        let text = "The only way to prove that you’re a good sport is to lose."
        let label = MarqueeLabel(frame: CGRect(), duration: 8.0, fadeLength: CGFloat(text.count))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = label.font.withSize(20)
        label.textColor = #colorLiteral(red: 0.3046965897, green: 0.3007525206, blue: 0.8791586757, alpha: 1)
        return label
    }()
    
    //MARK: runTargetTimeLabel
    lazy var runTargetTimeLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    //MARK: BUTTON
    
    
    //MARK: showValueChartButton
    lazy var showValueChartsButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("value", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.isHidden = true
        button.addTarget(self, action: #selector(showValueForChart), for: .touchUpInside)
        return button
    }()
    
    //MARK: runStartButton
    lazy var runStartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = #colorLiteral(red: 0.883168757, green: 0.2952281535, blue: 0.2945016026, alpha: 1)
        button.backgroundColor = .white
        button.frame = CGRect(x: 0, y: 0 , width: 110, height: 110)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"flame.png"), for: .normal)
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(showRunProcess), for: .touchUpInside)
        return button
    }()
    
    //MARK: Image for AMTabsView
    public var tabImage: UIImage? {
        return UIImage(named: "running.png")
    }
    
    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        view.addSubview(scrollView)
        scrollView.addSubview(runActivityChartView)
        scrollView.addSubview(runStatisticsLabel)
        scrollView.addSubview(motivationLabel)
        scrollView.addSubview(showValueChartsButton)
        scrollView.addSubview(formatForChartSwitchView)
        scrollView.addSubview(targetBlockSwitchView)
        
        
        scrollView.addSubview(runTargetTimeBlockView)
        runTargetTimeBlockView.addSubview(runTargetTimeLabel)
        runTargetTimeBlockView.addSubview(runTargetTimePicker)
        
        scrollView.addSubview(runStoreBlockView)
        runStoreBlockView.addSubview(runStoreTableView)
        
        
        scrollView.addSubview(runStartButton)
        
        
        createConstraintsScrollView()
        
        createConstraintsRunActivityChartView()
        createConstraintsFormatForChartSwitchView()
        createConstraintsTargetBlockSwitchView()
        createConstraintsMotivationLabel()
        createConstraintsRunStatisticsLabel()
        createConstraintsShowValueChartsButton()
        
        createConstraintsRunStoreBlockView()
        createConstraintsRunStoreTableView()
        
        createConstraintsRunTargetTimeBlockView()
        createConstraintsRunTargetTimeLabel()
        createConstraintsRunTargetTimeView()
        createConstraintsRunStartButton()
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadRunStore()
        parseActivityChartStore()
        parseTableStore()
        setWeekData()
    }
    
    //MARK: FUNC
    
    
    
    //MARK: loadRunStore
    func loadRunStore() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RunData")
        request.returnsObjectsAsFaults = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        var coordinateStore:[String] = []
        var timeStore:[Int] = []
        var distanceStore: [Int] = []
        var dateStore: [String] = []
        var regionImageStore: [Data] = []
        
        do {
            let result = try context.fetch(request)
            
            if result.count == 0 {
                showValueChartsButton.isHidden = true
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            let intervalCurrentMonth = Calendar.current.dateInterval(of: .month, for: Date())
            
            for data in result as! [NSManagedObject] {
                let time = data.value(forKey: "time") as! Int
                let distance = data.value(forKey: "distance") as! Int
                let date = data.value(forKey: "date") as! String
                let coordinate = data.value(forKey: "coordinates") as! String
                let regionImage = data.value(forKey: "regionImage") as! Data
                
                if intervalCurrentMonth!.contains(dateFormatter.date(from: date)!) {
                    timeStore.append(time)
                    distanceStore.append(distance)
                    dateStore.append(date)
                    coordinateStore.append(coordinate)
                    regionImageStore.append(regionImage)
                }else{
                    context.delete(data)
                }
            }
            
        } catch {
            showValueChartsButton.isHidden = true
            return
        }
        
        runTimeStore = timeStore.reversed()
        runDistanceStore = distanceStore.reversed()
        runCoordinateStore = coordinateStore.reversed()
        runDateStore = dateStore.reversed()
        runRegionImageStore = regionImageStore.reversed()
        
        do {
            try context.save()
        }
        catch{
            return
        }
    }
    
    //MARK: parseActivityChartStore
    func parseActivityChartStore() {
        guard let dateStore = runDateStore else {return}
        var weekDataForChart: [Double] = []
        var monthDataForChart: [Double] = []
        
        let datesCurrentWeek = getAllDaysWeekOrMonth(dateInterval: Calendar.current.dateInterval(of: .weekOfMonth,for: Date())!)
        let datesCurrentMonth = getAllDaysWeekOrMonth(dateInterval: Calendar.current.dateInterval(of: .month,for: Date())!)
        
        for date in datesCurrentWeek {
            if dateStore.contains(date) {
                let result = runDistanceStore!.enumerated().filter({dateStore[$0.offset] == date}).map({$0.element}).reduce(0, +)
                weekDataForChart.append(Double(result))
            } else {
                weekDataForChart.append(0)
            }
        }
        
        for date in datesCurrentMonth {
            if dateStore.contains(date) {
                let result = runDistanceStore!.enumerated().filter({dateStore[$0.offset] == date}).map({$0.element}).reduce(0, +)
                monthDataForChart.append(Double(result))
            } else {
                monthDataForChart.append(0)
            }
        }
        
        self.weekDataForChart = weekDataForChart
        self.monthDataForChart = monthDataForChart
        showValueChartsButton.isHidden = false
    }
    
    //MARK: parseTableStore
    func parseTableStore() {
        guard let dateStore = runDateStore else {return}
        
        var tableStore: [NSMutableAttributedString] = []
        for index in 0..<dateStore.count {
            let distance = String(runDistanceStore![index])
            let time = String(runTimeStore![index])
            let data = distance + " " + time + " " + dateStore[index]
            let mutableString = NSMutableAttributedString.init(string: data)
            mutableString.setAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3046965897, green: 0.3007525206, blue: 0.8791586757, alpha: 1)], range: (mutableString.string as NSString).range(of: distance))
            mutableString.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], range: (mutableString.string as NSString).range(of: time))
            mutableString.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.lightGray], range: (mutableString.string as NSString).range(of: dateStore[index]))
            tableStore.append(mutableString)
            
        }
        self.tableStore = tableStore
        runStoreTableView.reloadData()
    }
    
    //MARK: setWeekData
    func setWeekData() {
        guard let weekData = weekDataForChart else {return}
        
        let data = CombinedChartData()
        
        data.lineData = getLineData(dataForCharts: weekData)
        data.barData = getBarData(dataForCharts: weekData)
        
        runActivityChartView.xAxis.granularity = 1
        runActivityChartView.xAxis.axisMaximum = data.xMax + 0.45
        runActivityChartView.xAxis.axisMinimum = data.xMin - 0.45
        
        runActivityChartView.data = data
    }
    
    //MARK: setMonthData
    func setMonthData() {
        guard let monthData = monthDataForChart else {return}
        let data = CombinedChartData()
        
        data.lineData = getLineData(dataForCharts: monthData)
        data.barData = getBarData(dataForCharts: monthData)
        
        runActivityChartView.xAxis.granularity = 1
        runActivityChartView.xAxis.axisMaximum = data.xMax + 0.45
        runActivityChartView.xAxis.axisMinimum = data.xMin - 0.45
        
        runActivityChartView.data = data
    }
    
    //MARK: getLineData
    func getLineData(dataForCharts:[Double]) -> LineChartData {
        let entries: [ChartDataEntry];
        if formatForChartSwitchView.index == 0{
            entries = (0..<7).map { (i) -> ChartDataEntry in
                return ChartDataEntry(x: Double(i), y: Double(arc4random_uniform(15) + 5))
            }
        }else {
            entries = (0..<dataForCharts.count).map { (i) -> ChartDataEntry in
                return ChartDataEntry(x: Double(i), y: Double(arc4random_uniform(15) + 5))
            }
        }
        
        let set = LineChartDataSet(entries: entries, label: "Percentage of completion")
        set.setColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        set.lineWidth = 2.5
        set.setCircleColor(UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1))
        set.circleRadius = 5
        set.circleHoleRadius = 2.5
        set.fillColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        set.mode = .cubicBezier
        if formatForChartSwitchView.index == 0 {
            set.valueFont = .systemFont(ofSize: 13)
        } else {
            set.valueFont = .systemFont(ofSize: 9)
        }
        if showValueCharts == true {
            set.drawValuesEnabled = true
        }else {
            set.drawValuesEnabled = false
        }
        set.valueTextColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        set.axisDependency = .left
        
        return LineChartData(dataSet: set)
    }
    
    //MARK: getBarData
    func getBarData(dataForCharts: [Double]) -> BarChartData {
        let entries: [ChartDataEntry];
        if formatForChartSwitchView.index == 0 {
            entries = (0..<7).map { (i) -> BarChartDataEntry in
                return BarChartDataEntry(x: Double(i), yValues: [Double(arc4random_uniform(13) + 12), Double(arc4random_uniform(13) + 12)])
            }
        } else {
            entries = (0..<dataForCharts.count).map { (i) -> BarChartDataEntry in
                return BarChartDataEntry(x: Double(i), yValues: [Double(arc4random_uniform(13) + 12), Double(arc4random_uniform(13) + 12)])
            }
        }
        
        let set = BarChartDataSet(entries: entries, label: "")
        set.stackLabels = ["Result", "Not performed"]
        set.colors = [UIColor(red: 61/255, green: 165/255, blue: 255/255, alpha: 1),
                      UIColor(red: 23/255, green: 197/255, blue: 255/255, alpha: 1)
        ]
        set.valueTextColor = .white
        
        if formatForChartSwitchView.index == 0 {
            set.valueFont = .systemFont(ofSize: 13)
        } else {
            set.valueFont = .systemFont(ofSize: 9)
        }
        if showValueCharts == true {
            set.drawValuesEnabled = true
        }else {
            set.drawValuesEnabled = false
        }
        set.axisDependency = .left
        
        let data =  BarChartData()
        data.dataSets = [set]
        data.barWidth = 0.9
        
        return data
    }
    
    //MARK: getAllDaysWeekOrMonth
    func getAllDaysWeekOrMonth(dateInterval: DateInterval) -> [String] {
        var dates: [String] = []
        
        Calendar.current.enumerateDates(startingAfter: dateInterval.start,
                                        matching: DateComponents(hour:0),
                                        matchingPolicy: .nextTime) { date, _, stop in
                                            guard let date = date else {
                                                return
                                            }
                                            if date <= dateInterval.end {
                                                let dateFormatter = DateFormatter()
                                                dateFormatter.dateFormat = "dd-MM-yyyy"
                                                dates.append(dateFormatter.string(from: date))
                                            } else {
                                                stop = true
                                            }
        }
        
        return dates
    }
    
    //MARK: setDataTransfer
    func setDataTransfer(time: Int, distance:Int, coordinates: String, date:String, regionImage: Data) -> Void{
          if runDateStore != nil{
                runTimeStore!.insert(time, at: 0)
                runDistanceStore!.insert(distance,at: 0)
                runCoordinateStore!.insert(coordinates, at: 0)
                runDateStore!.insert(date, at: 0)
                runRegionImageStore!.insert(regionImage, at: 0)
            }else{
                runTimeStore = [time]
                runDistanceStore = [distance]
                runCoordinateStore = [coordinates]
                runDateStore = [date]
                runRegionImageStore = [regionImage]
            }
        
            self.parseActivityChartStore()
            self.parseTableStore()
        
            if self.formatForChartSwitchView.index == 0{
                self.setWeekData()
            }else{
                self.setMonthData()
            }
        
    }
    //MARK: @OBJC
    
    
    //MARK: updateScrollEnabled
    @objc func updateScrollEnabled() {
        scrollView.isScrollEnabled = true
    }
    
    //MARK: swipingRunStoreTableView
    @objc func swipingRunStoreTableView() {
        runStoreTableView.isScrollEnabled = true
        scrollView.isScrollEnabled = false
    }
    
    //MARK: swipingScrollView
    @objc func swipingScrollView() {
        runStoreTableView.isScrollEnabled = false
        scrollView.isScrollEnabled = true
    }
    
    //MARK: showValueForChart
    @objc func showValueForChart(){
        if showValueCharts == true {
            showValueCharts = false
            showValueChartsButton.layer.borderColor = UIColor.white.cgColor
        } else {
            showValueCharts = true
            showValueChartsButton.layer.borderColor = UIColor.yellow.cgColor
        }
        if formatForChartSwitchView.index == 0{
            setWeekData()
        } else {
            setMonthData()
        }
    }
    
    //MARK: changeRunActivityChart
    @objc func changeRunActivityChart(){
        if formatForChartSwitchView.index == 0 {
            setWeekData()
        }else{
            setMonthData()
        }
    }
    
    //MARK: changeTargetBlock
    @objc func changeTargetBlock(){
        if targetBlockSwitchView.index == 0 {
            runTargetTimeBlockView.isHidden = false
            runStoreBlockView.isHidden = true
            
        }
        if targetBlockSwitchView.index == 1 {
            runTargetTimeBlockView.isHidden = true
            runStoreBlockView.isHidden = false
            
        }
    }
    
    //MARK: showRunProcess
    @objc func showRunProcess(){
        let viewController = RunProcessViewController()
        viewController.runDataTransfer = { [weak self] time, distance, coordinates, date, regionImage in
            guard let self = self else { return }
            self.setDataTransfer(time: time, distance: distance, coordinates: coordinates, date: date, regionImage: regionImage)
 
        }
        self.present(viewController, animated: true)
    }
    
    //MARK: CONSTRAINTS VIEW
    
    
    
    
    
    //MARK: createConstraintsScrollView
    func createConstraintsScrollView() {
        scrollView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    //MARK: createConstraintsRunActivityChartView
    func createConstraintsRunActivityChartView() {
        runActivityChartView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: scrollView.topAnchor, constant:90).isActive = true
        runActivityChartView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        runActivityChartView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 300).isActive = true
        runActivityChartView.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    //MARK: createConstraintsFormatForChartSwitchView
    func createConstraintsFormatForChartSwitchView() {
        formatForChartSwitchView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: motivationLabel.bottomAnchor, constant: 10).isActive = true
        formatForChartSwitchView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        formatForChartSwitchView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 45).isActive = true
        formatForChartSwitchView.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    
    //MARK: createConstraintsTargetBlockSwitchView
    func createConstraintsTargetBlockSwitchView() {
        targetBlockSwitchView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: formatForChartSwitchView.bottomAnchor, constant: 10).isActive = true
        targetBlockSwitchView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        targetBlockSwitchView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 45).isActive = true
        targetBlockSwitchView.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    //MARK: createConstraintsRunStoreBlockView
    func createConstraintsRunStoreBlockView() {
        runStoreBlockView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: targetBlockSwitchView.bottomAnchor, constant: 10).isActive = true
        runStoreBlockView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        runStoreBlockView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 180).isActive = true
        runStoreBlockView.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.77).isActive = true
    }
    
    //MARK: createConstraintsRunStoreTableView
    func createConstraintsRunStoreTableView() {
        runStoreTableView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: runStoreBlockView.topAnchor).isActive = true
        runStoreTableView.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: runStoreBlockView.bottomAnchor).isActive = true
        runStoreTableView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: runStoreBlockView.leadingAnchor).isActive = true
        runStoreTableView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: runStoreBlockView.trailingAnchor).isActive = true
        
    }
    
    //MARK: createConstraintsRunTargetTimeBlockView
    func createConstraintsRunTargetTimeBlockView() {
        runTargetTimeBlockView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: targetBlockSwitchView.bottomAnchor, constant: 10).isActive = true
        runTargetTimeBlockView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        runTargetTimeBlockView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 180).isActive = true
        runTargetTimeBlockView.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.77).isActive = true
    }
    
    //MARK: createConstraintsRunTargetTimeView
    func createConstraintsRunTargetTimeView() {
        runTargetTimePicker.safeAreaLayoutGuide.topAnchor.constraint(equalTo: runTargetTimeLabel.bottomAnchor, constant: -5).isActive = true
        runTargetTimePicker.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: runTargetTimeBlockView.centerXAnchor).isActive = true
        runTargetTimePicker.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 125).isActive = true
        runTargetTimePicker.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.77).isActive = true
    }
    
    //MARK: CONSTRAINTS LABEL
    
    
    
    //MARK: createConstraintsRunStatisticsLabel
    func createConstraintsRunStatisticsLabel() {
        runStatisticsLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: runActivityChartView.bottomAnchor, constant: 10).isActive = true
        runStatisticsLabel.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: runActivityChartView.centerXAnchor).isActive = true
        runStatisticsLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 25).isActive = true
        runStatisticsLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.75).isActive = true
    }
    
    //MARK: createConstraintsMotivationLabel
    func createConstraintsMotivationLabel() {
        motivationLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: runStatisticsLabel.bottomAnchor, constant: 10).isActive = true
        motivationLabel.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: targetBlockSwitchView.centerXAnchor).isActive = true
        motivationLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 25).isActive = true
        motivationLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.75).isActive = true
    }
    
    //MARK: createConstraintsRunTargetTimeLabel
    func createConstraintsRunTargetTimeLabel() {
        runTargetTimeLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: runTargetTimeBlockView.topAnchor, constant: 10).isActive = true
        runTargetTimeLabel.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: runTargetTimeBlockView.centerXAnchor).isActive = true
        runTargetTimeLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 200).isActive = true
        runTargetTimeLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    //MARK:CONSTRAINTS BUTTON
    
    
    
    //MARK: createConstraintsShowValueChartsButton
    func createConstraintsShowValueChartsButton() {
        showValueChartsButton.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: runActivityChartView.topAnchor).isActive = true
        showValueChartsButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 20).isActive = true
        showValueChartsButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 50).isActive = true
        showValueChartsButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: runActivityChartView.trailingAnchor,constant: -10).isActive = true
    }
    
    
    //MARK: createConstraintsRunStartButton
    func createConstraintsRunStartButton() {
        runStartButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: runStoreBlockView.bottomAnchor, constant: 5).isActive = true
        runStartButton.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        runStartButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 110).isActive = true
        runStartButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 110).isActive = true
    }
    
}

//MARK: EXTENSION


extension RunViewController: AGCircularPickerDelegate {
    
    func didChangeValues(_ values: Array<AGColorValue>, selectedIndex: Int) {
        scrollView.isScrollEnabled = false
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.updateScrollEnabled), userInfo: nil, repeats: false)
        
        let valueComponents = values.map { return String(format: "%02d", $0.value) }
        let fullString = valueComponents.joined(separator: ":")
        let attributedString = NSMutableAttributedString(string:fullString)
        let fullRange = (fullString as NSString).range(of: fullString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white.withAlphaComponent(0.5), range: fullRange)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold), range: fullRange)
        
        let range = NSMakeRange(selectedIndex * 2 + selectedIndex, 2)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: values[selectedIndex].color, range: range)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 35, weight: UIFont.Weight.black), range: range)
        
        runTargetTimeLabel.attributedText = attributedString
    }
    
}

extension RunViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let tableStore = tableStore else{
            return 1
        }
        return tableStore.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.clipsToBounds = true
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: "TrebuchetMS", size: 18)
        
        guard let tableStore = tableStore else{
            cell.backgroundColor = .lightGray
            cell.textLabel?.text = "Not data"
            cell.textLabel?.textColor = .white
            return cell
        }
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 20
        cell.textLabel?.attributedText = tableStore[indexPath.section]
        let cellImg : UIImageView = UIImageView(frame: CGRect(x: 10, y: 2.5, width: 50, height: 50))
        cellImg.image = UIImage(data: runRegionImageStore![indexPath.section])
        cellImg.layer.cornerRadius = 15
        cellImg.layer.masksToBounds = true
        cell.addSubview(cellImg)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let coordinatesStore = runCoordinateStore else {
            return
        }
        let coordinates: [CLLocationCoordinate2D] = coordinatesStore[indexPath.section].split(separator: ",").map {data in
            let point = data.split(separator: " ")
            let latitude = Double(point[0])
            let longitude = Double(point[1])
            return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            
        }

        let viewController = RunMapViewController()
        viewController.runCoordinates = coordinates
        self.present(viewController, animated: true)
    }
}

extension RunViewController: IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if formatForChartSwitchView.index == 0 {
            return daysWeek[Int(value) % daysWeek.count]
        }
        else{
            return String(Int(value) + 1)
        }
    }
}

extension RunViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return dragItem(at: indexPath)
    }
    
    private func dragItem(at indexPath: IndexPath) -> [UIDragItem] {
        if let coordinates = runCoordinateStore?.reverse(){
            let dragItem = UIDragItem(itemProvider: NSItemProvider())
            dragItem.localObject = coordinates
            return [dragItem]
        }
        else{
            return []
        }
    }
    
}

