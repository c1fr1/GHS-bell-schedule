//
//  ViewController.swift
//  GHS schedule
//
//  Created by Varas Pendragon on 9/5/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit

var translationCal:CGFloat?
var translationPeriods:CGFloat?

var selectedMonth = getDateInts().0
var selectedDay:Int? = getDateInts().1
var selectedYear = getDateInts().2

class ViewController: UIViewController {
    
    var startPoint:CGPoint?
    var pllayer:PeriodListLayer!
    var clayer:CalendarLayer!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func gesture(_ sender: UIPanGestureRecognizer) {//check back later for updates.
        if startPoint != nil {
            if sender.numberOfTouches == 0 {
                translationCal = nil
                translationPeriods = nil
                if startPoint!.x - sender.location(in: view).x < -50 {
                    //left
                    if startPoint!.y < clayer.dframe.height {
                        if clayer.selected {
                            selectedMonth -= 1
                            selectedDay = nil
                            if selectedMonth <= 0 {
                                selectedMonth = 12
                                selectedYear -= 1
                            }
                            for c in clayer.dateTexts {
                                c.opacity = 0
                                c.frame.origin.x -= view.frame.width
                            }
                        }
                    }else {
                        for p in pllayer.periods {
                            p.isHidden = true
                            p.frame.origin.x -= view.frame.width
                        }
                        if selectedDay != nil {
                            selectedDay! -= 1
                        }
                    }
                }else if startPoint!.x - sender.location(in: view).x > 50 {
                    //right
                    if startPoint!.y < clayer.dframe.height {
                        if clayer.selected {
                            selectedMonth += 1
                            selectedDay = nil
                            if selectedMonth > 12 {
                                selectedMonth = 1
                                selectedYear += 1
                            }
                            for c in clayer.dateTexts {
                                c.opacity = 0
                                c.frame.origin.x += view.frame.width
                            }
                        }
                    }else {
                        for p in pllayer.periods {
                            p.isHidden = true
                            p.frame.origin.x += view.frame.width
                        }
                        if selectedDay != nil {
                            selectedDay! += 1
                        }
                    }
                }
                updateDisplay()
                if startPoint!.y < clayer.dframe.height {
                    timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false, block: {(_:Timer) in
                        self.clayer.layoutCalendar()
                        self.timer =  Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false, block: {(_:Timer) in
                            for c in self.clayer.dateTexts {
                                c.opacity = 1
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
                startPoint = nil
            }else {
                if clayer.selected {
                    if startPoint!.y < clayer.dframe.height {
                        translationCal = (sender.location(in: view).x - startPoint!.x)*3
                    }else {
                        translationPeriods = (sender.location(in: view).x - startPoint!.x)*3
                    }
                    updateDisplay()
                    clayer.layoutCalendar()
                }else {
                    translationPeriods = (sender.location(in: view).x - startPoint!.x)*3
                    updateDisplay()
                }
            }
        }else {
            startPoint = sender.location(in: view)
        }
    }
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        if sender.location(in: view).y < 100 {
            clayer.selected = !clayer.selected
        }
        if clayer.selected {
            let pnt = CGPoint(x: sender.location(in: view).x, y: sender.location(in: view).y + 10)
            for (num, bx) in getGridFrom(width: UIScreen.main.bounds.width, date: (selectedMonth, 15, selectedYear)).enumerated() {
                if bx.contains(pnt) {
                    if selectedDay != nil {
                        clayer.dateTexts[selectedDay! - 1].font = UIFont(name: "Arial", size: 6)!
                        clayer.dateTexts[selectedDay! - 1].foregroundColor = UIColor.white.cgColor
                    }
                    selectedDay = num + 1
                    clayer.dateTexts[num].font = UIFont.boldSystemFont(ofSize: 18)
                    clayer.dateTexts[num].foregroundColor = UIColor.lightGray.cgColor
                }
            }
        }
        pt = sender.location(in: view)
        updateDisplay()
        clayer.layoutCalendar()
    }
    var timer:Timer!
    func start(_:Timer) {
        updateDisplay()
        clayer.layoutCalendar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func awakeFromNib() {
        clayer = CalendarLayer()
        view.layer.addSublayer(clayer)
        clayer.frame = view.frame
        clayer.contentsScale = UIScreen.main.scale
        clayer.setNeedsDisplay()
        pllayer  = PeriodListLayer()
        view.layer.addSublayer(pllayer)
        pllayer.frame = CGRect(x: 0, y: clayer.dframe.height, width: view.frame.width, height: view.frame.height)
        pllayer.contentsScale = UIScreen.main.scale
        pllayer.setNeedsDisplay()
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(start(_:)), userInfo: nil, repeats: false)
        
    }
    func updateDisplay() {
        pllayer.setup()
        
        pllayer.frame = CGRect(x: 0, y: clayer.dframe.height, width: view.frame.width, height: view.frame.height)
        pllayer.frame.origin.y = clayer.dframe.height
        pllayer.setNeedsDisplay()
        clayer.setNeedsDisplay()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}//003399
