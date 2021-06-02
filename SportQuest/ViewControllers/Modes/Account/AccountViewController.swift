//
//  AccountViewController.swift
//  SportQuest
//
//  Created by Никита Бычков on 13.10.2020.
//  Copyright © 2020 Никита Бычков. All rights reserved.
//

import UIKit
import AMTabView
import Charts

class AccountViewController: UIViewController, TabItem {
    private let skills = ["Ловкость", "Выносливость", "Интеллект"]
    
    //MARK: skillsChartView
    lazy var skillsChartView: RadarChartView = {
        let chart = RadarChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.backgroundColor = .lightGray
        chart.chartDescription?.enabled = false
        chart.webLineWidth = 1
        chart.innerWebLineWidth = 1
        chart.webColor = .white
        chart.innerWebColor = .white
        chart.webAlpha = 1
        
        chart.legend.enabled = false
        chart.legend.horizontalAlignment = .center
        chart.legend.verticalAlignment = .top
        chart.legend.orientation = .horizontal
        
        chart.xAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        chart.xAxis.xOffset = 0
        chart.xAxis.yOffset = 0
        chart.xAxis.valueFormatter = self
        chart.xAxis.labelTextColor = .white
        chart.yAxis.labelFont = .systemFont(ofSize: 9, weight: .light)
        chart.yAxis.labelCount = 3
        chart.yAxis.axisMinimum = 0
        chart.yAxis.axisMaximum = 80
        chart.yAxis.drawLabelsEnabled = false
        return chart
    }()
    
     //MARK: UIImageView
    
    
    
    //MARK: userImageView
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "gnome.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 4
        return imageView
    }()
    
    //MARK: UITextField
    
    
    
    // MARK: setupDistanceTextField
    lazy var setupDistanceTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "12000m"
        textField.font = UIFont(name: "Chalkduster", size: 15)
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.tintColor = .clear
        textField.textColor = .white
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.cornerRadius = 15
        return textField
    }()
    
    //MARK: UILabel
    
    
    
    
    // MARK: levelLabel
    lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lvl 1"
        label.font = UIFont(name: "Chalkduster", size: 20)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .clear
        label.layer.borderColor = UIColor.clear.cgColor
        return label
    }()
    
    // MARK: achievePointsLabel
    lazy var achievePointsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+100"
        label.font = UIFont(name: "Chalkduster", size: 13)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.9395605326, green: 0.9326097369, blue: 0.2754085362, alpha: 1)
        label.backgroundColor = .clear
        label.layer.borderColor = UIColor.clear.cgColor
        return label
    }()
    
    // MARK: lineCompleteAchieveLabel
    lazy var lineCompleteAchieveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = #colorLiteral(red: 0.9395605326, green: 0.9326097369, blue: 0.2754085362, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.layer.masksToBounds = true
        return label
    }()
    
    // MARK: lineLevelLabel
    lazy var lineLevelLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.layer.masksToBounds = true
        return label
    }()
    
    // MARK: setupDistanceLabel
    lazy var setupDistanceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Distance"
        label.font = UIFont(name: "Chalkduster", size: 20)
        label.textAlignment = .center
        label.textColor = .gray
        label.backgroundColor = .clear
        label.layer.borderColor = UIColor.clear.cgColor
        return label
    }()

    
    
    //MARK: UIButton
    
    
    
    
    //MARK: achieveButton
    lazy var achieveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: 0, y: 0 , width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"wreath.png"), for: .normal)
        button.addTarget(self, action: #selector(showAchieve), for: .touchUpInside)
        return button
    }()
    
    //MARK: logOutButton
    lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: 0, y: 0 , width: 40, height: 40)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"logout.png"), for: .normal)
        button.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        return button
    }()
    
    //MARK: tabImage
    var tabImage: UIImage? {
      return UIImage(named: "account.png")
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        parseUserStore()
        view.addSubview(skillsChartView)
        view.addSubview(userImageView)
        view.addSubview(levelLabel)
        view.addSubview(achievePointsLabel)
        view.addSubview(lineLevelLabel)
        view.addSubview(lineCompleteAchieveLabel)
        view.addSubview(setupDistanceLabel)
        view.addSubview(setupDistanceTextField)
        view.addSubview(achieveButton)
        view.addSubview(logOutButton)
        
        createConstraintsSkillsChartView()
        createConstraintsUserImageView()
        createConstraintsLevelLabel()
        createConstraintsAchievePointsLabel()
        createConstraintsLineLevelLabel()
        createConstraintsLineCompleteAchieveLabel()
        createConstraintsSetupDistanceLabel()
        createConstraintsSetupDistanceTextField()
        createConstraintsAchieveButton()
        createConstraintsLogOutButton()
    }
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        setSkillsChartData()
    }
    
    //MARK: touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
    
    //MARK: createConstraintsSkillsChartView
     func createConstraintsSkillsChartView() {
        skillsChartView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: -10).isActive = true
        skillsChartView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: userImageView.centerXAnchor).isActive = true
        skillsChartView.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 300).isActive = true
        skillsChartView.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 300).isActive = true
     }
    
    // MARK: CONSTRAINTS UIImageView
    
    
    
    
    //MARK: createConstraintsUserImageView
    func createConstraintsUserImageView() {
        userImageView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        userImageView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor, constant: 170).isActive = true
    }
    
    
    // MARK: CONSTRAINTS UITextField
    
    
    
    //MARK: createConstraintsSetupDistanceTextField
    func createConstraintsSetupDistanceTextField() {
        setupDistanceTextField.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: setupDistanceLabel.centerYAnchor).isActive = true
        setupDistanceTextField.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: setupDistanceLabel.trailingAnchor, constant: 10).isActive = true
        
    }
    
    
    
     // MARK: CONSTRAINTS UILabel
    
    
    
    //MARK: createConstraintsLevelLabel
    func createConstraintsLevelLabel() {
        levelLabel.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: lineLevelLabel.leadingAnchor,constant: -10).isActive = true
        levelLabel.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: lineLevelLabel.centerYAnchor).isActive = true
    }
    
    //MARK: createConstraintsLevelLabel
    func createConstraintsAchievePointsLabel() {
        achievePointsLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: lineLevelLabel.bottomAnchor, constant: 5).isActive = true
        achievePointsLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: lineLevelLabel.leadingAnchor,constant: 5).isActive = true
    }
    
    //MARK: createConstraintsLineCompleteAchieveLabel
    func createConstraintsLineCompleteAchieveLabel() {
        lineCompleteAchieveLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: lineLevelLabel.leadingAnchor).isActive = true
        lineCompleteAchieveLabel.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: lineLevelLabel.trailingAnchor,constant: -20).isActive = true
        lineCompleteAchieveLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: lineLevelLabel.topAnchor).isActive = true
        lineCompleteAchieveLabel.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: lineLevelLabel.bottomAnchor).isActive = true
    }
    
    //MARK: createConstraintsLineLevelLabel
    func createConstraintsLineLevelLabel() {
        lineLevelLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: skillsChartView.bottomAnchor, constant: -50).isActive = true
        lineLevelLabel.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: skillsChartView.centerXAnchor).isActive = true
        lineLevelLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 30).isActive = true
        lineLevelLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    //MARK: createConstraintsSetupDistanceLabel
    func createConstraintsSetupDistanceLabel() {
        setupDistanceLabel.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: levelLabel.leadingAnchor).isActive = true
        setupDistanceLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: levelLabel.bottomAnchor,constant: 30).isActive = true
    }
    
    
    
    
    //MARK: CONSTRAINTS UIButton
    
    
    
    
    //MARK: createConstraintsAchieveButton
    func createConstraintsAchieveButton() {
        achieveButton.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: lineLevelLabel.centerYAnchor).isActive = true
        achieveButton.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: lineLevelLabel.trailingAnchor, constant: 10).isActive = true
       achieveButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 50).isActive = true
       achieveButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //MARK: createConstraintsLogOutButton
    func createConstraintsLogOutButton() {
        logOutButton.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: userImageView.topAnchor, constant: -10).isActive = true
        logOutButton.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: achieveButton.centerXAnchor).isActive = true
        logOutButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 40).isActive = true
        logOutButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    //MARK: func
    
    
    
    //MARK: parseUserStore
    func parseUserStore() {
        
    }
    
    //MARK: setSkillsChartData
    func setSkillsChartData() {
        skillsChartView.data = getSkillsChartData()
        skillsChartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    //MARK: getSkillsChartData
    func getSkillsChartData() -> RadarChartData {
        let mult: UInt32 = 50
         let min: UInt32 = 50
         let cnt = 3
         
         let block: (Int) -> RadarChartDataEntry = { _ in return RadarChartDataEntry(value: Double(arc4random_uniform(mult) + min))}
         let entries = (0..<cnt).map(block)
         
         let set = RadarChartDataSet(entries: entries, label: "")
         set.setColor(UIColor(red: 103/255, green: 110/255, blue: 129/255, alpha: 1))
         set.fillColor = UIColor(red: 103/255, green: 110/255, blue: 129/255, alpha: 1)

         set.fillAlpha = 0.7
         set.lineWidth = 2
         set.drawHighlightCircleEnabled = true
         set.drawFilledEnabled = true
         set.setDrawHighlightIndicators(false)
         
         let data = RadarChartData()
         data.setValueFont(.systemFont(ofSize: 8, weight: .light))
         data.setDrawValues(false)
         data.setValueTextColor(.white)
         data.dataSets = [set]
         return data
    }
    
    
    //MARK: objc
    
    //MARK: showAchieve
    @objc func showAchieve(){
        let viewController = AchieveViewController()
        self.present(viewController, animated: true)
    }
    
    //MARK: logOut
    @objc func logOut(){
        
    }
    
}

extension AccountViewController:IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return skills[Int(value) % skills.count]
    }
    
}

