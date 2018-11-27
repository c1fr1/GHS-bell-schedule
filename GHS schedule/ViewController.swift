//
//  ViewController.swift
//  GHS schedule
//
//  Created by C1FR1 on 9/5/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit
import UserNotifications

var translationCal:CGFloat?
var translationPeriods:CGFloat?

var selectedMonth = getDateInts().0
var selectedDay = getDateInts().1
var selectedYear = getDateInts().2
var mainVC:ViewController?

class ViewController: UIViewController {
    @IBOutlet weak var notificationsButton: UIButton!
    
    var startPoint:CGPoint?
    var lastPoint:CGPoint?
    var pllayer:PeriodListLayer!
    var clayer:CalendarLayer!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func gesture(_ sender: UIPanGestureRecognizer) {//check back later for updates.
        
        if startPoint != nil {
            if sender.numberOfTouches == 0 {
                var monthChanged = false
                translationCal = nil
                translationPeriods = nil
                if startPoint!.x - sender.location(in: view).x < -50 {
                    //left
                    if startPoint!.y < clayer.dframe.height {//month
                        if clayer.selected {
                            selectedMonth -= 1
                            if selectedMonth <= 0 {
                                selectedMonth = 12
                                selectedYear -= 1
                            }
                            let dayCount = getDayCount(forMonth: selectedMonth, andYear: selectedYear)
                            if selectedDay > dayCount {
                                selectedDay = dayCount
                            }
                            monthChanged = true
                            for c in clayer.dateTexts {
                                c.opacity = 0
                                c.frame.origin.x -= view.frame.width
                            }
                        }
                    }else {//day
                        for p in pllayer.periods {
                            p.isHidden = true
                            p.frame.origin.x -= view.frame.width
                        }
                        selectedDay -= 1
                        if selectedDay <= 0 {
                            selectedMonth -= 1
                            monthChanged = true
                            for c in clayer.dateTexts {//newStuff
                                c.opacity = 0
                                c.frame.origin.x -= view.frame.width
                            }
                            if selectedMonth <= 0 {
                                selectedYear -= 1
                            }
                            selectedDay = getDayCount(forMonth: selectedMonth, andYear: selectedYear)
                        }
                    }
                }else if startPoint!.x - sender.location(in: view).x > 50 {
                    //right
                    if startPoint!.y < clayer.dframe.height {//month
                        if clayer.selected {
                            selectedMonth += 1
                            if selectedMonth > 12 {
                                selectedMonth = 1
                                selectedYear += 1
                            }
                            let dayCount = getDayCount(forMonth: selectedMonth, andYear: selectedYear)
                            if selectedDay > dayCount {
                                selectedDay = dayCount
                            }
                            monthChanged = true
                            for c in clayer.dateTexts {
                                c.opacity = 0
                                c.frame.origin.x += view.frame.width
                            }
                        }
                    }else {//day
                        for p in pllayer.periods {
                            p.isHidden = true
                            p.frame.origin.x += view.frame.width
                        }
                        selectedDay += 1
                        if selectedDay > getDayCount(forMonth: selectedMonth, andYear: selectedYear) {
                            selectedMonth += 1
                            monthChanged = true
                            for c in clayer.dateTexts {//newStuff
                                c.opacity = 0
                                c.frame.origin.x += view.frame.width
                            }
                            if selectedMonth > 12 {
                                selectedMonth = 1
                                selectedYear += 1
                            }
                            selectedDay = 1
                        }
                    }
                }
                clayer.layoutCalendar()//test
                updateDisplay()
                if monthChanged {
                    timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false, block: {(_:Timer) in
                        self.clayer.layoutCalendar()
                        self.updateDisplay()
                        self.timer =  Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false, block: {(_:Timer) in
                            for c in self.clayer.dateTexts {
                                c.opacity = 1
                            }
                            for p in self.pllayer.periods {
                                p.isHidden = false
                            }
                        })
                    })
                }else {
                    timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false, block: {(_:Timer) in
                        self.updateDisplay()
                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false, block: {(_:Timer) in
                            for p in self.pllayer.periods {
                                p.isHidden = false
                            }
                        })
                    })
                }
                var layer = periodInfo[pllayer.scheduleType]
                if (layer == nil) {
                    layer = periodInfo["NO-SCHOOL"]
                }
                if (layer!.count) > 0 {
                    if pllayer.periods[layer!.count - 1].frame.origin.y <= view.frame.height - 220 {
                        let offset:CGFloat = pllayer.periods[periodInfo[pllayer.scheduleType]!.count - 1].frame.origin.y * -1 + view.frame.height - 220
                        for layer in pllayer.periods {
                            layer.frame.origin.y += offset
                        }
                    }
                }
                if pllayer.periods[0].frame.origin.y >= 50 {
                    let offset:CGFloat = pllayer.periods[0].frame.origin.y * -1 + 50
                    for layer in pllayer.periods {
                        layer.frame.origin.y += offset
                    }
                }
                startPoint = nil
                lastPoint = nil
            }else {//not the last event in the swipe
                //start in process swiping
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                if clayer.selected {
                    if startPoint!.y < clayer.dframe.height {
                        translationCal = (sender.location(in: view).x - startPoint!.x)*2
                    }else {
                        translationPeriods = (sender.location(in: view).x - startPoint!.x)*2
                    }
                    updateDisplay()
                    clayer.layoutCalendar()
                }else {
                    let yoffset:CGFloat = sender.location(in: view!).y - lastPoint!.y
                    translationPeriods = (sender.location(in: view).x - startPoint!.x)*2
                    updateDisplay()
                    for layer in pllayer.periods {
                        layer.frame.origin.y += yoffset
                    }
                }
                CATransaction.commit()
                //end in process swiping
                lastPoint = sender.location(in: view)
            }
        }else {
            startPoint = sender.location(in: view)
            lastPoint = startPoint
        }
    }
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        if sender.location(in: view).y < 100 {
            clayer.selected = !clayer.selected
        }
        if clayer.selected {
            let pnt = CGPoint(x: sender.location(in: view).x, y: sender.location(in: view).y + 10)
            for (num, bx) in getGridFrom(width: UIScreen.main.bounds.width, inset: topLayoutGuide.length, date: (selectedMonth, 15, selectedYear)).0.enumerated() {
                if bx.contains(pnt) {
                    clayer.dateTexts[selectedDay - 1].font = UIFont(name: "Arial", size: 6)!
                    clayer.dateTexts[selectedDay - 1].foregroundColor = UIColor.white.cgColor
                    selectedDay = num + 1
                    clayer.dateTexts[num].font = UIFont.boldSystemFont(ofSize: 18)
                    clayer.dateTexts[num].foregroundColor = UIColor.lightGray.cgColor
                }
            }
        }
        pt = sender.location(in: view)
        updateDisplay()
        clayer.layoutCalendar()
        notificationsButton.isHidden = clayer.selected
    }
    var timer:Timer!
	
    @objc func start(_:Timer) {
        updateDisplay()
        clayer.layoutCalendar()
    }
	
    func setupLayers() {
        pllayer  = PeriodListLayer()
        view.layer.addSublayer(pllayer)
        clayer = CalendarLayer(inset : topLayoutGuide.length)
        view.layer.addSublayer(clayer.backgroundLayer)
        view.layer.addSublayer(clayer)
        clayer.frame = view.frame
        clayer.contentsScale = UIScreen.main.scale
        clayer.setNeedsDisplay()
        pllayer.frame = CGRect(x: 0, y: clayer.dframe.height, width: view.frame.width, height: view.frame.height)
        pllayer.contentsScale = UIScreen.main.scale
        pllayer.setNeedsDisplay()
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(start(_:)), userInfo: nil, repeats: false)
        mainVC = self
    }

    private var setupDone = false
    override func viewDidLayoutSubviews() {
        // we have to wait till the layout guides are in place before we can layout the layers
        super.viewDidLayoutSubviews()
        if setupDone == false {
            setupLayers()
            setupDone = true
        }
        view.bringSubview(toFront: notificationsButton)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateDisplay()
    }
    func updateDisplay() {
        pllayer.setup()
        
        pllayer.frame = CGRect(x: 0, y: clayer.dframe.height, width: view.frame.width, height: view.frame.height)
        pllayer.frame.origin.y = clayer.dframe.height
        //fix cal
        pllayer.setNeedsDisplay()
        pllayer.header.setNeedsDisplay()
        clayer.setNeedsDisplay()
    }
}
