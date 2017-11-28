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
        
        let reminderSettingsElement = XCUIApplication().otherElements.containing(.button, identifier:"Reminder Settings").element
        reminderSettingsElement.swipeRight()
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
        
        XCUIApplication().buttons["Reminder Settings"].tap()
        snapshot("3 Settings")
        
        app.buttons["Before the period ends"].tap()
        snapshot("4 Reminders")
        let backButton = app.buttons["Back"]
        backButton.tap()
        app.buttons["Add Schedule"].tap()
        snapshot("5 Schedule")
        
	}
}
