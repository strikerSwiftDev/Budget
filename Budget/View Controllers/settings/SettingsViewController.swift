
import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var currencyTXT: UITextField!
    
    @IBOutlet weak var deleteDataBtn: UIButton!
    
    @IBOutlet weak var firstWeekdaySelector: UISegmentedControl!
    
    @IBOutlet weak var uiStyleSegmentControl: UISegmentedControl!
    
    private var stringCurrency = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationItem.largeTitleDisplayMode = .never
        
        currencyTXT.keyboardType = .default
        currencyTXT.autocapitalizationType = .words
        currencyTXT.delegate = self
        
        updateVisualData()
        
    }

    func updateVisualData() {
        stringCurrency = DataManager.shared.getShortStringCurrency()
        
        currencyTXT.text = stringCurrency
        firstWeekdaySelector.selectedSegmentIndex = DataManager.shared.getFierstWeekDay().rawValue
        uiStyleSegmentControl.selectedSegmentIndex = DataManager.shared.getUserinterfaceStyleIndex()
        
    }
    
    @IBAction func uiStyleSegmentControlChanged(_ sender: Any) {
        DataManager.shared.setUserInterfaceStyleByIndex(index: uiStyleSegmentControl.selectedSegmentIndex)
    }
    

    @IBAction func FirstWeekdaySelectorChanged(_ sender: Any) {
        let firstWeekDay = FirstWeekDay(rawValue: firstWeekdaySelector.selectedSegmentIndex) ?? FirstWeekDay.monday
        DataManager.shared.setFirstWeekayTo(weekday: firstWeekDay)
    }
    
    @IBAction func resetBtnTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Сброс", message: nil, preferredStyle: .actionSheet)
        
        let hardResetAct = UIAlertAction(title: "Полный сброс", style: .default) { (act) in
            self.showDeleteAllDataAlert()
        }
        
        let deletePaymentsAct = UIAlertAction(title: "Удалить платежи", style: .default) { (act) in
            self.showDeleteAllPaymentsAlert()
        }
        
        let cancelAct = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(hardResetAct)
        alert.addAction(deletePaymentsAct)
        alert.addAction(cancelAct)
        
        hardResetAct.setValue(UIColor.red, forKey: "titleTextColor")
        deletePaymentsAct.setValue(UIColor.red, forKey: "titleTextColor")
        cancelAct.setValue(UIColor.label, forKey: "titleTextColor")
        
        
        present(alert, animated: true, completion: nil)

    }
    
    
    
    
    
    private func showDeleteAllPaymentsAlert() {
        let alert = UIAlertController(title: "Внимание!", message: "Это дейсвие навсегда удалит все сохраненные платежи", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "ОТМЕНА", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "УДАЛИТЬ", style: .default) { (_) in
            
            CoreDataManager.shared.deleteAllPayments()
            UserMessenger.shared.showUserMessage(vc: self, message: "Платежи удалены")
        }
        
        okAction.setValue(UIColor.red, forKey: "titleTextColor")
        cancelAction.setValue(UIColor.label, forKey: "titleTextColor")
        

        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showDeleteAllDataAlert() {
        
        let alert = UIAlertController(title: "Внимание!", message: "Это дейсвие навсегда удалит ваши данные", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "ОТМЕНА", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "СБРОСИТЬ", style: .default) { (_) in
            
            CoreDataManager.shared.deleteAllPayments()
            DataManager.shared.resetSimpleData()
            LimitsManager.shared.reset()
            self.updateVisualData()
            UserMessenger.shared.showUserMessage(vc: self, message: "Данные сброшены")
            
        }
        
        okAction.setValue(UIColor.red, forKey: "titleTextColor")
        cancelAction.setValue(UIColor.label, forKey: "titleTextColor")
        

        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    private func enableUserInteraction() {
        deleteDataBtn.isEnabled = true
        deleteDataBtn.alpha = 1
    }
    
    private func disableUserInteraction() {
        deleteDataBtn.isEnabled = false
        deleteDataBtn.alpha = 0.5
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

