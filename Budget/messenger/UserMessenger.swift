//
//  UserMessenger.swift
//  Budget
//
//  Created by Anatoliy Anatolyev on 01.04.2020.
//  Copyright © 2020 Anatoliy Anatolyev. All rights reserved.
//

import Foundation
import UIKit

class UserMessenger {
    
    static var shared = UserMessenger()
    
    
    private var messageView = Bundle.main.loadNibNamed("UserMessageView", owner: nil, options: nil)?.first as! UserMessageView
    
    
    func showUserMessage(vc: UIViewController, message: String) {
        messageView.alpha = 0
        messageView.setTextOfMessage(text: message)
        
        vc.view.addSubview(messageView)
        messageView.center.x = vc.view.center.x
        messageView.center.y = vc.view.center.y - 200
        
         UIView.animate(withDuration: 0.33, animations: {
            self.messageView.alpha = 1
                }) { (_) in
                    
                    UIView.animate(withDuration: 0.5,  animations: {
                        self.messageView.alpha = 0.8
                    }) { (_) in
                        UIView.animate(withDuration: 0.5, animations: {
                            self.messageView.alpha = 1
                        }) { (_) in
                            UIView.animate(withDuration: 0.33, animations: {
                                self.messageView.alpha = 0
                            }) { (_) in
                                self.messageView.removeFromSuperview()
                            }
                        }
                    }
                    
                    
                }
        
    }
    
    
}
