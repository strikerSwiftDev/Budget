//
//  SettingsViewController.swift
//  Budget
//
//  Created by Anatoliy Anatolyev on 22.03.2020.
//  Copyright © 2020 Anatoliy Anatolyev. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationItem.largeTitleDisplayMode = .never
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func deleteAllPaymentsBtnTapped(_ sender: Any) {
        showDeleteAllPaymentsAlert()
        
    }
    
    
    @IBAction func resetBtnTapped(_ sender: Any) {
        showDeleteAllDataAlert()
    }
    
    private func showDeleteAllPaymentsAlert() {
        let alert = UIAlertController(title: "Внимание!", message: "Это дейсвие навсегда удалит все сохраненные платежи", preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "ОТМЕНА", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "УДАЛИТЬ", style: .cancel) { (_) in
            
            CoreDataManager.shared.deleteAllPayments()
            UserMessenger.shared.showUserMessage(vc: self, message: "Платежи удалены")
        }
        
        cancelAction.setValue(UIColor.label, forKey: "titleTextColor")
        okAction.setValue(UIColor.red, forKey: "titleTextColor")

        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showDeleteAllDataAlert() {
        
        let alert = UIAlertController(title: "Внимание!", message: "Это дейсвие навсегда удалит ваши данные", preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "ОТМЕНА", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "СБРОСИТЬ", style: .cancel) { (_) in
            DataManager.shared.resetSimpleData()
            UserMessenger.shared.showUserMessage(vc: self, message: "Данные сброшены")
        }
        
        cancelAction.setValue(UIColor.label, forKey: "titleTextColor")
        okAction.setValue(UIColor.red, forKey: "titleTextColor")

        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
