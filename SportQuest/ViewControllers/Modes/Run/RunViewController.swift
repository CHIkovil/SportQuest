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
    
    var runTimeStore: [Int] = []
    var runDistanceStore: [Int] = []
    var runDateStore: [String] = []
    var runCoordinatesStore: [String] = []
    
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
    
    //MARK: runTargetTimeBlockView
    lazy var runTargetTimeBlockView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 30
        view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
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
    
    //MARK: runBlockSwitchView
    lazy var runBlockSwitchView: BetterSegmentedControl = {
        let segmentView = BetterSegmentedControl(frame: CGRect(), segments: IconSegment.segments(withIcons: [UIImage(named: "target.png")!, UIImage(named: "cloud-computing.png")!],
                                       iconSize: CGSize(width: 30, height: 30),
                                       normalIconTintColor: .lightGray,
                                       selectedIconTintColor: #colorLiteral(red: 0.3046965897, green: 0.3007525206, blue: 0.8791586757, alpha: 1)))
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.cornerRadius = 20
        segmentView.addTarget(self,
                              action: #selector(changeRunBlock),
                              for: .valueChanged)
        return segmentView
    }()
    
    //MARK: runTargetTimeView
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
    
    //MARK: runningMotivationLabel
    lazy var runMotivationLabel:MarqueeLabel = {
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
    lazy var showValueChartButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("value", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        return button
    }()
    
    //MARK: runStartButton
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
        button.addTarget(self, action: #selector(showRunProcess), for: .touchUpInside)
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
        loadAndParseRunStore()
        
        view.addSubview(runScrollView)
        createConstraintsRunScrollView()
        
        runScrollView.addSubview(runActivityChartView)
        runScrollView.addSubview(runStatisticsLabel)
        runScrollView.addSubview(runMotivationLabel)
        runScrollView.addSubview(showValueChartButton)
        runScrollView.addSubview(runFormatForChartSwitchView)
        runScrollView.addSubview(runBlockSwitchView)
  
        
        runScrollView.addSubview(runTargetTimeBlockView)
        runTargetTimeBlockView.addSubview(runTargetTimeLabel)
        runTargetTimeBlockView.addSubview(runTargetTimeView)
        
        runScrollView.addSubview(runStoreTableView)


        runScrollView.addSubview(runStartButton)
        
        createConstraintscreateRunActivityBarChartView()
        createConstraintsRunFormatForChartSwitchView()
        createConstraintsRunBlockSwitchView()
        createConstraintsRunMotivationLabel()
        createConstraintsRunStatisticsLabel()
        createConstraintsShowValueChartButton()
        createConstraintsRunStoreTableView()
        createConstraintsRunTargetTimeBlockView()
        createConstraintsRunTargetTimeLabel()
        createConstraintsRunTargetTimeView()
        createConstraintsRunStartButton()

        runTargetTimeBlockView.isHidden = false
        runStoreTableView.isHidden = true
        
    }
    
    //MARK: viewDidAppear
     override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setWeekData()
    }
    
    //MARK: FUNC
    
    
    
    //MARK: setWeekData
    func setWeekData() {
        let data = CombinedChartData()
        
        let datesCurrentWeek = getAllDaysWeekOrMonth(dateInterval: Calendar.current.dateInterval(of: .weekOfMonth,for: Date())!)
        
        var weekDataForCharts: [Double] = []
        
        datesCurrentWeek.map {date in
            if runDateStore.contains(date) {
                let result = runDistanceStore.enumerated().filter({runDateStore[$0.offset] == date}).map({$0.element}).reduce(0, +)
                weekDataForCharts.append(Double(result))
            } else {
                weekDataForCharts.append(0)
            }
        }
        
        data.lineData = getLineData(dataForCharts: weekDataForCharts)
        data.barData = getBarData(dataForCharts: weekDataForCharts)
        
        runActivityChartView.xAxis.granularity = 1
        runActivityChartView.xAxis.axisMaximum = data.xMax + 0.45
        runActivityChartView.xAxis.axisMinimum = data.xMin - 0.45
        runActivityChartView.data = data
        
    }
    
    //MARK: setMonthData
    func setMonthData() {
        let data = CombinedChartData()
        
        let datesCurrentMonth = getAllDaysWeekOrMonth(dateInterval: Calendar.current.dateInterval(of: .month,for: Date())!)
        
        var monthDataForCharts: [Double] = []
            
        datesCurrentMonth.map {date in
            if runDateStore.contains(date) {
                let result = runDistanceStore.enumerated().filter({runDateStore[$0.offset] == date}).map({$0.element}).reduce(0, +)
                monthDataForCharts.append(Double(result))
            } else {
                monthDataForCharts.append(0)
            }
        }
        
        data.lineData = getLineData(dataForCharts:monthDataForCharts)
        data.barData = getBarData(dataForCharts:monthDataForCharts)
        
        runActivityChartView.xAxis.granularity = 1
        runActivityChartView.xAxis.axisMaximum = data.xMax + 0.45
        runActivityChartView.xAxis.axisMinimum = data.xMin - 0.45
        runActivityChartView.data = data
    
    }
    
    //MARK: getLineData
    func getLineData(dataForCharts:[Double]) -> LineChartData {
        let entries: [ChartDataEntry];
        if runFormatForChartSwitchView.index == 0{
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
        set.drawValuesEnabled = true
        if runFormatForChartSwitchView.index == 0 {
            set.valueFont = .systemFont(ofSize: 13)
        } else {
            set.valueFont = .systemFont(ofSize: 9)
        }
  
        set.valueTextColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        set.axisDependency = .left
        
        return LineChartData(dataSet: set)
    }
    
    //MARK: getBarData
    func getBarData(dataForCharts: [Double]) -> BarChartData {
        let entries: [ChartDataEntry];
        if runFormatForChartSwitchView.index == 0 {
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
        if runFormatForChartSwitchView.index == 0 {
            set.valueFont = .systemFont(ofSize: 13)
        } else {
            set.valueFont = .systemFont(ofSize: 9)
        }
        set.axisDependency = .left
          
        
        let data =  BarChartData()
        data.dataSets = [set]
        data.barWidth = 0.9
        
        return data
    }

    //MARK: loadAndParseRunStore
    func loadAndParseRunStore() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RunData")
        request.returnsObjectsAsFaults = false
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                runCoordinatesStore.append(data.value(forKey: "coordinates") as! String)
                runTimeStore.append(data.value(forKey: "time") as! Int)
                runDistanceStore.append(data.value(forKey: "distance") as! Int)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                runDateStore.append(dateFormatter.string(from: data.value(forKey: "date") as! Date))
            }
        } catch {
            print("Failed")
        }
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
            setWeekData()
        }else{
            setMonthData()
        }
    }
    
    //MARK: changeRunBlock
    @objc func changeRunBlock(){
        if runBlockSwitchView.index == 0 {
            runTargetTimeBlockView.isHidden = false
            runStoreTableView.isHidden = true

        }
        if runBlockSwitchView.index == 1 {
            runTargetTimeBlockView.isHidden = true
            runStoreTableView.isHidden = false

        }
    }

     //MARK: showRunProcess
    @objc func showRunProcess(){
        let viewController = RunProcessViewController()
        viewController.runDataTransfer = {coordinates, time, distance, date in
            
        }
        self.present(viewController, animated: true)
    }

    //MARK: CONSTRAINTS VIEW
    
    
    
    //MARK: createConstraintsRunScrollView
    func createConstraintsRunScrollView() {
        runScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        runScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        runScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        runScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    //MARK: createConstraintsRunStoreTableView
    func createConstraintsRunStoreTableView() {
        runStoreTableView.topAnchor.constraint(equalTo: runBlockSwitchView.bottomAnchor, constant: 10).isActive = true
        runStoreTableView.centerXAnchor.constraint(equalTo: runScrollView.centerXAnchor).isActive = true
        runStoreTableView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        runStoreTableView.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    //MARK: createConstraintsRunTargetTimeBlockView
    func createConstraintsRunTargetTimeBlockView() {
        runTargetTimeBlockView.topAnchor.constraint(equalTo: runBlockSwitchView.bottomAnchor, constant: 10).isActive = true
        runTargetTimeBlockView.centerXAnchor.constraint(equalTo: runScrollView.centerXAnchor).isActive = true
        runTargetTimeBlockView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        runTargetTimeBlockView.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    //MARK: createConstraintscreateRunActivityBarChartView
    func createConstraintscreateRunActivityBarChartView() {
        runActivityChartView.topAnchor.constraint(equalTo: runScrollView.topAnchor, constant: 50).isActive = true
        runActivityChartView.centerXAnchor.constraint(equalTo: runScrollView.centerXAnchor).isActive = true
        runActivityChartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        runActivityChartView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    //MARK: createConstraintsRunFormatForChartSwitchView
    func createConstraintsRunFormatForChartSwitchView() {
        runFormatForChartSwitchView.topAnchor.constraint(equalTo: runMotivationLabel.bottomAnchor, constant: 10).isActive = true
        runFormatForChartSwitchView.centerXAnchor.constraint(equalTo: runScrollView.centerXAnchor).isActive = true
        runFormatForChartSwitchView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        runFormatForChartSwitchView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    //MARK: createConstraintsRunBlockSwitchView
    func createConstraintsRunBlockSwitchView() {
        runBlockSwitchView.topAnchor.constraint(equalTo: runFormatForChartSwitchView.bottomAnchor, constant: 10).isActive = true
        runBlockSwitchView.centerXAnchor.constraint(equalTo: runScrollView.centerXAnchor).isActive = true
        runBlockSwitchView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        runBlockSwitchView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    //MARK: createConstraintsRunTargetTimeView
    func createConstraintsRunTargetTimeView() {
        runTargetTimeView.topAnchor.constraint(equalTo: runTargetTimeLabel.bottomAnchor, constant: -10).isActive = true
        runTargetTimeView.centerXAnchor.constraint(equalTo: runTargetTimeBlockView.centerXAnchor).isActive = true
        runTargetTimeView.widthAnchor.constraint(equalToConstant: 280).isActive = true
        runTargetTimeView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
 
    
    //MARK: CONSTRAINTS LABEL
    
    
    
    //MARK: createConstraintsRunStatisticsLabel
     func createConstraintsRunStatisticsLabel() {
        runStatisticsLabel.topAnchor.constraint(equalTo: runActivityChartView.bottomAnchor, constant: 2).isActive = true
         runStatisticsLabel.centerXAnchor.constraint(equalTo: runActivityChartView.centerXAnchor).isActive = true
         runStatisticsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
         runStatisticsLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
     }
    
    //MARK: createConstraintsRunMotivationLabel
    func createConstraintsRunMotivationLabel() {
        runMotivationLabel.topAnchor.constraint(equalTo: runStatisticsLabel.bottomAnchor, constant: 2).isActive = true
        runMotivationLabel.centerXAnchor.constraint(equalTo: runBlockSwitchView.centerXAnchor).isActive = true
        runMotivationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        runMotivationLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
    }
    
    //MARK: createConstraintsRunTargetTimeLabel
    func createConstraintsRunTargetTimeLabel() {
        runTargetTimeLabel.topAnchor.constraint(equalTo: runTargetTimeBlockView.topAnchor, constant: 10).isActive = true
        runTargetTimeLabel.centerXAnchor.constraint(equalTo: runTargetTimeBlockView.centerXAnchor).isActive = true
        runTargetTimeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        runTargetTimeLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    //MARK:CONSTRAINTS BUTTON
    

    
    //MARK: createConstraintsShowValueChartButton
    func createConstraintsShowValueChartButton() {
        showValueChartButton.bottomAnchor.constraint(equalTo: runActivityChartView.bottomAnchor,constant: -5).isActive = true
        showValueChartButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        showValueChartButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        showValueChartButton.trailingAnchor.constraint(equalTo: runActivityChartView.trailingAnchor,constant: -5).isActive = true
    }
    
    
    //MARK: createConstraintsRunStartButton
    func createConstraintsRunStartButton() {
        runStartButton.topAnchor.constraint(equalTo: runStoreTableView.bottomAnchor, constant: 10).isActive = true
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
            cell.textLabel?.text = String(runDistanceStore[indexPath.row])
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
        if runFormatForChartSwitchView.index == 0 {
            return daysWeek[Int(value) % daysWeek.count]
        }
        else{
            return String(Int(value) + 1)
        }
    }
}


