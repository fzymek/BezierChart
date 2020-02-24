//
//  Chart.swift
//  BezierChart
//
//  Created by Zymek, Filip on 21/02/2020.
//  Copyright © 2020 Filip Zymek. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class Chart: UIView {

    @IBInspectable var gradientStart: UIColor = .blue
    @IBInspectable var gradientEnd: UIColor = .blue
    @IBInspectable var cornerRadius: CGSize = CGSize(width: 8.0, height: 8.0)

    @IBInspectable var axisColor: UIColor = .white
    @IBInspectable var axisWidth: CGFloat = 4

    @IBInspectable var lineColor: UIColor = .blue
    @IBInspectable var lineWidth: CGFloat = 2

    private let xAxisMargin: CGFloat = 4
    private let defaultLineWidth: CGFloat = 1

    var chartData: ChartData?

    override func draw(_ rect: CGRect) {
        clipCorners(rect)
        drawGradient(rect)
        drawXAxis(rect)
        drawPoints(rect)
    }

    fileprivate func clipCorners(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: cornerRadius)
        path.addClip()
    }

    fileprivate func drawGradient(_ rect: CGRect) {
        let drawingContext = UIGraphicsGetCurrentContext()
        let colors = [gradientStart.cgColor, gradientEnd.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]

        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)

        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)!

        drawingContext?.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
    }

    fileprivate func drawXAxis(_ rect: CGRect) {
        let center = (rect.height - axisWidth) / 2
        axisColor.setFill()
        axisColor.setStroke()
        let path = UIBezierPath()
        path.lineWidth = axisWidth > 0 ? axisWidth : defaultLineWidth
        path.move(to: CGPoint(x: xAxisMargin, y: center))
        path.addLine(to: CGPoint(x: rect.width - xAxisMargin, y: center))
        path.stroke()
    }

    fileprivate func drawPoints(_ rect: CGRect) {
        guard let data = chartData, let min = data.y.min(), let max = data.y.max() else {
            return
        }

        // normalize values to floats to range of 0.0 .. 1.0
        let normailzedYValues = data.y.map {
            return ($0 - min) / (max - min)
        }

        let axisSize = axisWidth > 0 ? axisWidth : defaultLineWidth

        // determines size of line
        let amplitude = (rect.height - axisSize) / 2

        // y-axis offset as we are not drawing full size rather then half size
        // we are adding amplitude as we need to draw "upside down" due to coordinate systems increasing downwards
        let yOffset = amplitude / 2 + amplitude

        // TODO: normalize and use provided data
        // detemines equal spacing of x-axis values
        let xStep = (rect.width - (2 * xAxisMargin)) / CGFloat(data.x.count)

        //starting point
        var posX = xAxisMargin
        var posY = yOffset - CGFloat(normailzedYValues[0]) * amplitude

        // begin drawing
        let path = UIBezierPath()
        path.lineWidth = lineWidth > 0 ? lineWidth : defaultLineWidth
        path.move(to: CGPoint(x: posX, y: posY))

        for val in normailzedYValues.dropFirst() {
            posX += xStep
            posY = yOffset - CGFloat(val) * amplitude
            path.addLine(to: CGPoint(x: posX, y: posY))
        }

        lineColor.setFill()
        lineColor.setStroke()
        path.stroke()
    }

    func render(data: ChartData) {
        self.chartData = data
        setNeedsDisplay()
    }

}
