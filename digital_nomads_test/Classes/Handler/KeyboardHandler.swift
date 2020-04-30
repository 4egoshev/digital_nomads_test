//
//  KeyboardHandler.swift
//  digital_nomads_test
//
//  Created by Александр Чегошев on 30.04.2020.
//  Copyright © 2020 Aleksandr Chegoshev. All rights reserved.
//

import UIKit

class KeyboardHandler: NSObject {
    private weak var mainView: UIView?
    private weak var scrollView: UIScrollView?
    
    private var notificationCenter: NotificationCenter {
        return NotificationCenter.default
    }
    
    override init() {
        super.init()
        subscribeToKeyboardNotifications()
    }
    
    deinit {
        unsubscribeFromKeyboardNotifications()
    }
    
    func setup(scrollView: UIScrollView,
               mainView: UIView?) {
        self.scrollView = scrollView
        self.mainView = mainView
        
        addTap()
    }
}

// MARK: Private
private extension KeyboardHandler {
    func subscribeToKeyboardNotifications() {
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillMove(_:)),
                                       name: UIResponder.keyboardWillShowNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillMove(_:)),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        notificationCenter.removeObserver(self,
                                          name: UIResponder.keyboardWillShowNotification,
                                          object: nil)
        notificationCenter.removeObserver(self,
                                          name: UIResponder.keyboardWillHideNotification,
                                          object: nil)
    }
    
    func addTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.cancelsTouchesInView = false
        scrollView?.addGestureRecognizer(tapGesture)
    }
}

// MARK: Actions
private extension KeyboardHandler {
    @objc func keyboardWillMove(_ notification: Notification) {
        if notification.name == UIResponder.keyboardWillShowNotification {
            if let userInfo = notification.userInfo {
                let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                
                var bottomPadding: CGFloat = 0
                if #available(iOS 11.0, *) {
                    bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
                }
                
                scrollView?.contentInset.bottom = keyboardFrame.height - bottomPadding
            }
        }
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView?.contentInset = .zero
        }
    }
    
    @objc func viewTapped() {
        mainView?.endEditing(true)
    }
}
