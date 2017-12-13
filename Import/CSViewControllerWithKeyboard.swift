//
//  CSViewControllerWithKeyboard.swift
//  SaySomethinginWelsh
//
//  Created by Jeffrey R Lewis on 4/27/16.
//  Copyright © 2016 Catana Software. All rights reserved.
//

import UIKit

open class CSViewControllerWithKeyboard: UIViewController
{
    override open func viewDidLoad()
    {
        super.viewDidLoad()

        registerKeyboard()
    }

    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }

    private func registerKeyboard()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(cs_keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cs_keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc internal func cs_keyboardWillShow(_ notification : Notification)
    {
        if let info = notification.userInfo,
           let sizeObject = info[UIKeyboardFrameEndUserInfoKey] as? NSValue
        {
            let kbSize = sizeObject.cgRectValue.size
            let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue ?? 0.5
            keyboardWillShow(kbSize)
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
            
        }
        else
        {
            NSLog("Keyboard has no size!")
        }
    }

    internal func keyboardWillShow(_ size : CGSize)
    {
        // placeholder
    }

    // TODO: can we just use the UIKeyboardWillChangeFrameNotification notification, and have only one hander??  No, because keyboardWillChange isn't called after rotation!
    // So, not sure when that should be used.

    @objc internal func cs_keyboardWillHide(_ notification : Notification)
    {
        let info = notification.userInfo
        let duration = (info?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue ?? 0.5
        keyboardWillHide()
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    internal func keyboardWillHide()
    {
        // placeholder
    }
}
