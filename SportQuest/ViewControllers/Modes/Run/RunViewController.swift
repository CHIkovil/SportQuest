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
    
    var weekDataForChart: [Double]?
    var monthDataForChart: [Double]?
    var showValueCharts: Bool = false
    
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
                              action: #selector(changeRunActivityChart),
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
                              action: #selector(changeBlock),
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
    lazy var showValueChartsButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("value", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
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

        view.addSubview(runActivityChartView)
        view.addSubview(runStatisticsLabel)
        view.addSubview(runMotivationLabel)
        view.addSubview(showValueChartsButton)
        view.addSubview(runFormatForChartSwitchView)
        view.addSubview(runBlockSwitchView)
  
        
        view.addSubview(runTargetTimeBlockView)
        runTargetTimeBlockView.addSubview(runTargetTimeLabel)
        runTargetTimeBlockView.addSubview(runTargetTimeView)
        
        view.addSubview(runStoreTableView)


        view.addSubview(runStartButton)
        
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
        
        data.lineData = getLineData(dataForCharts:monthData)
        data.barData = getBarData(dataForCharts:monthData)
        
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
        if runFormatForChartSwitchView.index == 0 {
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

    //MARK: loadAndParseRunStore
    func loadAndParseRunStore() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RunData")
        request.returnsObjectsAsFaults = false
        
        var timeStore: [Int] = []
        var distanceStore: [Int] = []
        var dateStore: [String] = []
        var coordinatesStore: [String] = []
        
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                coordinatesStore.append(data.value(forKey: "coordinates") as! String)
                timeStore.append(data.value(forKey: "time") as! Int)
                distanceStore.append(data.value(forKey: "distance") as! Int)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                dateStore.append(dateFormatter.string(from: data.value(forKey: "date") as! Date))
            }
            
        } catch {
            showValueChartsButton.isHidden = true
            return
        }
        
        var weekDataForChart: [Double] = []
        var monthDataForChart: [Double] = []
        
        let datesCurrentWeek = getAllDaysWeekOrMonth(dateInterval: Calendar.current.dateInterval(of: .weekOfMonth,for: Date())!)
        let datesCurrentMonth = getAllDaysWeekOrMonth(dateInterval: Calendar.current.dateInterval(of: .month,for: Date())!)
        
        for date in datesCurrentWeek {
            if dateStore.contains(date) {
                let result = distanceStore.enumerated().filter({dateStore[$0.offset] == date}).map({$0.element}).reduce(0, +)
                weekDataForChart.append(Double(result))
            } else {
                weekDataForChart.append(0)
            }
        }
        
        for date in datesCurrentMonth {
            if dateStore.contains(date) {
                let result = distanceStore.enumerated().filter({dateStore[$0.offset] == date}).map({$0.element}).reduce(0, +)
                monthDataForChart.append(Double(result))
            } else {
                monthDataForChart.append(0)
            }
        }

        self.weekDataForChart = weekDataForChart
        self.monthDataForChart = monthDataForChart
        showValueChartsButton.isHidden = false
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
    
    
    
    //MARK: showValueChart
    @objc func showValueForChart(){
        if showValueCharts == true {
            showValueCharts = false
            showValueChartsButton.layer.borderColor = UIColor.white.cgColor
        }else {
            showValueCharts = true
            showValueChartsButton.layer.borderColor = UIColor.yellow.cgColor
        }
        if runFormatForChartSwitchView.index == 0{
            setWeekData()
        }else {
            setMonthData()
        }
    }
    
    //MARK: changeRunActivityChart
    @objc func changeRunActivityChart(){
        if runFormatForChartSwitchView.index == 0 {
            setWeekData()
        }else{
            setMonthData()
        }
    }
    
    //MARK: changeBlock
    @objc func changeBlock(){
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
    
    
    
    
    //MARK: createConstraintsRunStoreTableView
    func createConstraintsRunStoreTableView() {
        runStoreTableView.topAnchor.constraint(equalTo: runBlockSwitchView.bottomAnchor, constant: 10).isActive = true
        runStoreTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        runStoreTableView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        runStoreTableView.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    //MARK: createConstraintsRunTargetTimeBlockView
    func createConstraintsRunTargetTimeBlockView() {
        runTargetTimeBlockView.topAnchor.constraint(equalTo: runBlockSwitchView.bottomAnchor, constant: 10).isActive = true
        runTargetTimeBlockView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        runTargetTimeBlockView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        runTargetTimeBlockView.heightAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    //MARK: createConstraintscreateRunActivityBarChartView
    func createConstraintscreateRunActivityBarChartView() {
        runActivityChartView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        runActivityChartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        runActivityChartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        runActivityChartView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    //MARK: createConstraintsRunFormatForChartSwitchView
    func createConstraintsRunFormatForChartSwitchView() {
        runFormatForChartSwitchView.topAnchor.constraint(equalTo: runMotivationLabel.bottomAnchor, constant: 10).isActive = true
        runFormatForChartSwitchView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        runFormatForChartSwitchView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        runFormatForChartSwitchView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    //MARK: createConstraintsRunBlockSwitchView
    func createConstraintsRunBlockSwitchView() {
        runBlockSwitchView.topAnchor.constraint(equalTo: runFormatForChartSwitchView.bottomAnchor, constant: 10).isActive = true
        runBlockSwitchView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
        showValueChartsButton.bottomAnchor.constraint(equalTo: runActivityChartView.bottomAnchor,constant: -5).isActive = true
        showValueChartsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        showValueChartsButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        showValueChartsButton.trailingAnchor.constraint(equalTo: runActivityChartView.trailingAnchor,constant: -5).isActive = true
    }
    
    
    //MARK: createConstraintsRunStartButton
    func createConstraintsRunStartButton() {
        runStartButton.topAnchor.constraint(equalTo: runStoreTableView.bottomAnchor, constant: 10).isActive = true
        runStartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
            return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = "1111"
        return cell
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


