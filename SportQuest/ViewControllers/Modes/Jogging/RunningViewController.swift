//
//  JoggingViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 13.10.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//

import UIKit
import AMTabView
import SwiftCharts

class RunningViewController: UIViewController,TabItem {
    
    //MARK: View
    lazy var runningScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize.height = 700
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var runningActivityView: BarsChart = {
        let chartConfig = BarsChartConfig(
            valsAxisConfig: ChartAxisConfig(from: 0, to: 7, by: 1)
        )
        
        let frame = CGRect(x: 10, y: 60, width: 350, height: 250)
        
        let chart = BarsChart(
            frame: frame,
            chartConfig: chartConfig,
            xTitle: "Days",
            yTitle: "",
            bars: [
                ("A", 2),
                ("B", 4.5),
                ("C", 3),
                ("D", 5.4),
                ("E", 6),
                ("F", 0.5)
            ],
            color: UIColor.red,
            barWidth: 35
        )
        chart.view.backgroundColor = .gray
        return chart
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
        runningScrollView.addSubview(runningActivityView.view)
    }
    
    //MARK: ConstraintsScrollView
    func createConstraintsRunningScrollView() {
        runningScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        runningScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        runningScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        runningScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }
}
