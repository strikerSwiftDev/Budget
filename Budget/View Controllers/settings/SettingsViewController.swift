
import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var currencyTXT: UITextField!
    
    @IBOutlet weak var deleteDataBtn: UIButton!
    @IBOutlet weak var deletePaymentsBtn: UIButton!
    
    
    
    private var stringCurrency = ""
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationItem.largeTitleDisplayMode = .never
        
        stringCurrency = DataManager.shared.getShortStringCurrency()
        
        currencyTXT.keyboardType = .default
        currencyTXT.autocapitalizationType = .words
        currencyTXT.text = stringCurrency
        currencyTXT.delegate = self
        
        
        
    }

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
    
    private func enableUserInteraction() {
        deleteDataBtn.isEnabled = true
        deletePaymentsBtn.isEnabled = true
        deleteDataBtn.alpha = 1
        deletePaymentsBtn.alpha = 1
    }
    
    private func disableUserInteraction() {
        deleteDataBtn.isEnabled = false
        deletePaymentsBtn.isEnabled = false
        deleteDataBtn.alpha = 0.5
        deletePaymentsBtn.alpha = 0.5
    }
    
    
    
}

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        enableUserInteraction()
        
        if let newCurrency = currencyTXT.text, !newCurrency.isEmpty {
            
            DataManager.shared.saveNewShortStringCurrency(currency: newCurrency)
            stringCurrency = newCurrency
            
        }
        
        currencyTXT.text = stringCurrency
        

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        disableUserInteraction()
        
        textField.text = ""
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.count ?? 0
        let newLength = currentCharacterCount + string.count
        
        if string == " " {
            return false
        }
        
        return newLength <= 3
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currencyTXT.resignFirstResponder()
    }
    
   
}

