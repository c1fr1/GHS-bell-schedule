//
//  ScheduleVC.swift
//  GHS schedule
//
//  Created by Varas Pendragon on 11/8/17.
//  Copyright © 2017 4inunison. All rights reserved.
//

import UIKit

class ScheduleVC: CSViewControllerWithKeyboard {
    @IBOutlet var scrollView : UIScrollView!
    @IBOutlet var bottomSpaceConstraint : NSLayoutConstraint!

    override func keyboardWillShow(_ size: CGSize) {
        let viewPoint = scrollView.convert(scrollView.frame.origin, to: view)
        let scrollExtent = view.frame.origin.y + view.frame.size.height - (viewPoint.y + scrollView.frame.size.height)
        if size.height > scrollExtent
        {
            bottomSpaceConstraint?.constant = size.height - scrollExtent
        }
    }

    override func keyboardWillHide() {
        bottomSpaceConstraint?.constant = 0
    }

	@IBAction func tap(_ sender: Any) {
		p1UserClass = self.p1Field.text!
		p2UserClass = self.p2Field.text!
		p3UserClass = self.p3Field.text!
		p4UserClass = self.p4Field.text!
		p5UserClass = self.p5Field.text!
		p6UserClass = self.p6Field.text!
		p7UserClass = self.p7Field.text!
		p8UserClass = self.p8Field.text!
		
		p1UserRoom = self.room1.text!
		p2UserRoom = self.room2.text!
		p3UserRoom = self.room3.text!
		p4UserRoom = self.room4.text!
		p5UserRoom = self.room5.text!
		p6UserRoom = self.room6.text!
		p7UserRoom = self.room7.text!
		p8UserRoom = self.room8.text!
		view.endEditing(true)
	}
	override func viewDidLoad() {
        super.viewDidLoad()

		p1Field.text = p1UserClass
		p2Field.text = p2UserClass
		p3Field.text = p3UserClass
		p4Field.text = p4UserClass
		p5Field.text = p5UserClass
		p6Field.text = p6UserClass
		p7Field.text = p7UserClass
		p8Field.text = p8UserClass
		
		room1.text = p1UserRoom
		room2.text = p2UserRoom
		room3.text = p3UserRoom
		room4.text = p4UserRoom
		room5.text = p5UserRoom
		room6.text = p6UserRoom
		room7.text = p7UserRoom
		room8.text = p8UserRoom
	}
	@IBAction func back(_ sender: Any) {
		dismiss(animated: true) {
			p1UserClass = self.p1Field.text!
			p2UserClass = self.p2Field.text!
			p3UserClass = self.p3Field.text!
			p4UserClass = self.p4Field.text!
			p5UserClass = self.p5Field.text!
			p6UserClass = self.p6Field.text!
			p7UserClass = self.p7Field.text!
			p8UserClass = self.p8Field.text!
			
			p1UserRoom = self.room1.text!
			p2UserRoom = self.room2.text!
			p3UserRoom = self.room3.text!
			p4UserRoom = self.room4.text!
			p5UserRoom = self.room5.text!
			p6UserRoom = self.room6.text!
			p7UserRoom = self.room7.text!
			p8UserRoom = self.room8.text!
		}
	}
	@IBOutlet weak var p1Field: UITextField!
	@IBOutlet weak var p2Field: UITextField!
	@IBOutlet weak var p3Field: UITextField!
	@IBOutlet weak var p4Field: UITextField!
	@IBOutlet weak var p5Field: UITextField!
	@IBOutlet weak var p6Field: UITextField!
	@IBOutlet weak var p7Field: UITextField!
	@IBOutlet weak var p8Field: UITextField!
	
	@IBOutlet weak var room1: UITextField!
	@IBOutlet weak var room2: UITextField!
	@IBOutlet weak var room3: UITextField!
	@IBOutlet weak var room4: UITextField!
	@IBOutlet weak var room5: UITextField!
	@IBOutlet weak var room6: UITextField!
	@IBOutlet weak var room7: UITextField!
	@IBOutlet weak var room8: UITextField!
}
