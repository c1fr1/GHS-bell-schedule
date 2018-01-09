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
    var name : CachedValue<String>
    var beforeDuration : CachedValue<TimeInterval>
    var beforeEnabled : CachedValue<Bool>
    var endDuration : CachedValue<TimeInterval>
    var endEnabled : CachedValue<Bool>
    var room : CachedValue<String>

    static let defaultDuration : TimeInterval = 10 * 60

    init(period p : Period /* , name n : String? = nil, beforeDuration b : TimeInterval? = nil, beforeEnabled be : Bool? = nil, endDuration e : TimeInterval? = nil, endEnabled ee : Bool? = nil, room r : String? = nil */) {
        period = p
        name = CachedValue<String>(key : period.nameKey, default : period.defaultName)
        beforeDuration = CachedValue<TimeInterval>(key: period.durationKey, default: PeriodInfo.defaultDuration)
        beforeEnabled = CachedValue<Bool>(key: period.durationEnabledKey, default: false)
        endDuration = CachedValue<TimeInterval>(key: period.endDurationKey, default: PeriodInfo.defaultDuration)
        endEnabled = CachedValue<Bool>(key: period.endDurationEnabledKey, default: false)
        room = CachedValue<String>(key: period.roomKey, default: "")
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
}

var periodsInfo : [Period : PeriodInfo] = PeriodInfo.initialPeriodInfo

func periodName(fromShortName shortName : String) -> String {
    if let info = periodsInfo.values.first(where: { $0.shortName == shortName }) {
        return info.name.value
    }
    return shortName
}

class CachedValue<V> {
    var key : String
    var dflt : V
    var _value : V?

    init(key k : String, default d : V) {
        key = k
        dflt = d
    }
    
    var value : V {
        get {
            if let v = _value
            {
                return v
            }
            if let v = groupDefaults.value(forKey: key) as? V {
                _value = v
                return v
            }
            return dflt
        }
        set(v) {
            _value = v
            groupDefaults.set(v, forKey: key)
        }
    }
}
