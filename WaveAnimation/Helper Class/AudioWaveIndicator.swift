//
//  ViewController.swift
//  WaveAnimation
//
//  Created by Jatin on 16/12/23.
//

import UIKit

public class AudioWaveIndicator: UIView {
    public var minDb: Float = 20
    public var barSpacing = 10
    public var sampling: Int = 10
    public var strokeColor: UIColor = .green
    public var strokeWidth: CGFloat = 8
    public var showPercentage: CGFloat = 1
    private var powerStack = [Float]()
    private var timeCounter = 0
    
    public var power: Float = 40 {
        didSet {
            var p = abs(power)
            if p > minDb {
                p = minDb
            }
            if timeCounter % sampling == 0 {
                powerStack.append(p)
                if powerStack.count > 200 {
                    powerStack.removeFirst()
                }
            }
        }
    }

    override public func draw(_: CGRect) {
        let path = UIBezierPath()
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        path.lineWidth = strokeWidth
        strokeColor.set()

        let center = bounds.height / 2
        var index = powerStack.count - 1
        var startX = frame.width - 1 - (CGFloat(barSpacing * timeCounter) / CGFloat(sampling))

        while startX >= 0, index >= 0 {
            let delta = CGFloat(minDb - powerStack[index]) / CGFloat(minDb) * showPercentage * center
            path.move(to: .init(x: startX, y: center - delta))
            path.addLine(to: .init(x: startX, y: center + delta))
            index -= 1
            startX -= CGFloat(barSpacing)
        }
        path.close()
        path.stroke()

        timeCounter += 1
        timeCounter %= sampling
    }
    
    public func reset() {
        power = minDb
        powerStack.removeAll()
        timeCounter = 0
    }
}
