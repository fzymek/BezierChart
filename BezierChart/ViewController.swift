//
//  ViewController.swift
//  BezierChart
//
//  Created by Zymek, Filip on 17/02/2020.
//  Copyright © 2020 Filip Zymek. All rights reserved.
//

import UIKit

struct ChartData {
    let x: [Float]
    let y: [Float]


    static func initWithSin() -> ChartData {
        var xVals = [Float]()
        var yVals = [Float]()
        for rad in stride(from: -4 * Float.pi , through: .pi * 4, by: .pi/20) {
            let degree = Float(rad * 180 / .pi)
            xVals.append(degree)
            yVals.append(sin(rad))
        }
        return ChartData(x: xVals, y: yVals)
    }


    static func initWithHR() -> ChartData {
        var xVals = [Float]()
        var yVals = [Float]()
        for time in stride(from: 0, through: 60, by: 1) {
            xVals.append(Float(time))
            yVals.append(Float(Int.random(in: 80..<190)))
        }
        return ChartData(x: xVals, y: yVals)
    }
}

class ViewController: UIViewController {

    let sine = ChartData.initWithSin()
    let hr = ChartData.initWithHR()

    private let chart: Chart = {
        let chart = Chart()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.axisColor = .white
        chart.axisWidth = 1.0
        chart.lineColor = .blue
        chart.lineWidth = 2.0
        chart.gradientStart = UIColor(red: 1, green: 0.662, blue: 0.223, alpha: 1)
        chart.gradientEnd = UIColor(red: 1, green: 0.282, blue: 0.267, alpha: 1)
        chart.backgroundColor = .clear
        return chart
    }()

    private var isShowingHR = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false

        configureChartView()
        chart.render(data: sine)

        scheduleHR()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        chart.setNeedsDisplay()
    }

    private func configureChartView() {
        view.addSubview(chart)

        chart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        chart.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        view.safeAreaLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: chart.bottomAnchor, constant: 16).isActive = true
        view.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: chart.rightAnchor , constant: 16).isActive = true

        chart.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
    }


    private func scheduleHR() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            self.chart.render(data: self.hr)
            self.scheduleSine()
        }
    }

    private func scheduleSine() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            self.chart.render(data: self.sine)
            self.scheduleHR()
        }
    }

}

