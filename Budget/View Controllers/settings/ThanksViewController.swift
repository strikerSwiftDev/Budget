//
//  ThanksViewController.swift
//  Budget
//
//  Created by Anatoliy Anatolyev on 06.04.2020.
//  Copyright © 2020 Anatoliy Anatolyev. All rights reserved.
//

import UIKit

class ThanksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationItem.largeTitleDisplayMode = .never
    }
    

    
    @IBAction func rateUsBtnDidTap(_ sender: Any) {
        UserMessenger.shared.showUserMessage(vc: self, message: "rate")
    }
    
    @IBAction func donate1dollarBtnDidTap(_ sender: Any) {
        UserMessenger.shared.showUserMessage(vc: self, message: "1 dollar")
    }
    
    @IBAction func donate5dollarsBtnDidTap(_ sender: Any) {
        UserMessenger.shared.showUserMessage(vc: self, message: "5 dollar")
    }
    
    @IBAction func donate10dollarsDidTap(_ sender: Any) {
        UserMessenger.shared.showUserMessage(vc: self, message: "10 dollar")
    }
    
    
}
