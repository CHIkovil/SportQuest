//
//  ProgressMapView.swift
//  SportQuest
//
//  Created by Никита Бычков on 22.06.2021.
//  Copyright © 2021 Никита Бычков. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol ProgressMapViewDelegate:NSObjectProtocol {
    func addTargetButton()
    func setMapViewDelegate()
    func displayRunDistance(distance:Distance?)
    func displayIntervalAnnotation(points:[CLLocationCoordinate2D])
    func displayProgressInfo(text: NSMutableAttributedString) 
}

class ProgressMapView: UIView {
    
    //MARK: runMapView
    lazy var runMapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 45
        view.overrideUserInterfaceStyle = .dark
 
        return view
    }()
    
    //MARK: UILabel
    

    //MARK: runDataLabel
    lazy var runDataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.clear.cgColor
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    //MARK: runIntervalLabel
    lazy var runIntervalLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2"
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = .systemFont(ofSize: 25, weight: UIFont.Weight.bold)
        return label
    }()
    
    //MARK: UIButton
    
    
    
    
    //MARK: exitButton
    lazy var exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.clear.cgColor
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: 0, y: 0 , width: 45, height: 45)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"exit.png"), for: .normal)
        return button
    }()
    
    //MARK: runIntervalButton
    lazy var runIntervalButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.frame = CGRect(x: 0, y: 0 , width: 30, height: 30)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.setImage(UIImage(named:"add.png"), for: .normal)
        return button
    }()
    
    //MARK: runDownIntervalButton
    lazy var runDownIntervalButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.frame = CGRect(x: 0, y: 0 , width: 30, height: 30)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.isEnabled = false
        button.setImage(UIImage(named:"minus.png"), for: .normal)
        return button
    }()
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(runMapView)
        self.addSubview(runDataLabel)
        self.addSubview(exitButton)
        self.addSubview(runIntervalLabel)
        self.addSubview(runIntervalButton)
        self.addSubview(runDownIntervalButton)
        
        createConstraintsRunMapView()
        createConstraintsRunDataLabel()
        createConstraintsExitButton()
        createConstraintsRunIntervalLabel()
        createConstraintsRunIntervalButton()
        createConstraintsRunDownIntervalButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: CONSTRAINTS
    
    
    
    //MARK: createConstraintsRunMapView
    func createConstraintsRunMapView() {
        runMapView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        runMapView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        runMapView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        runMapView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    // MARK: CONSTRAINTS UILabel
    
    
    
    //MARK: createConstraintsRunDataLabel
    func createConstraintsRunDataLabel() {
        runDataLabel.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        runDataLabel.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        runDataLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 150).isActive = true
        runDataLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //MARK: createConstraintsRunIntervalLabel
      func createConstraintsRunIntervalLabel() {
          runIntervalLabel.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: runIntervalButton.leadingAnchor).isActive = true
        runIntervalLabel.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: runIntervalButton.centerYAnchor).isActive = true
          runIntervalLabel.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 20).isActive = true
          runIntervalLabel.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 20).isActive = true
      }
    
    // MARK: CONSTRAINTS UIButton
    
    
    
    //MARK: createConstraintsExitButton
    func createConstraintsExitButton() {
        exitButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        exitButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        exitButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 45).isActive = true
        exitButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    //MARK: createConstraintsRunIntervalButton
    func createConstraintsRunIntervalButton() {
        runIntervalButton.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: runDownIntervalButton.leadingAnchor,constant: -5).isActive = true
        runIntervalButton.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: runDownIntervalButton.centerYAnchor).isActive = true
        runIntervalButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 30).isActive = true
        runIntervalButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    //MARK: createConstraintsRunDownIntervalButton
    func createConstraintsRunDownIntervalButton() {
        runDownIntervalButton.safeAreaLayoutGuide.topAnchor.constraint(equalTo: exitButton.bottomAnchor,constant: 30).isActive = true
        runDownIntervalButton.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: exitButton.centerXAnchor).isActive = true
        runDownIntervalButton.safeAreaLayoutGuide.widthAnchor.constraint(equalToConstant: 30).isActive = true
        runDownIntervalButton.safeAreaLayoutGuide.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
