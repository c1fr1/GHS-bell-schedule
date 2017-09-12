//
//  ViewController.swift
//  GHS schedule
//
//  Created by Varas Pendragon on 9/5/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit

var selectedMonth = getDateInts().0
var selectedDay:Int? = getDateInts().1
var selectedYear = getDateInts().2

class ViewController: UIViewController {
    var startPoint:CGPoint?
    var pllayer:PeriodListLayer!
    var clayer:CalendarLayer!
    @IBAction func gesture(_ sender: UIPanGestureRecognizer) {
        if startPoint != nil {
            if sender.numberOfTouches == 0 {
                if startPoint!.x - sender.location(in: view).x < -50 && abs(startPoint!.y - sender.location(in: view).y) < 30 {
                    //left
                    if sender.location(in: view).y < clayer.dframe.height {
                        if clayer.selected {
                            selectedMonth -= 1
                            selectedDay = nil
                            if selectedMonth <= 0 {
                                selectedMonth = 12
                                selectedYear -= 1
                            }
                        }
                    }else {
                        if selectedDay != nil {
                            selectedDay! -= 1
                        }
                    }
                    clayer.setNeedsDisplay()
                }else if startPoint!.x - sender.location(in: view).x > 50 && abs(startPoint!.y - sender.location(in: view).y) < 30 {
                    //right
                    if sender.location(in: view).y < clayer.dframe.height {
                        if clayer.selected {
                            selectedMonth += 1
                            selectedDay = nil
                            if selectedMonth > 12 {
                                selectedMonth = 1
                                selectedYear += 1
                            }
                        }
                    }else {
                        if selectedDay != nil {
                            selectedDay! += 1
                        }
                    }
                }
                startPoint = nil
                updateDisplay()
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
            for (num, bx) in getGridFrom(width: UIScreen.main.bounds.width, date: (selectedMonth, 15, selectedYear)).enumerated() {
                if bx.contains(sender.location(in: view)) {
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
