//
//  GHS_scheduleUITests.swift
//  GHS scheduleUITests
//
//  Created by Varas Pendragon on 10/30/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import XCTest

class GHS_scheduleUITests: XCTestCase {
	override func setUp() {
		super.setUp()
		
		// Put setup code here. This method is called before the invocation of each test method in the class.
		let app = XCUIApplication()
        app.launchEnvironment = [ "UITest": "1" ]
		setupSnapshot(app)
		
		// In UI tests it is usually best to stop immediately when a failure occurs.
		continueAfterFailure = false
		// UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
		app.launch()
		
		// In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testExample() {
		// Use recording to get started writing UI tests.
		// Use XCTAssert and related functions to verify your tests produce the correct results.
		
		let app = XCUIApplication()
        
		XCUIDevice.shared.orientation = .faceUp
		
        // XCUIApplication().alerts["“GHS schedule” Would Like to Send You Notifications"].buttons["Allow"].tap()
        
        // fill out a dummy schedule
        /*
        app.buttons["Reminder Settings"].tap()
        app.buttons["Add Schedule"].tap()
        let tablesQuery = app.tables
        
        func fillScheduleCell(cell : XCUIElement, className : String, room : String) {
            let textField0 = cell.children(matching: .textField).element(boundBy: 0)
            textField0.tap()
            let clearTextButton = tablesQuery/*@START_MENU_TOKEN@*/.buttons["Clear text"]/*[[".cells",".textFields.buttons[\"Clear text\"]",".buttons[\"Clear text\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
            clearTextButton.tap()
            textField0.typeText(className)
            let textField1 = cell.children(matching: .textField).element(boundBy: 1)
            textField1.tap()
            if clearTextButton.exists {
                clearTextButton.tap()
            }
            textField1.typeText(room)
        }
        fillScheduleCell(cell: tablesQuery.children(matching: .cell).element(boundBy: 0), className: "Japanese", room: "B45")
        fillScheduleCell(cell: tablesQuery.children(matching: .cell).element(boundBy: 1), className: "Chemistry", room: "C12")
        fillScheduleCell(cell: tablesQuery.children(matching: .cell).element(boundBy: 2), className: "Accounting", room: "C29")
        fillScheduleCell(cell: tablesQuery.children(matching: .cell).element(boundBy: 3), className: "World Lit", room: "B12")
        fillScheduleCell(cell: tablesQuery.children(matching: .cell).element(boundBy: 4), className: "Photography", room: "B13")
        fillScheduleCell(cell: tablesQuery.children(matching: .cell).element(boundBy: 5), className: "Adv Algebra", room: "C45")
        fillScheduleCell(cell: tablesQuery.children(matching: .cell).element(boundBy: 6), className: "US History", room: "C1")
        fillScheduleCell(cell: tablesQuery.children(matching: .cell).element(boundBy: 7), className: "Health", room: "B27")
        
        app.buttons["Back"].tap()
        app.buttons["Back"].tap() */

        let reminderSettingsElement = XCUIApplication().otherElements.containing(.button, identifier:"Settings").element
        // reminderSettingsElement.swipeRight()
        // reminderSettingsElement.swipeLeft()
        
        snapshot("0 A")
        reminderSettingsElement.swipeLeft()
        snapshot("1 B")
		func tapCoordinate(x xCoordinate: Double, y yCoordinate: Double)
		{
			let normalized = app.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
			let coordinate = normalized.withOffset(CGVector(dx: xCoordinate, dy: yCoordinate))
			coordinate.tap()
		}
		tapCoordinate(x: 10, y: 25)
		snapshot("2 Cal")
		tapCoordinate(x: 10, y: 25)
        
        app.buttons["Settings"].tap()
        snapshot("3 Settings")
        
        app.buttons["Reminders before the period ends"].tap()
        snapshot("4 Reminders")
        let backButton = app.buttons["Back"]
        backButton.tap()
        app.buttons["Add/Edit Schedule"].tap()
        snapshot("5 Schedule")
        
	}
}
