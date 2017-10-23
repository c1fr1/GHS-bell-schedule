//
//  dumbCalenderStuff.swift
//  GHS schedule
//
//  Created by Varas Pendragon on 9/6/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit

var curDate:Date {
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(abbreviation: "PST")!
    let comp = cal.dateComponents(in: cal.timeZone, from: Date())
    return comp.date!
}

func getDateInts() -> (Int, Int, Int) {
    let currentDate = curDate
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "PST")
    dateFormatter.dateStyle = DateFormatter.Style.short
    let dateString = dateFormatter.string(from: currentDate)
    var currentString = ""
    var month:Int?
    var day:Int?
    var year:Int?
    for chr in dateString.characters {
        if chr != "/" {
            currentString += String(chr)
        }else {
            if month == nil  {
                month = Int(currentString)
            }else if day == nil {
                day = Int(currentString)
            }
            currentString = ""
        }
    }
    dateFormatter.dateFormat = "yyyy"
    year = Int(dateFormatter.string(from: currentDate))
    return (month!, day!, year!)
}
func getIntsFor(date:Date) -> (Int, Int, Int) {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "PST")
    dateFormatter.dateStyle = DateFormatter.Style.short
    let dateString = dateFormatter.string(from: date)
    var currentString = ""
    var month:Int?
    var day:Int?
    var year:Int?
    for chr in dateString.characters {
        if chr != "/" {
            currentString += String(chr)
        }else {
            if month == nil  {
                month = Int(currentString)
            }else if day == nil {
                day = Int(currentString)
            }
            currentString = ""
        }
    }
    dateFormatter.dateFormat = "yyyy"
    year = Int(dateFormatter.string(from: date))
    return (month!, day!, year!)
}
func getDate(from:(Int, Int, Int)) -> Date {
    var comps:DateComponents = DateComponents()
    comps.month = from.0
    comps.day = from.1
    comps.year = from.2
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(abbreviation: "PST")!
    let date = cal.date(from: comps)!
    return date
}
func getMonth(from:(Int, Int)) -> String {
    var comps = DateComponents()
    comps.month = from.0
    comps.year = from.1
    var cal = Calendar(identifier: .gregorian)
    cal.timeZone = TimeZone(abbreviation: "PST")!
    let date = cal.date(from: comps)
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM, yyyy"
    return formatter.string(from: date!)
}
func getdayNum(from dateI:(Int, Int, Int)) -> Int {
    let date = getDate(from: dateI)
    
    let daysSince = floor(date.timeIntervalSince1970/(60*60*24))
    var day = (daysSince - floor(daysSince/7)*7) - 3
    if day < 0 {
        day += 7
    }
    return Int(day)
}
func getDayCount(forMonth:Int, andYear:Int) -> Int {
    if forMonth == 1 {//31
        return 31
    }else if  forMonth == 2 {//28 or 29
        if floor(Double(andYear)/4) == Double(andYear)/4 {
            return 29
        }else {
            return 28
        }
    }else if  forMonth == 3 {//31
        return 31
    }else if  forMonth == 4 {//30
        return 30
    }else if  forMonth == 5 {//31
        return 31
    }else if  forMonth == 6 {//30
        return 30
    }else if  forMonth == 7 {//31
        return 31
    }else if  forMonth == 8 {//31
        return 31
    }else if  forMonth == 9 {//30
        return 30
    }else if  forMonth == 10 {//31
        return 31
    }else if  forMonth == 11 {//30
        return 30
    }else if  forMonth == 12 {//31
        return 31
    }
    return 0
}
func getRowCount(forYear:Int, andMonth:Int) -> Int {
    if andMonth == 1 {//31
        if getdayNum(from: (andMonth, 1, forYear)) <= 4 {
            return 5
        }else {
            return 6
        }
    }else if andMonth == 2 {//28 or 29
        if floor(Double(forYear)/4) == Double(forYear)/4 {
            return 5
        }else {
            if getdayNum(from: (andMonth, 1, forYear)) == 0 {
                return 4
            }else {
                return 5
            }
        }
    }else if andMonth == 3 {//31
        if getdayNum(from: (andMonth, 1, forYear)) <= 4 {
            return 5
        }else {
            return 6
        }
    }else if andMonth == 4 {//30
        if getdayNum(from: (andMonth, 1, forYear)) <= 5 {
            return 5
        }else {
            return 6
        }
    }else if andMonth == 5 {//31
        if getdayNum(from: (andMonth, 1, forYear)) <= 4 {
            return 5
        }else {
            return 6
        }
    }else if andMonth == 6 {//30
        if getdayNum(from: (andMonth, 1, forYear)) <= 5 {
            return 5
        }else {
            return 6
        }
    }else if andMonth == 7 {//31
        if getdayNum(from: (andMonth, 1, forYear)) <= 4 {
            return 5
        }else {
            return 6
        }
    }else if andMonth == 8 {//31
        if getdayNum(from: (andMonth, 1, forYear)) <= 4 {
            return 5
        }else {
            return 6
        }
    }else if andMonth == 9 {//30
        if getdayNum(from: (andMonth, 1, forYear)) <= 5 {
            return 5
        }else {
            return 6
        }
    }else if andMonth == 10 {//31
        if getdayNum(from: (andMonth, 1, forYear)) <= 4 {
            return 5
        }else {
            return 6
        }
    }else if andMonth == 11 {//30
        if getdayNum(from: (andMonth, 1, forYear)) <= 5 {
            return 5
        }else {
            return 6
        }
    }else if andMonth == 12 {//31
        if getdayNum(from: (andMonth, 1, forYear)) <= 4 {
            return 5
        }else {
            return 6
        }
    }
    return 0
}
func getGridFrom(width:CGFloat, date:(Int, Int, Int)) -> [CGRect] {
    var currentWeekDay = getdayNum(from: (date.0, 1, date.2))
    var row = 0
    var retval:[CGRect] = []
    let dimension = (width-30)/7
    for _ in 0..<getDayCount(forMonth: date.0, andYear: date.2) {
        retval.append(CGRect(x: 15 + CGFloat(currentWeekDay)*dimension, y: 130 + CGFloat(row)*30, width: dimension, height: 30))
        currentWeekDay += 1
        if currentWeekDay == 7 {
            currentWeekDay = 0
            row += 1
        }
    }
    return retval
}
func getStartTimeFor(period:Int, on:(Int, Int, Int)) -> DateComponents? {
    var comp = DateComponents()
    comp.month = on.0
    comp.day = on.1
    comp.year = on.2
    comp.calendar = Calendar(identifier: .gregorian)
    comp.timeZone = TimeZone(abbreviation: "PST")!
    let stype = schedule![getDate(from: on)]
    let daysInfo = periodInfo![stype!]
    if daysInfo == nil { return nil }
    var ptimeinfo:String = ""
    for (num, info) in daysInfo!.enumerated() {
        if info["NAME"] == "P\(period)" {
            ptimeinfo = daysInfo![num]["START"]!
            break
        }
    }
    if ptimeinfo == "" {
        return nil
    }
    var hourString:String = ""
    var minuteString:String?
    for char in ptimeinfo.characters {
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
func getEndTimeFor(period:Int, on:(Int, Int, Int)) -> DateComponents? {
    var comp = DateComponents()
    comp.month = on.0
    comp.day = on.1
    comp.year = on.2
    comp.calendar = Calendar(identifier: .gregorian)
    comp.timeZone = TimeZone(abbreviation: "PST")!
    let stype = schedule![getDate(from: on)]
    let daysInfo = periodInfo![stype!]
    if daysInfo == nil { return nil }
    var ptimeinfo:String = ""
    for (num, info) in daysInfo!.enumerated() {
        if info["NAME"] == "P\(period)" {
            ptimeinfo = daysInfo![num]["END"]!
            break
        }
    }
    if ptimeinfo == "" {
        return nil
    }
    var hourString:String = ""
    var minuteString:String?
    for char in ptimeinfo.characters {
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
func gbtf(text:[String:String]) -> DateComponents {
    var comp = DateComponents()
    comp.calendar = Calendar(identifier: .gregorian)
    comp.timeZone = TimeZone(abbreviation: "PST")!
    var ptimeinfo = text["START"]!
    var hourString:String = ""
    var minuteString:String?
    for char in ptimeinfo.characters {
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
func getf(text:[String:String]) -> DateComponents {
    var comp = DateComponents()
    comp.calendar = Calendar(identifier: .gregorian)
    comp.timeZone = TimeZone(abbreviation: "PST")!
    var ptimeinfo = text["END"]!
    var hourString:String = ""
    var minuteString:String?
    for char in ptimeinfo.characters {
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
