//
//  dumbCalenderStuff.swift
//  GHS schedule
//
//  Created by Varas Pendragon on 9/6/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit

func getDateInts() -> (Int, Int, Int) {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
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
func getDate(from:(Int, Int, Int)) -> Date {
    var comps:DateComponents = DateComponents()
    comps.month = from.0
    comps.day = from.1
    comps.year = from.2
    let date = NSCalendar.current.date(from: comps)!
    return date
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
    }else if  andMonth == 2 {//28 or 29
        if floor(Double(forYear)/4) == Double(forYear)/4 {
            return 5
        }else {
            if getdayNum(from: (andMonth, 1, forYear)) == 0 {
                return 4
            }else {
                return 5
            }
        }
    }else if  andMonth == 3 {//31
        if getdayNum(from: (andMonth, 1, forYear)) <= 4 {
            return 5
        }else {
            return 6
        }
    }else if  andMonth == 4 {//30
        if getdayNum(from: (andMonth, 1, forYear)) <= 5 {
            return 5
        }else {
            return 6
        }
    }else if  andMonth == 5 {//31
        if getdayNum(from: (andMonth, 1, forYear)) <= 4 {
            return 5
        }else {
            return 6
        }
    }else if  andMonth == 6 {//30
        if getdayNum(from: (andMonth, 1, forYear)) <= 5 {
            return 5
        }else {
            return 6
        }
    }else if  andMonth == 7 {//31
        if getdayNum(from: (andMonth, 1, forYear)) <= 4 {
            return 5
        }else {
            return 6
        }
    }else if  andMonth == 8 {//31
        if getdayNum(from: (andMonth, 1, forYear)) <= 4 {
            return 5
        }else {
            return 6
        }
    }else if  andMonth == 9 {//30
        if getdayNum(from: (andMonth, 1, forYear)) <= 5 {
            return 5
        }else {
            return 6
        }
    }else if  andMonth == 10 {//31
        if getdayNum(from: (andMonth, 1, forYear)) <= 4 {
            return 5
        }else {
            return 6
        }
    }else if  andMonth == 11 {//30
        if getdayNum(from: (andMonth, 1, forYear)) <= 5 {
            return 5
        }else {
            return 6
        }
    }else if  andMonth == 12 {//31
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

