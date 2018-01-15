//
//  calenderLayer.swift
//  GHS schedule
//
//  Created by C1FR1 on 9/5/17.
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
    var mtext:CATextLayer = CalendarLayer.getrowStarter(d: "Sun", x: 0)
    var ttext:CATextLayer = CalendarLayer.getrowStarter(d: "Mon", x: 1)
    var wtext:CATextLayer = CalendarLayer.getrowStarter(d: "Tues", x: 2)
    var thtext:CATextLayer = CalendarLayer.getrowStarter(d: "Wed", x: 3)
    var frtext:CATextLayer = CalendarLayer.getrowStarter(d: "Thurs", x: 4)
    var satext:CATextLayer = CalendarLayer.getrowStarter(d: "Fri", x: 5)
    var sutext:CATextLayer = CalendarLayer.getrowStarter(d: "Sat", x: 6)
    var daysOff:[CGPoint] = []
    var dateTexts:[CATextLayer] = {() -> [CATextLayer] in
        var retval:[CATextLayer] = []
        for x in 1...31 {
            retval.append(CATextLayer())
            retval.last!.font = UIFont(name: "Arial", size: 12)!
            retval.last!.fontSize = 15
            retval.last!.alignmentMode = kCAAlignmentCenter
            retval.last!.foregroundColor = UIColor.white.cgColor
            retval.last!.string = "\(x)"
            retval.last!.contentsScale = UIScreen.main.scale
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
        let (grid, datePoints) = getGridFrom(width: dframe.width, date: (selectedMonth, 15, selectedYear))
        daysOff = datePoints
        for (num, box) in grid.enumerated() {//set frame
            if translationCal != nil {
                dateTexts[num].frame = CGRect(x: box.origin.x + translationCal!, y: box.origin.y, width: box.width, height: box.height)
                dateTexts[num].isHidden = false
            }else {
                dateTexts[num].frame = box
                dateTexts[num].isHidden = false
            }
        }
    }
    override init() {
        super.init()
        for _ in dateTexts {
            addSublayer(dateText)
        }
        addSublayer(ghsText)
        addSublayer(dateText)
        ghsText.contentsScale = UIScreen.main.scale
        dateText.contentsScale = UIScreen.main.scale
        
        ghsText.font = UIFont(name: "Arial", size: 6)!
        ghsText.fontSize = 27
        ghsText.foregroundColor = UIColor.white.cgColor
        ghsText.frame = CGRect(x: 20, y: 25, width: 300, height: 50)
        ghsText.string = "Grant Bell Schedule"
        
        dateText.font = UIFont(name: "Arial", size: 6)!
        dateText.fontSize = 18
        dateText.foregroundColor = UIColor.white.cgColor
        dateText.frame = CGRect(x: 20, y: 60, width: 300, height: 50)
        
        mtext.contentsScale = UIScreen.main.scale
        ttext.contentsScale = UIScreen.main.scale
        wtext.contentsScale = UIScreen.main.scale
        thtext.contentsScale = UIScreen.main.scale
        frtext.contentsScale = UIScreen.main.scale
        satext.contentsScale = UIScreen.main.scale
        sutext.contentsScale = UIScreen.main.scale
        
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
        dateTexts[selectedDay - 1].font = UIFont.boldSystemFont(ofSize: 18)
        dateTexts[selectedDay - 1].foregroundColor = UIColor.lightGray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(in ctx: CGContext) {
        ctx.setFillColor(UIColor(red: 0, green: 0.2, blue: 0.6, alpha: 1).cgColor)
        ctx.fill(dframe)
        
        let date = getDate(from: (selectedMonth, selectedDay, selectedYear))
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.full
        let strg = formatter.string(from: date)
        dateText.string = strg
        
        for (num, _) in dateTexts.enumerated() {
            if selected {
                if num < getDayCount(forMonth: selectedMonth, andYear: selectedYear) {
                    dateTexts[num].isHidden = false
                }
            }else {
                dateTexts[num].isHidden = true
            }
        }
        if selected {
            let gridVal = getGridFrom(width: frame.width, date: (selectedMonth, selectedDay, selectedYear))
            var frm = gridVal.0[selectedDay - 1]
            var transl:CGFloat = 0
            if translationCal != nil {
                transl = translationCal!
            }
            ctx.setStrokeColor(UIColor.white.cgColor)
            ctx.setLineWidth(2)
            for datePos in gridVal.1 {
                ctx.move(to: CGPoint(x: datePos.x + 13 + transl, y: datePos.y + 9))
                ctx.addArc(center: CGPoint(x: datePos.x + transl, y: datePos.y + 9), radius: 13, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: false)
                
                ctx.drawPath(using: .stroke)
            }
            
            //0.68
            ctx.move(to: CGPoint(x: frm.midX + 15 + transl, y: frm.origin.y + 9))
            ctx.addArc(center: CGPoint(x: frm.midX + transl, y: frm.origin.y + 9), radius: 15, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: false)
            ctx.setFillColor(UIColor.gray.cgColor)
            ctx.fillPath()
            
            let tdInts = getIntsFor(date: Date())
            if selectedMonth == tdInts.0 {
                frm = gridVal.0[tdInts.1 - 1]
                ctx.move(to: CGPoint(x: frm.midX + 15 + transl, y: frm.origin.y + 9))
                ctx.addArc(center: CGPoint(x: frm.midX + transl, y: frm.origin.y + 9), radius: 15, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: false)
                ctx.setFillColor(UIColor.init(red: 0.68, green: 0.68, blue: 0, alpha: 1).cgColor)
                ctx.fillPath()
            }
        }
        
    }
}
var pt = CGPoint(x:0, y:0)

func getStartTimeFor(period: Period, on:(Int, Int, Int)) -> DateComponents? {
	var comp = DateComponents()
	comp.month = on.0
	comp.day = on.1
	comp.year = on.2
	comp.calendar = Calendar(identifier: .gregorian)
	comp.timeZone = TimeZone(abbreviation: "PST")!
	let stype = schedule[getDate(from: on)]
	let daysInfo = periodInfo[stype!]
	if daysInfo == nil { return nil }
	var ptimeinfo:String = ""
	for (num, info) in daysInfo!.enumerated() {
        if info["NAME"] == period.shortName {
            ptimeinfo = daysInfo![num]["START"]!
            break
        }
	}
	if ptimeinfo == "" {
		return nil
	}
	var hourString:String = ""
	var minuteString:String?
	for char in ptimeinfo {
		if minuteString != nil {
			if char == "p" || char == "P" {
				if Int(hourString)! < 12 {
					hourString = String(Int(hourString)! + 12)
				}
				break
			}else if char == "a" || char == "A" {
				break
			}else {
				minuteString! += String(char)
			}
		}else {
			if char == ":" {
				minuteString = ""
			}else {
				hourString += String(char)
			}
		}
	}
	if minuteString != nil {
		comp.hour = Int(hourString)
		comp.minute = Int(minuteString!)
	}
	return comp
}
func getEndTimeFor(period:Period, on:(Int, Int, Int)) -> DateComponents? {
	var comp = DateComponents()
	comp.month = on.0
	comp.day = on.1
	comp.year = on.2
	comp.calendar = Calendar(identifier: .gregorian)
	comp.timeZone = TimeZone(abbreviation: "PST")!
	let stype = schedule[getDate(from: on)]
	let daysInfo = periodInfo[stype!]
	if daysInfo == nil { return nil }
	var ptimeinfo:String = ""
	for (num, info) in daysInfo!.enumerated() {
        if info["NAME"] == period.shortName {
            ptimeinfo = daysInfo![num]["END"]!
            break
        }
	}
	if ptimeinfo == "" {
		return nil
	}
	var hourString:String = ""
	var minuteString:String?
	for char in ptimeinfo {
		if minuteString != nil {
			if char == "p" || char == "P" {
				if Int(hourString)! < 12 {
					hourString = String(Int(hourString)! + 12)
				}
				break
			}else if char == "a" || char == "A" {
				break
			}else {
				minuteString! += String(char)
			}
		}else {
			if char == ":" {
				minuteString = ""
			}else {
				hourString += String(char)
			}
		}
	}
	if minuteString != nil {
		comp.hour = Int(hourString)
		comp.minute = Int(minuteString!)
	}
	return comp
}
