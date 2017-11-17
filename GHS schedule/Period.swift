//
//  Period.swift
//  GHS schedule
//
//  Created by Varas Pendragon on 11/9/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit

var p1Info:(String?, TimeInterval?, TimeInterval?, String?) = (nil, nil, nil, nil)
var p1UserClass:String? {
	get {
		if p1Info.0 != nil {
			return p1Info.0
		}
		let def = groupDefaults.value(forKey: Keys.P1CLASSKEY) as? String
		if def != nil {
			return def
		}else {
			return "Period 1"
		}
	}
	set {
		var n = newValue
		if newValue == "Period 1" {
			n = nil
		}
		p1Info.0 = n
		groupDefaults.set(n, forKey: Keys.P1CLASSKEY)
	}
}
var p1BeforeClassDuration:TimeInterval? {
	get {
		if p1Info.1 != nil {
			return p1Info.1
		}
		return groupDefaults.value(forKey: Keys.P1DURATIONKEY) as? TimeInterval
	}
	set {
		p1Info.1 = newValue
		groupDefaults.set(newValue, forKey: Keys.P1DURATIONKEY)
	}
}
var p1EndClassDuration:TimeInterval? {
	get {
		if p1Info.2 != nil {
			return p1Info.2
		}
		return groupDefaults.value(forKey: Keys.P1DURATIONEKEY) as? TimeInterval
	}
	set {
		p1Info.2 = newValue
		groupDefaults.set(newValue, forKey: Keys.P1DURATIONEKEY)
	}
}
var p1UserRoom:String? {
	get {
		if p1Info.3 != nil {
			return p1Info.3
		}
		return groupDefaults.value(forKey: Keys.P1ROOMKEY) as? String
	}
	set {
		var n = newValue
		if newValue == "" {
			n = nil
		}
		p1Info.3 = n
		groupDefaults.set(n, forKey: Keys.P1ROOMKEY)
	}
}
//ENDEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEF
var p2Info:(String?, TimeInterval?, TimeInterval?, String?) = (nil, nil, nil, nil)
var p2UserClass:String? {
	get {
		if p2Info.0 != nil {
			return p2Info.0
		}
		let def = groupDefaults.value(forKey: Keys.P2CLASSKEY) as? String
		if def != nil {
			return def
		}else {
			return "Period 2"
		}
	}
	set {
		var n = newValue
		if newValue == "" {
			n = nil
		}
		p2Info.0 = n
		groupDefaults.set(n, forKey: Keys.P2CLASSKEY)
	}
}
var p2BeforeClassDuration:TimeInterval? {
	get {
		if p2Info.1 != nil {
			return p2Info.1
		}
		return groupDefaults.value(forKey: Keys.P2DURATIONKEY) as? TimeInterval
	}
	set {
		p2Info.1 = newValue
		groupDefaults.set(newValue, forKey: Keys.P2DURATIONKEY)
	}
}
var p2EndClassDuration:TimeInterval? {
	get {
		if p2Info.2 != nil {
			return p2Info.2
		}
		return groupDefaults.value(forKey: Keys.P2DURATIONEKEY) as? TimeInterval
	}
	set {
		p2Info.2 = newValue
		groupDefaults.set(newValue, forKey: Keys.P2DURATIONEKEY)
	}
}
var p2UserRoom:String? {
	get {
		if p2Info.3 != nil {
			return p2Info.3
		}
		return groupDefaults.value(forKey: Keys.P2ROOMKEY) as? String
	}
	set {
		var n = newValue
		if newValue == "" {
			n = nil
		}
		p2Info.3 = n
		groupDefaults.set(n, forKey: Keys.P2ROOMKEY)
	}
}
//ENDEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEF
var p3Info:(String?, TimeInterval?, TimeInterval?, String?) = (nil, nil, nil, nil)
var p3UserClass:String? {
	get {
		if p3Info.0 != nil {
			return p3Info.0
		}
		let def = groupDefaults.value(forKey: Keys.P3CLASSKEY) as? String
		if def != nil {
			return def
		}else {
			return "Period 3"
		}
	}
	set {
		var n = newValue
		if newValue == "" {
			n = nil
		}
		p3Info.0 = n
		groupDefaults.set(n, forKey: Keys.P3CLASSKEY)
	}
}
var p3BeforeClassDuration:TimeInterval? {
	get {
		if p3Info.1 != nil {
			return p3Info.1
		}
		return groupDefaults.value(forKey: Keys.P3DURATIONKEY) as? TimeInterval
	}
	set {
		p3Info.1 = newValue
		groupDefaults.set(newValue, forKey: Keys.P3DURATIONKEY)
	}
}
var p3EndClassDuration:TimeInterval? {
	get {
		if p3Info.2 != nil {
			return p3Info.2
		}
		return groupDefaults.value(forKey: Keys.P3DURATIONEKEY) as? TimeInterval
	}
	set {
		p3Info.2 = newValue
		groupDefaults.set(newValue, forKey: Keys.P3DURATIONEKEY)
	}
}
var p3UserRoom:String? {
	get {
		if p3Info.3 != nil {
			return p3Info.3
		}
		return groupDefaults.value(forKey: Keys.P3ROOMKEY) as? String
	}
	set {
		var n = newValue
		if newValue == "" {
			n = nil
		}
		p3Info.3 = n
		groupDefaults.set(n, forKey: Keys.P3ROOMKEY)
	}
}
//ENDEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEF
var p4Info:(String?, TimeInterval?, TimeInterval?, String?) = (nil, nil, nil, nil)
var p4UserClass:String? {
	get {
		if p4Info.0 != nil {
			return p4Info.0
		}
		let def = groupDefaults.value(forKey: Keys.P4CLASSKEY) as? String
		if def != nil {
			return def
		}else {
			return "Period 4"
		}
	}
	set {
		var n = newValue
		if newValue == "" {
			n = nil
		}
		p4Info.0 = n
		groupDefaults.set(n, forKey: Keys.P4CLASSKEY)
	}
}
var p4BeforeClassDuration:TimeInterval? {
	get {
		if p4Info.1 != nil {
			return p4Info.1
		}
		return groupDefaults.value(forKey: Keys.P4DURATIONKEY) as? TimeInterval
	}
	set {
		p4Info.1 = newValue
		groupDefaults.set(newValue, forKey: Keys.P4DURATIONKEY)
	}
}
var p4EndClassDuration:TimeInterval? {
	get {
		if p4Info.2 != nil {
			return p4Info.2
		}
		return groupDefaults.value(forKey: Keys.P4DURATIONEKEY) as? TimeInterval
	}
	set {
		p4Info.2 = newValue
		groupDefaults.set(newValue, forKey: Keys.P4DURATIONEKEY)
	}
}
var p4UserRoom:String? {
	get {
		if p4Info.3 != nil {
			return p4Info.3
		}
		return groupDefaults.value(forKey: Keys.P4ROOMKEY) as? String
	}
	set {
		var n = newValue
		if newValue == "" {
			n = nil
		}
		p4Info.3 = n
		groupDefaults.set(n, forKey: Keys.P4ROOMKEY)
	}
}
//ENDEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEF
var p5Info:(String?, TimeInterval?, TimeInterval?, String?) = (nil, nil, nil, nil)
var p5UserClass:String? {
	get {
		if p5Info.0 != nil {
			return p5Info.0
		}
		let def = groupDefaults.value(forKey: Keys.P5CLASSKEY) as? String
		if def != nil {
			return def
		}else {
			return "Period 5"
		}
	}
	set {
		var n = newValue
		if newValue == "" {
			n = nil
		}
		p5Info.0 = n
		groupDefaults.set(n, forKey: Keys.P5CLASSKEY)
	}
}
var p5BeforeClassDuration:TimeInterval? {
	get {
		if p5Info.1 != nil {
			return p5Info.1
		}
		return groupDefaults.value(forKey: Keys.P5DURATIONKEY) as? TimeInterval
	}
	set {
		p5Info.1 = newValue
		groupDefaults.set(newValue, forKey: Keys.P5DURATIONKEY)
	}
}
var p5EndClassDuration:TimeInterval? {
	get {
		if p5Info.2 != nil {
			return p5Info.2
		}
		return groupDefaults.value(forKey: Keys.P5DURATIONEKEY) as? TimeInterval
	}
	set {
		p5Info.2 = newValue
		groupDefaults.set(newValue, forKey: Keys.P5DURATIONEKEY)
	}
}
var p5UserRoom:String? {
	get {
		if p5Info.3 != nil {
			return p5Info.3
		}
		return groupDefaults.value(forKey: Keys.P5ROOMKEY) as? String
	}
	set {
		var n = newValue
		if newValue == "" {
			n = nil
		}
		p5Info.3 = n
		groupDefaults.set(n, forKey: Keys.P5ROOMKEY)
	}
}
//ENDEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEF
var p6Info:(String?, TimeInterval?, TimeInterval?, String?) = (nil, nil, nil, nil)
var p6UserClass:String? {
	get {
		if p6Info.0 != nil {
			return p6Info.0
		}
		let def = groupDefaults.value(forKey: Keys.P6CLASSKEY) as? String
		if def != nil {
			return def
		}else {
			return "Period 6"
		}
	}
	set {
		var n = newValue
		if newValue == "" {
			n = nil
		}
		p6Info.0 = n
		groupDefaults.set(n, forKey: Keys.P6CLASSKEY)
	}
}
var p6BeforeClassDuration:TimeInterval? {
	get {
		if p6Info.1 != nil {
			return p6Info.1
		}
		return groupDefaults.value(forKey: Keys.P6DURATIONKEY) as? TimeInterval
	}
	set {
		p6Info.1 = newValue
		groupDefaults.set(newValue, forKey: Keys.P6DURATIONKEY)
	}
}
var p6EndClassDuration:TimeInterval? {
	get {
		if p6Info.2 != nil {
			return p6Info.2
		}
		return groupDefaults.value(forKey: Keys.P6DURATIONEKEY) as? TimeInterval
	}
	set {
		p6Info.2 = newValue
		groupDefaults.set(newValue, forKey: Keys.P6DURATIONEKEY)
	}
}
var p6UserRoom:String? {
	get {
		if p6Info.3 != nil {
			return p6Info.3
		}
		return groupDefaults.value(forKey: Keys.P6ROOMKEY) as? String
	}
	set {
		var n = newValue
		if newValue == "" {
			n = nil
		}
		p6Info.3 = n
		groupDefaults.set(n, forKey: Keys.P6ROOMKEY)
	}
}
//ENDEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEF
var p7Info:(String?, TimeInterval?, TimeInterval?, String?) = (nil, nil, nil, nil)
var p7UserClass:String? {
	get {
		if p7Info.0 != nil {
			return p7Info.0
		}
		let def = groupDefaults.value(forKey: Keys.P7CLASSKEY) as? String
		if def != nil {
			return def
		}else {
			return "Period 7"
		}
	}
	set {
		var n = newValue
		if newValue == "" {
			n = nil
		}
		p7Info.0 = n
		groupDefaults.set(n, forKey: Keys.P7CLASSKEY)
	}
}
var p7BeforeClassDuration:TimeInterval? {
	get {
		if p7Info.1 != nil {
			return p7Info.1
		}
		return groupDefaults.value(forKey: Keys.P7DURATIONKEY) as? TimeInterval
	}
	set {
		p7Info.1 = newValue
		groupDefaults.set(newValue, forKey: Keys.P7DURATIONKEY)
	}
}
var p7EndClassDuration:TimeInterval? {
	get {
		if p7Info.2 != nil {
			return p7Info.2
		}
		return groupDefaults.value(forKey: Keys.P7DURATIONEKEY) as? TimeInterval
	}
	set {
		p7Info.2 = newValue
		groupDefaults.set(newValue, forKey: Keys.P7DURATIONEKEY)
	}
}
var p7UserRoom:String? {
	get {
		if p7Info.3 != nil {
			return p7Info.3
		}
		return groupDefaults.value(forKey: Keys.P7ROOMKEY) as? String
	}
	set {
		var n = newValue
		if newValue == "" {
			n = nil
		}
		p7Info.3 = n
		groupDefaults.set(n, forKey: Keys.P7ROOMKEY)
	}
}
//ENDEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEF
var p8Info:(String?, TimeInterval?, TimeInterval?, String?) = (nil, nil, nil, nil)
var p8UserClass:String? {
	get {
		if p8Info.0 != nil {
			return p8Info.0
		}
		let def = groupDefaults.value(forKey: Keys.P8CLASSKEY) as? String
		if def != nil {
			return def
		}else {
			return "Period 8"
		}
	}
	set {
		var n = newValue
		if newValue == "" {
			n = nil
		}
		p8Info.0 = n
		groupDefaults.set(n, forKey: Keys.P8CLASSKEY)
	}
}
var p8BeforeClassDuration:TimeInterval? {
	get {
		if p8Info.1 != nil {
			return p8Info.1
		}
		return groupDefaults.value(forKey: Keys.P8DURATIONKEY) as? TimeInterval
	}
	set {
		p8Info.1 = newValue
		groupDefaults.set(newValue, forKey: Keys.P8DURATIONKEY)
	}
}
var p8EndClassDuration:TimeInterval? {
	get {
		if p8Info.2 != nil {
			return p8Info.2
		}
		return groupDefaults.value(forKey: Keys.P8DURATIONEKEY) as? TimeInterval
	}
	set {
		p8Info.2 = newValue
		groupDefaults.set(newValue, forKey: Keys.P8DURATIONEKEY)
	}
}
var p8UserRoom:String? {
	get {
		if p8Info.3 != nil {
			return p8Info.3
		}
		return groupDefaults.value(forKey: Keys.P8ROOMKEY) as? String
	}
	set {
		var n = newValue
		if newValue == "" {
			n = nil
		}
		p8Info.3 = n
		groupDefaults.set(n, forKey: Keys.P8ROOMKEY)
	}
}
//ENDEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEF
var flexInfo:(TimeInterval?, TimeInterval?) = (nil, nil)
var flexBeforeClassDuration:TimeInterval? {
	get {
		if flexInfo.0 != nil {
			return flexInfo.0
		}
		return groupDefaults.value(forKey: Keys.FLEXDURATIONKEY) as? TimeInterval
	}
	set {
		flexInfo.0 = newValue
		groupDefaults.set(newValue, forKey: Keys.FLEXDURATIONKEY)
	}
}
var flexEndClassDuration:TimeInterval? {
	get {
		if flexInfo.1 != nil {
			return flexInfo.1
		}
		return groupDefaults.value(forKey: Keys.FLEXDURATIONEKEY) as? TimeInterval
	}
	set {
		flexInfo.1 = newValue
		groupDefaults.set(newValue, forKey: Keys.FLEXDURATIONEKEY)
	}
}
//ENDEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEF
var lunchInfo:(TimeInterval?, TimeInterval?) = (nil, nil)
var lunchBeforeClassDuration:TimeInterval? {
	get {
		if lunchInfo.0 != nil {
			return lunchInfo.0
		}
		return groupDefaults.value(forKey: Keys.LUNCHDURATIONKEY) as? TimeInterval
	}
	set {
		lunchInfo.0 = newValue
		groupDefaults.set(newValue, forKey: Keys.LUNCHDURATIONKEY)
	}
}
var lunchEndClassDuration:TimeInterval? {
	get {
		if lunchInfo.1 != nil {
			return lunchInfo.1
		}
		return groupDefaults.value(forKey: Keys.LUNCHDURATIONEKEY) as? TimeInterval
	}
	set {
		lunchInfo.1 = newValue
		groupDefaults.set(newValue, forKey: Keys.LUNCHDURATIONEKEY)
	}
}

enum PeriodTypeE {
	init(with:String) {
		if with == "P1" {
			self = .period1
		}else if with == "P2" {
			self = .period2
		}else if with == "P3" {
			self = .period3
		}else if with == "P4" {
			self = .period4
		}else if with == "P5" {
			self = .period5
		}else if with == "P6" {
			self = .period6
		}else if with == "P7" {
			self = .period7
		}else if with == "P8" {
			self = .period8
		}else if with == "FLEX" {
			self = .flex
		}else if with == "LUNCH" {
			self = .lunch
		}else {
			self = .special
		}
	}
	case period1, period2, period3, period4, period5, period6, period7, period8
	case flex
	case lunch
	case special
}
func getAttrib(ind:Int, fer:PeriodTypeE) -> (String?, TimeInterval?, TimeInterval?, String?) {
	switch fer {
	case .period1:
		if ind == 0 {
			return (p1UserClass, nil, nil, nil)
		}else if ind == 1 {
			return (nil, p1BeforeClassDuration, nil, nil)
		}else if ind == 2 {
			return (nil, nil, p1EndClassDuration, nil)
		}else if ind == 3 {
			return (nil, nil, nil, p1UserRoom)
		}
	case .period2:
		if ind == 0 {
			return (p2UserClass, nil, nil, nil)
		}else if ind == 1 {
			return (nil, p2BeforeClassDuration, nil, nil)
		}else if ind == 2 {
			return (nil, nil, p2EndClassDuration, nil)
		}else if ind == 3 {
			return (nil, nil, nil, p2UserRoom)
		}
	case .period3:
		if ind == 0 {
			return (p3UserClass, nil, nil, nil)
		}else if ind == 1 {
			return (nil, p3BeforeClassDuration, nil, nil)
		}else if ind == 2 {
			return (nil, nil, p3EndClassDuration, nil)
		}else if ind == 3 {
			return (nil, nil, nil, p3UserRoom)
		}
	case .period4:
		if ind == 0 {
			return (p4UserClass, nil, nil, nil)
		}else if ind == 1 {
			return (nil, p4BeforeClassDuration, nil, nil)
		}else if ind == 2 {
			return (nil, nil, p4EndClassDuration, nil)
		}else if ind == 3 {
			return (nil, nil, nil, p4UserRoom)
		}
	case .period5:
		if ind == 0 {
			return (p5UserClass, nil, nil, nil)
		}else if ind == 1 {
			return (nil, p5BeforeClassDuration, nil, nil)
		}else if ind == 2 {
			return (nil, nil, p5EndClassDuration, nil)
		}else if ind == 3 {
			return (nil, nil, nil, p5UserRoom)
		}
	case .period6:
		if ind == 0 {
			return (p6UserClass, nil, nil, nil)
		}else if ind == 1 {
			return (nil, p6BeforeClassDuration, nil, nil)
		}else if ind == 2 {
			return (nil, nil, p6EndClassDuration, nil)
		}else if ind == 3 {
			return (nil, nil, nil, p6UserRoom)
		}
	case .period7:
		if ind == 0 {
			return (p7UserClass, nil, nil, nil)
		}else if ind == 1 {
			return (nil, p7BeforeClassDuration, nil, nil)
		}else if ind == 2 {
			return (nil, nil, p7EndClassDuration, nil)
		}else if ind == 3 {
			return (nil, nil, nil, p7UserRoom)
		}
	case .period8:
		if ind == 0 {
			return (p8UserClass, nil, nil, nil)
		}else if ind == 1 {
			return (nil, p8BeforeClassDuration, nil, nil)
		}else if ind == 2 {
			return (nil, nil, p8EndClassDuration, nil)
		}else if ind == 3 {
			return (nil, nil, nil, p8UserRoom)
		}
	case .flex:
		if ind == 0 {
			return (nil, nil, nil, nil)
		}else if ind == 1 {
			return (nil, flexBeforeClassDuration, nil, nil)
		}else if ind == 2 {
			return (nil, nil, flexEndClassDuration, nil)
		}
	case .lunch:
		if ind == 0 {
			return (nil, nil, nil, nil)
		}else if ind == 1 {
			return (nil, lunchBeforeClassDuration, nil, nil)
		}else if ind == 2 {
			return (nil, nil, lunchEndClassDuration, nil)
		}
	default:
		return (nil, nil, nil, nil)
	}
	return (nil, nil, nil, nil)
}
