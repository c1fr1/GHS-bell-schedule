//
//  PeriodListClasses.swift
//  GHS schedule
//
//  Created by Varas Pendragon on 9/5/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit

class PeriodListLayer:CALayer {
    var scheduleType:String = "NO SCHOOL"
    var textlyr:CATextLayer = CATextLayer()
    var periods:[PeriodTextLayer]
    override init() {
        periods = []
        super.init()
        for x in 1...9 {
            periods.append(PeriodTextLayer(with: UIScreen.main.bounds.width, y: 50*CGFloat(x), period: ["NAME":"", "START":"", "END":""]))
            addSublayer(periods.last!)
        }
        textlyr.font = UIFont(name: "Arial", size: 12)!
        textlyr.fontSize = 26
        textlyr.string = scheduleType
        textlyr.foregroundColor = UIColor.darkGray.cgColor
        addSublayer(textlyr)
        textlyr.contentsScale = UIScreen.main.scale
    }
    override init(layer: Any) {
        let nLayer = layer as! PeriodListLayer
        scheduleType = nLayer.scheduleType
        textlyr = nLayer.textlyr
        periods = nLayer.periods
        super.init(layer: layer)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup() {
        if schedule == nil {
            orderedSchedule = []
            schedule = [:]
            periodInfo = [:]
        }
        textlyr.frame = CGRect(x: 15, y: 12, width: frame.width, height: 38)
        if selectedDay != nil {
            let sType = schedule![getDate(from: (selectedMonth, selectedDay!, selectedYear))]
            if sType != nil {
                scheduleType = sType!
                if scheduleType == "NOSCHOOL" {
                    scheduleType = "NO SCHOOL"
                }
            }else {
                scheduleType = "NO SCHOOL"
            }
            textlyr.string = scheduleType
            if let schdle = periodInfo![scheduleType] {
                setSchedule(schedule: schdle)
            }else {
                setSchedule(schedule: [])
            }
        }
        if translationPeriods != nil {
            for p in periods {
                p.frame.origin.x = translationPeriods!
            }
        }else {
            for p in periods {
                p.frame.origin.x = 0
            }
        }
    }
    func setSchedule(schedule:[[String:String]]) {
        for p in periods {
            p.reuse(period: ["NAME":"", "START":"", "END":""])
        }
        for (num, dict) in schedule.enumerated() {
            periods[num].reuse(period: dict)
        }
    }
    override func draw(in ctx: CGContext) {
        ctx.setFillColor(UIColor.lightGray.cgColor)
        ctx.fill(CGRect(x: 0, y: 0, width: frame.width, height: 50))
    }
}
class PeriodTextLayer:CALayer {
    var nameLayer:CATextLayer
    var startLayer:CATextLayer
    var endLayer:CATextLayer
    override init(layer: Any) {
        let l = layer as! PeriodTextLayer
        nameLayer = l.nameLayer
        startLayer = l.startLayer
        endLayer = l.endLayer
        super.init(layer: layer)
    }
    init(with width:CGFloat, y:CGFloat, period:[String:String]) {
        nameLayer = CATextLayer()
        startLayer = CATextLayer()
        endLayer = CATextLayer()
        super.init()
        frame = CGRect(x: 0, y: y, width: width, height: 50)
        nameLayer.string = period["NAME"]
        startLayer.string = period["START"]
        endLayer.string = period["END"]
        startLayer.alignmentMode = kCAAlignmentCenter
        endLayer.alignmentMode = kCAAlignmentCenter
        nameLayer.frame = CGRect(x: 15, y: 17, width: width - 10, height: 33)
        startLayer.frame = CGRect(x: 5 + width/3, y: 17, width: width/3 - 10, height: 33)
        endLayer.frame = CGRect(x: 5 + 2*width/3, y: 17, width: width/3 - 10, height: 33)
        let font = UIFont(name: "Arial", size: 12)
        nameLayer.font = font
        startLayer.font = font
        endLayer.font = font
        nameLayer.fontSize = 16
        startLayer.fontSize = 16
        endLayer.fontSize = 16
        let color = UIColor.darkGray.cgColor
        nameLayer.foregroundColor = color
        startLayer.foregroundColor = color
        endLayer.foregroundColor = color
        addSublayer(nameLayer)
        addSublayer(startLayer)
        addSublayer(endLayer)
        nameLayer.contentsScale = UIScreen.main.scale
        startLayer.contentsScale = UIScreen.main.scale
        endLayer.contentsScale = UIScreen.main.scale
    }
    func reuse(period:[String:String]) {
        backgroundColor = nil
        nameLayer.foregroundColor = UIColor.darkGray.cgColor
        startLayer.foregroundColor = UIColor.darkGray.cgColor
        endLayer.foregroundColor = UIColor.darkGray.cgColor
        nameLayer.string = period["NAME"]
        startLayer.string = period["START"]
        endLayer.string = period["END"]
        if period["NAME"]! != " " && period["NAME"]! != "" {
            if selectedDay != nil {
                if getDateInts() == (selectedMonth, selectedDay!, selectedYear) {
                    let startComp = gbtf(text: period)
                    let endComp = getf(text: period)
                    let formatter = DateFormatter()
                    formatter.calendar = Calendar(identifier: .gregorian)
                    formatter.timeZone = TimeZone(identifier: "PST")
                    formatter.dateFormat = "hh:mm aa"
                    let curComp = getf(text: ["END":formatter.string(from: curDate)])
                    if startComp.hour != nil && startComp.minute != nil && endComp.hour != nil && endComp.minute != nil && curComp.hour != nil && curComp.minute != nil {
                        let isAfterStart:Bool = startComp.hour! < curComp.hour! || (startComp.hour! == curComp.hour! && startComp.minute! < curComp.minute!)
                        let isBeforeEnd:Bool = endComp.hour! > curComp.hour! || (endComp.hour! == curComp.hour! && endComp.minute! > curComp.minute!)
                        if isAfterStart && isBeforeEnd {
                            backgroundColor = UIColor(red: 0, green: 0.2, blue: 0.6, alpha: 1).cgColor
                            nameLayer.foregroundColor = UIColor.white.cgColor
                            startLayer.foregroundColor = UIColor.white.cgColor
                            endLayer.foregroundColor = UIColor.white.cgColor
                        }
                    }
                }
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
