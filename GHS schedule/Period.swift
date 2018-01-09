//
//  Period.swift
//  GHS schedule
//
//  Created by Varas Pendragon on 11/9/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit

enum Period : Int {
    case period1 = 0
    case period2
    case period3
    case period4
    case period5
    case period6
    case period7
    case period8
    case flex
    case lunch
}

func <(a : Period, b : Period) -> Bool {
    return a.rawValue < b.rawValue
}

extension Period : Strideable {
    typealias Stride = Int
    func distance(to other: Period) -> Period.Stride {
        return other.rawValue - rawValue
    }
    
    func advanced(by n: Period.Stride) -> Period {
        if let p = Period(rawValue: rawValue + n) {
            return p
        }
        return .lunch
    }
}

extension Period {
    init?(shortName sn : String)
    {
        switch sn {
        case "P1": self = .period1
        case "P2": self = .period2
        case "P3": self = .period3
        case "P4": self = .period4
        case "P5": self = .period5
        case "P6": self = .period6
        case "P7": self = .period7
        case "P8": self = .period8
        case "FLEX": self = .flex
        case "LUNCH": self = .lunch
        default: return nil
        }
    }
    var shortName : String {
        switch self {
        case .flex: return "FLEX"
        case .lunch: return "LUNCH"
        default:
            return "P\(rawValue + 1)"
        }
    }
    var defaultName : String
    {
        switch self {
        case .flex: return "Flex"
        case .lunch: return "Lunch"
        default:
            return "Period \(rawValue + 1)"
        }
    }
    static let keys = [Keys.P1KEY, Keys.P2KEY, Keys.P3KEY, Keys.P4KEY, Keys.P5KEY, Keys.P6KEY, Keys.P7KEY, Keys.P8KEY, Keys.FLEXKEY, Keys.LUNCHKEY]
    var key : String
    {
        return Period.keys[rawValue]
    }
    var nameKey : String {
        return "\(key)CLASS"
    }
    var durationKey : String {
        return "\(key)DURATION"
    }
    var durationEnabledKey : String {
        return "\(key)DURENABLED"
    }
    var endDurationKey : String {
        return "\(key)DURATIONEND"
    }
    var endDurationEnabledKey : String {
        return "\(key)EDURENABLED"
    }
    var roomKey : String {
        return "\(key)ROOM"
    }
}

class PeriodInfo {
    var period : Period
    var shortName : String {
        return period.shortName
    }
    var _name : String?
    var _beforeDuration : TimeInterval?
    var _beforeEnabled : Bool?
    var _endDuration : TimeInterval?
    var _endEnabled : Bool?
    var room : String?

    init(period p : Period, name n : String? = nil, beforeDuration b : TimeInterval? = nil, beforeEnabled be : Bool? = nil, endDuration e : TimeInterval? = nil, endEnabled ee : Bool? = nil, room r : String? = nil) {
        period = p
        _name = n
        _beforeDuration = b
        _beforeEnabled = be
        _endDuration = e
        _endEnabled = ee
        room = r
    }

    class var initialPeriodInfo : [Period : PeriodInfo] {
        return [
            .period1 : PeriodInfo(period: .period1),
            .period2 : PeriodInfo(period: .period2),
            .period3 : PeriodInfo(period: .period3),
            .period4 : PeriodInfo(period: .period4),
            .period5 : PeriodInfo(period: .period5),
            .period6 : PeriodInfo(period: .period6),
            .period7 : PeriodInfo(period: .period7),
            .period8 : PeriodInfo(period: .period8),
            .flex    : PeriodInfo(period: .flex),
            .lunch   : PeriodInfo(period: .lunch)
        ]
    }
    class var rangeOfPeriodsWithRooms : CountableClosedRange<Period> {
        return .period1 ... .period8
    }

    var name : String {
        get {
            if let nm = _name {
                return nm
            }
            if let nm = groupDefaults.value(forKey: period.nameKey) as? String {
                _name = nm
                return nm
            }
            return period.defaultName
        }
        set(n) {
            _name = n
            groupDefaults.set(n, forKey: period.nameKey)
        }
    }
    
    static let defaultDuration : TimeInterval = 10 * 60

    var beforeDuration : TimeInterval {
        get {
            if let duration = _beforeDuration
            {
                return duration
            }
            if let duration = groupDefaults.value(forKey: period.durationKey) as? TimeInterval {
                _beforeDuration = duration
                return duration
            }
            return PeriodInfo.defaultDuration
        }
        set(duration) {
            _beforeDuration = duration
            groupDefaults.set(duration, forKey: period.durationKey)
        }
    }

    var beforeEnabled : Bool {
        get {
            if let enabled = _beforeEnabled
            {
                return enabled
            }
            if let enabled = groupDefaults.value(forKey: period.durationEnabledKey) as? Bool {
                _beforeEnabled = enabled
                return enabled
            }
            return false
        }
        set(enabled) {
            _beforeEnabled = enabled
            groupDefaults.set(enabled, forKey: period.durationEnabledKey)
        }
    }

    var endDuration : TimeInterval {
        get {
            if let duration = _endDuration
            {
                return duration
            }
            if let duration = groupDefaults.value(forKey: period.endDurationKey) as? TimeInterval {
                _endDuration = duration
                return duration
            }
            return PeriodInfo.defaultDuration
        }
        set(duration) {
            _endDuration = duration
            groupDefaults.set(duration, forKey: period.endDurationKey)
        }
    }

    var endEnabled : Bool {
        get {
            if let enabled = _endEnabled
            {
                return enabled
            }
            if let enabled = groupDefaults.value(forKey: period.endDurationEnabledKey) as? Bool {
                _endEnabled = enabled
                return enabled
            }
            return false
        }
        set(enabled) {
            _endEnabled = enabled
            groupDefaults.set(enabled, forKey: period.endDurationEnabledKey)
        }
    }
}

var periodsInfo : [Period : PeriodInfo] = PeriodInfo.initialPeriodInfo

func periodName(fromShortName shortName : String) -> String {
    if let info = periodsInfo.values.first(where: { $0.shortName == shortName }) {
        return info.name
    }
    return shortName
}
