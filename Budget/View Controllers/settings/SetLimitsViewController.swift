
import UIKit

protocol SetLimitsViewControllerDelegate: class {
    func limilUppied(limit: LimitModel)
    func limitCancelled()
}

class SetLimitsViewController: UIViewController {

    
    @IBOutlet weak var valueTextField: UITextField!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    private var category = ""
    private var regular = false
    private var value = 0.0
    
    weak var delegate: SetLimitsViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryLabel.text = category
        
        valueTextField.keyboardType = .decimalPad
        valueTextField.text = "0" + " " + DataManager.shared.getShortStringCurrency()
        valueTextField.delegate = self
        addToolBarOnKeyboard()
  
        
    }
    
    private func addToolBarOnKeyboard() {
        let textFieldToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
            
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonDidTap))
                done.tintColor = .label
                
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
                
        textFieldToolbar.items = items
        textFieldToolbar.sizeToFit()
                
        valueTextField.inputAccessoryView = textFieldToolbar
    }
    
    
    @objc func doneButtonDidTap()
    {
        let valueTxt = valueTextField.text
        
        guard let unwrappedValueTxt = valueTxt else {return}
        
        if let vDouble = Double(unwrappedValueTxt) {
            value = vDouble
        } else {
              value = 0
        }
  
        valueTextField.resignFirstResponder()
    }
    
    public func setCategory(category: String) {
        self.category = category
    }
    
    @IBAction func regularSwitchValueChanged(_ sender: Any) {
        let refSwitch = sender as! UISwitch
        
        regular = refSwitch.isOn
    }
    
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func applyButtonDidTap(_ sender: Any) {
        if value > 0 {
            let limit = LimitModel(category: category, value: value, regular: regular)
            delegate?.limilUppied(limit: limit)
            dismiss(animated: true, completion: nil)
        } else {
            UserMessenger.shared.showUserMessage(vc: self, message: "Введите корректное значение")
            valueTextField.becomeFirstResponder()
        }
        
    }
    
}

extension SetLimitsViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let txt = textField.text {
            if txt == "" {
                textField.text = "0" + " " + DataManager.shared.getShortStringCurrency()
            } else {
             
                guard let unwrappedValueTxt = textField.text else {return}
                textField.text = unwrappedValueTxt  + " " + DataManager.shared.getShortStringCurrency()
            }
        }
    }
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        let newLength = currentCharacterCount + string.count

        return newLength <= 6
    }
    
    
    
}
