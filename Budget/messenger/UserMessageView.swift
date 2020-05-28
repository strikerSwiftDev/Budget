//
//  UserMessageView.swift
//  Budget
//
//  Created by Anatoliy Anatolyev on 01.04.2020.
//  Copyright © 2020 Anatoliy Anatolyev. All rights reserved.
//

import UIKit
@IBDesignable

class UserMessageView: UIView {

    @IBOutlet weak var label: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
   public func setTextOfMessage(text:String) {
    label.textColor = UIColor.label
        label.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 9
        self.layer.borderWidth = 1
//        layer.borderColor = UIColor.label.cgColor
        layer.borderColor = UIColor.systemGray.cgColor
    }

}
