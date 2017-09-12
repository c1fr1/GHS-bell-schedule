//
//  calenderLayer.swift
//  GHS schedule
//
//  Created by Varas Pendragon on 9/5/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit

class CalendarLayer:CALayer {
    var selected:Bool = false
    var dframe:CGRect {
        if selected {
            return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 135 + 30*CGFloat(getRowCount(forYear: selectedYear, andMonth: selectedMonth)))
        }else {
            if transitionPixels != nil {
                return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100 + transitionPixels!)
            }else {
                return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
            }
        }
    }
    var transitionPixels:CGFloat?
    var ghsText:CATextLayer = CATextLayer()
    var dateText:CATextLayer = CATextLayer()
    var mtext:CATextLayer = CalendarLayer.getrowStarter(d: "Mon", x: 0)
    var ttext:CATextLayer = CalendarLayer.getrowStarter(d: "Tues", x: 1)
    var wtext:CATextLayer = CalendarLayer.getrowStarter(d: "Wed", x: 2)
    var thtext:CATextLayer = CalendarLayer.getrowStarter(d: "Thurs", x: 3)
    var frtext:CATextLayer = CalendarLayer.getrowStarter(d: "Fri", x: 4)
    var satext:CATextLayer = CalendarLayer.getrowStarter(d: "Sat", x: 5)
    var sutext:CATextLayer = CalendarLayer.getrowStarter(d: "Sun", x: 6)
    var dateTexts:[CATextLayer] = {() -> [CATextLayer] in
        var retval:[CATextLayer] = []
        for x in 1...31 {
            retval.append(CATextLayer())
            retval.last!.font = UIFont(name: "Arial", size: 12)!
            retval.last!.fontSize = 15
            retval.last!.alignmentMode = kCAAlignmentCenter
            retval.last!.foregroundColor = UIColor.white.cgColor
            retval.last!.string = "\(x)"
        }
        return retval
    }()
    public static func getrowStarter(d:String, x:CGFloat) -> CATextLayer {
        let retVal = CATextLayer()
        retVal.font = UIFont.boldSystemFont(ofSize: 15)
        retVal.fontSize = 15
        retVal.alignmentMode = kCAAlignmentCenter
        retVal.foregroundColor = UIColor.white.cgColor
        retVal.string = d
        let mults = (UIScreen.main.bounds.width-30)/7
        retVal.frame = CGRect(x: x*mults + 15 , y: 100, width: mults, height: 30)
        return retVal
    }
    func layoutCalendar() {
        for (num, _) in dateTexts.enumerated() {
            dateTexts[num].foregroundColor = UIColor.white.cgColor
            dateTexts[num].isHidden = true
            dateTexts[num].font = UIFont(name: "Arial", size: 6)!
        }
        let grid = getGridFrom(width: dframe.width, date: (selectedMonth, 15, selectedYear))
        for (num, box) in grid.enumerated() {//set frame
            dateTexts[num].frame = box
            dateTexts[num].isHidden = false
        }
    }
    override init() {
        super.init()
        for _ in dateTexts {
            addSublayer(dateText)
        }
        addSublayer(ghsText)
        addSublayer(dateText)
        
        ghsText.font = UIFont(name: "Arial", size: 6)!
        ghsText.fontSize = 27
        ghsText.foregroundColor = UIColor.white.cgColor
        ghsText.frame = CGRect(x: 20, y: 25, width: 300, height: 50)
        ghsText.string = "Grant Bell Schedule"
        
        dateText.font = UIFont(name: "Arial", size: 6)!
        dateText.fontSize = 18
        dateText.foregroundColor = UIColor.white.cgColor
        dateText.frame = CGRect(x: 20, y: 60, width: 300, height: 50)
        
        addSublayer(mtext)
        addSublayer(ttext)
        addSublayer(wtext)
        addSublayer(thtext)
        addSublayer(frtext)
        addSublayer(satext)
        addSublayer(sutext)
        
        layoutCalendar()
        for l in dateTexts {
            addSublayer(l)
        }
        dateTexts[selectedDay! - 1].font = UIFont.boldSystemFont(ofSize: 18)
        dateTexts[selectedDay! - 1].foregroundColor = UIColor.lightGray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(in ctx: CGContext) {
        ctx.setFillColor(UIColor(red: 0, green: 0.2, blue: 0.6, alpha: 1).cgColor)
        ctx.fill(dframe)
        
        if selectedDay != nil {
            let date = getDate(from: (selectedMonth, selectedDay!, selectedYear))
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.full
            let strg = formatter.string(from: date)
            dateText.string = strg
        }
        
        layoutCalendar()
        for (num, _) in dateTexts.enumerated() {
            if selected {
                dateTexts[num].opacity = 1
            }else {
                dateTexts[num].opacity = 0
            }
        }
        if selectedDay != nil && selected {
            ctx.move(to: CGPoint(x: dateTexts[selectedDay! - 1].frame.midX + 15, y: dateTexts[selectedDay! - 1].frame.origin.y + 9))
            ctx.addArc(center: CGPoint(x: dateTexts[selectedDay! - 1].frame.midX, y: dateTexts[selectedDay! - 1].frame.origin.y + 9), radius: 15, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: false)
            ctx.setFillColor(UIColor.black.cgColor)
            ctx.fillPath()
        }
        
    }
}
var pt = CGPoint(x:0, y:0)
