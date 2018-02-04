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
    var inset : CGFloat = 0
    var dframe:CGRect {
        if selected {
            return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 115 + inset + 30*CGFloat(getRowCount(forYear: selectedYear, andMonth: selectedMonth)))
        }else {
            return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80 + inset + (transitionPixels ?? 0))
        }
    }
    var transitionPixels:CGFloat?
    var ghsText:CATextLayer = CATextLayer()
    var dateText:CATextLayer = CATextLayer()
    var mtext:CATextLayer
    var ttext:CATextLayer
    var wtext:CATextLayer
    var thtext:CATextLayer
    var frtext:CATextLayer
    var satext:CATextLayer
    var sutext:CATextLayer
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
    func initRowStarter(l:CATextLayer, d:String, x:CGFloat) {
        l.contentsScale = UIScreen.main.scale
        l.font = UIFont.boldSystemFont(ofSize: 15)
        l.fontSize = 15
        l.alignmentMode = kCAAlignmentCenter
        l.foregroundColor = UIColor.white.cgColor
        l.string = d
        let mults = (UIScreen.main.bounds.width-30)/7
        l.frame = CGRect(x: x*mults + 15 , y: 80 + inset, width: mults, height: 30)
    }
    func layoutCalendar() {
        for (num, _) in dateTexts.enumerated() {
            dateTexts[num].foregroundColor = UIColor.white.cgColor
            dateTexts[num].isHidden = true
            dateTexts[num].font = UIFont(name: "Arial", size: 6)!
        }
        let (grid, datePoints) = getGridFrom(width: dframe.width, inset: inset, date: (selectedMonth, 15, selectedYear))
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
    init(inset i : CGFloat) {
        mtext = CATextLayer()
        ttext = CATextLayer()
        wtext = CATextLayer()
        thtext = CATextLayer()
        frtext = CATextLayer()
        satext = CATextLayer()
        sutext = CATextLayer()
        super.init()
        inset = i
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
        ghsText.frame = CGRect(x: 20, y: 5 + inset, width: 300, height: 50)
        ghsText.string = "Grant Bell Schedule"
        
        dateText.font = UIFont(name: "Arial", size: 6)!
        dateText.fontSize = 18
        dateText.foregroundColor = UIColor.white.cgColor
        dateText.frame = CGRect(x: 20, y: 40 + inset, width: 300, height: 50)
        
        initRowStarter(l:mtext, d: "Sun", x: 0)
        initRowStarter(l:ttext, d: "Mon", x: 1)
        initRowStarter(l:wtext, d: "Tues", x: 2)
        initRowStarter(l:thtext, d: "Wed", x: 3)
        initRowStarter(l:frtext, d: "Thurs", x: 4)
        initRowStarter(l:satext, d: "Fri", x: 5)
        initRowStarter(l:sutext, d: "Sat", x: 6)
        
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
        // ctx.setStrokeColor(UIColor.orange.cgColor)
        // ctx.stroke(dframe, width: 2)
        
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
            let gridVal = getGridFrom(width: frame.width, inset: inset, date: (selectedMonth, selectedDay, selectedYear))
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
                ctx.setFillColor(UIColor.init(red: 0.68, green: 0.61, blue: 0, alpha: 1).cgColor)//a guible color
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
