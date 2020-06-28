
import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet weak var txt: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
//    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var subcategoryPicker: UIPickerView!
    
    @IBOutlet weak var addSubcategoryButton: UIButton!
    
    @IBOutlet weak var addCategoryBatton: UIButton!
    
    private let defaultSubcategory = Consts.subcategoriesEmptyPlaceholder
    private let defaultCategory = Consts.categoriesEmptyPlaceholder
    
    private var categories = [String]()
    private var subCategories = [String]()
    
    private var selectedCategory = ""
    private var selectedSubCategory = ""
    private var currentPaymentValue = 0.0
    
    private let titleMaxSymbols = Consts.categorieTitleMaxSymbols
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.shared.initializeUserData()
        
        txt.keyboardType = .decimalPad
        txt.text = "0"
        txt.delegate = self
        addToolBarOnKeyboard()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        subcategoryPicker.delegate = self
        subcategoryPicker.dataSource = self
        
//        categories = DataManager.shared.getCategories()
//        selectedCategory = categories[0]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCategoriesPickerData()
        updateSubcategoryPickerData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if selectedCategory == "" || selectedCategory == defaultCategory{
                  UserMessenger.shared.showUserMessage(vc: self, message: "Нет категорий")
        }
    }
    
    func addToolBarOnKeyboard()
    {
        
        let textFieldToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        
        let left = UIBarButtonItem(title: "←", style: .done, target: self, action: #selector(leftButtonDidTap))
        left.tintColor = .label
        let right = UIBarButtonItem(title: "→", style: .done, target: self, action: #selector(rightButtonDidTap))
        right.tintColor = .label
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonDidTap))
        done.tintColor = .label
        
        var items = [UIBarButtonItem]()
        items.append(left)
        items.append(right)
        items.append(flexSpace)
        items.append(done)
        
        textFieldToolbar.items = items
        textFieldToolbar.sizeToFit()
        
        txt.inputAccessoryView = textFieldToolbar
        
    }

    @objc func doneButtonDidTap()
    {
        let paymentTxt = txt.text
        
        if let pTxt = paymentTxt {
            if let pDouble = Double(pTxt) {
                currentPaymentValue = pDouble
            } else {
              currentPaymentValue = 0
            }
        } else {
          currentPaymentValue = 0
        }
        
        txt.resignFirstResponder()
    }
    
    @objc func leftButtonDidTap()
    {
        //move cursor one position left
    }
    
    @objc func rightButtonDidTap()
    {
        //move cursor one position right
    }
    
    
    
    @IBAction func incomeButtonDidTap(_ sender: Any) {
        createPayment(type: .income)
    }
    
    @IBAction func expenceButtonDidTap(_ sender: Any) {
        createPayment(type: .expence)
    }
    
    
    private func createPayment(type: PaymentType) {
        
        if selectedCategory == "" || selectedCategory == defaultCategory{
            UserMessenger.shared.showUserMessage(vc: self, message: "Нет категорий")
            return
        }
        
        
        if currentPaymentValue != 0 {
            let date = Date()
            
            let payment = Payment(type: type, category: selectedCategory, subcategory: selectedSubCategory, value: currentPaymentValue, paymentDate: date)
            
            CoreDataManager.shared.savePayment(payment: payment)
            UserMessenger.shared.showUserMessage(vc: self, message: "Платеж принят")
            
            txt.text = "0"
            txt.resignFirstResponder()
            currentPaymentValue = 0
        }else {
            showNoPaymentAlert()
        }

    }
    
    @IBAction func addCategoryBtnDidTap(_ sender: Any) {
        showAddNewCategoryAlert(type: .category)
    }
    
    @IBAction func addSubcategoryBtnDidTap(_ sender: Any) {
        showAddNewCategoryAlert(type: .subcategory)
    }
    
    private func disableUserInteraction() {
        categoryPicker.isUserInteractionEnabled = false
        subcategoryPicker.isUserInteractionEnabled = false
        addSubcategoryButton.isUserInteractionEnabled = false
        addCategoryBatton.isUserInteractionEnabled = false
    }
    
    private func enableUserInteraction() {
        categoryPicker.isUserInteractionEnabled = true
        subcategoryPicker.isUserInteractionEnabled = true
        addSubcategoryButton.isUserInteractionEnabled = true
        addCategoryBatton.isUserInteractionEnabled = true
    }
    
    //    MARK: ALERTS
    
    private func showAddNewCategoryAlert(type: CategoryType){
        
        var textField = UITextField()
        var alertTitle = ""
        var textInputPlaceholder = ""
        
        switch type {
        case .category:
            alertTitle = "Новая категория"
            textInputPlaceholder = "категория (\(titleMaxSymbols) смв max)"
            case .subcategory:
            alertTitle = "Новая подкатегория"
            textInputPlaceholder = "подкатегория (\(titleMaxSymbols) смв max)"
        }
        
        
        let alert = UIAlertController(title: alertTitle, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
                   
           if let txt = textField.text, txt.count > 0 {
               var trimmedTitle = txt
               
               if txt.count > self.titleMaxSymbols {
                   let index = txt.index(txt.startIndex, offsetBy: self.titleMaxSymbols)
                   trimmedTitle = String(txt[..<index])
               }
               
            if trimmedTitle == Consts.categoriesEmptyPlaceholder || trimmedTitle == Consts.subcategoriesEmptyPlaceholder {
                   UserMessenger.shared.showUserMessage(vc: self, message: "Неверные данные")
                   return
               }
               
               switch type {
               case .category:
                   if DataManager.shared.isExist(category: trimmedTitle) {
                       UserMessenger.shared.showUserMessage(vc: self, message: "Категория существует")
                       return
                   }

                   DataManager.shared.addCtegory(title: trimmedTitle)
                   self.updateCategoriesPickerData()
                   self.categoryPicker.selectRow(0, inComponent: 0, animated: true)
                   self.selectedCategory = trimmedTitle

               case .subcategory:
                   if DataManager.shared.isExist (subcategory: trimmedTitle, inCategory: self.selectedCategory) {
                       UserMessenger.shared.showUserMessage(vc: self, message: "Подкатегория существует")
                       return
                   }
                   
                   DataManager.shared.addSubCtegory(title: trimmedTitle, forCategory: self.selectedCategory)
                   self.updateSubcategoryPickerData()
                   self.subcategoryPicker.selectRow(1, inComponent: 0, animated: true)
                   self.selectedSubCategory = trimmedTitle

               }
               
           } else {
               UserMessenger.shared.showUserMessage(vc: self, message: "Неверные данные")
           }

       }
       //
       //
       //
       //
       
       let cancelAction = UIAlertAction(title: "Отмена", style: .default, handler: nil )
     
        okAction.setValue(UIColor.label, forKey: "titleTextColor")
       cancelAction.setValue(UIColor.label, forKey: "titleTextColor")
       
       alert.addTextField { (txtTf) in
           textField = txtTf
           textField.placeholder = textInputPlaceholder
           textField.font = UIFont(name: "System", size: 20)
           textField.autocapitalizationType = .sentences
       }
        
        
       alert.addAction(cancelAction)
       alert.addAction(okAction)
       present(alert, animated: true) {  }
        
        
    }
    
    private func showNoPaymentAlert() {
        let alert = UIAlertController(title: "Внимание", message: "Пожалуйста, введите сумму платежа.", preferredStyle: .alert)
        let okAct = UIAlertAction(title: "Ок", style: .default) { (action) in
            self.txt.becomeFirstResponder()
        }
        alert.addAction(okAct)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    private func updateCategoriesPickerData () {
        categories = DataManager.shared.getCategories()
        if categories.isEmpty {
            categories = [defaultCategory]
            addSubcategoryButton.alpha = 0
        } else {
            addSubcategoryButton.alpha = 1
        }
        categoryPicker.reloadAllComponents()
        categoryPicker.selectRow(0, inComponent: 0, animated: true)
        selectedCategory = categories[categoryPicker.selectedRow(inComponent: 0)]
    }
    
    private func updateSubcategoryPickerData() {
        subCategories = DataManager.shared.getSubCategoriesForCategory(category: selectedCategory)
        subCategories.insert(defaultSubcategory, at: 0)
        subcategoryPicker.reloadAllComponents()
        subcategoryPicker.selectRow(0, inComponent: 0, animated: false)
        selectedSubCategory = subCategories[0]
    }
    
    
}


extension PaymentViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
        case categoryPicker:
            selectedCategory = categories[row]
            updateSubcategoryPickerData()
        case subcategoryPicker:
            selectedSubCategory = subCategories[row]
        default:
            break
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = ""
          switch pickerView {
                case categoryPicker:
                    title = categories[row]
                case subcategoryPicker:
                    title = subCategories[row]
                default:
                    break
                }
        
        return title
    }
}


extension PaymentViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numberOfRows = 0
        
        switch pickerView {
        case categoryPicker:
            numberOfRows = categories.count
        case subcategoryPicker:
            numberOfRows = subCategories.count
        default:
            break
        }
        return numberOfRows
    }
}

extension PaymentViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        enableUserInteraction()
        
        if let txt = textField.text {
            if txt == "" {
                textField.text = "0"
            }
        }else {
            
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        disableUserInteraction()
        
        if let txt = textField.text {
            if txt == "0"{
                textField.text = ""
            }
            
        } else {
            
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.count >= 6 { return false } else { return true }
    }
    
    
   
}


