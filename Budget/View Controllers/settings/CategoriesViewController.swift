
import UIKit

class CategoriesViewController: UIViewController {
    
    private var categories = [String]()
    private var subcategories = [String]()

    private let categoriesEmptyPlaceholder = [Consts.categoriesEmptyPlaceholder]
    private let subcategoriesEmptyPlaceholder = [Consts.subcategoriesEmptyPlaceholder]

    @IBOutlet weak var categoriesAddButton: UIButton!
    
    @IBOutlet weak var subcategoriesAddButton: UIButton!
    
    @IBOutlet weak var subcategoriesTableView: UITableView!
    @IBOutlet weak var categoriesTableView: UITableView!
    
    private var interfaceButtonsColor = UIColor.label
    
    private var selectedCategory = ""
    
    private let titleMaxSymbols = Consts.categorieTitleMaxSymbols
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = interfaceButtonsColor
        navigationItem.largeTitleDisplayMode = .never

        categoriesTableView.tableFooterView = UIView()
        subcategoriesTableView.tableFooterView = UIView()
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.dragInteractionEnabled = true
        categoriesTableView.dragDelegate = self
        subcategoriesTableView.delegate = self
        subcategoriesTableView.dataSource = self
        subcategoriesTableView.dragInteractionEnabled = true
        subcategoriesTableView.dragDelegate = self

        subcategoriesAddButton.alpha = 0
        
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAndSetNormalModeForCategories()
        updateSubcateoriesTableFor(category: "")
    }
    
    private func updateSubcateoriesTableFor(category: String, andShowAddButton: Bool = false) {
        
        let sub = DataManager.shared.getSubCategoriesForCategory(category: category)
            
        if sub.count != 0 {
            subcategories = sub
        } else {
            subcategories = subcategoriesEmptyPlaceholder
        }
            
        subcategoriesTableView.reloadData()
        
        if andShowAddButton {
            
            UIView.animate(withDuration: 0.33) {
                self.subcategoriesAddButton.alpha = 1
            }
        }
        
    }
    
    private func updateAndSetNormalModeForCategories(withScroll: Bool = false) {
        categories = DataManager.shared.getCategories()
        if categories.isEmpty {
            categories = categoriesEmptyPlaceholder
        }
       
        categoriesTableView.reloadData()
        
        if withScroll {
            categoriesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)

        }
    }
    
    private func setUnactiveModeForsubCategories() {
        subcategories = subcategoriesEmptyPlaceholder
        subcategoriesTableView.reloadData()
        UIView.animate(withDuration: 0.33) {
            self.subcategoriesAddButton.alpha = 0
        }
                
       }
    
    //MARK: buttons
    
    @IBAction func categoriesAddBtnDidTap(_ sender: Any) {
//        selectedCategory = ""
//        updateSubcateoriesTableFor(category: "", andShowAddButton: false)
        showAddNewCategoryAlert(type: .category)
    }
    
    @IBAction func subcategoriesAddBtnDidTap(_ sender: Any) {

        showAddNewCategoryAlert(type: .subcategory)
    }
    
    
    // MARK: Alerts
    
    private func 	showAddNewCategoryAlert (type:CategoryType) {

        var textfield = UITextField()
        
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
            
            if let txt = textfield.text, txt.count > 0 {
                var trimmedTitle = txt
                
                if txt.count > self.titleMaxSymbols {
                    let index = txt.index(txt.startIndex, offsetBy: self.titleMaxSymbols)
                    trimmedTitle = String(txt[..<index])
                }
                
                if trimmedTitle == self.categoriesEmptyPlaceholder.first || trimmedTitle == self.subcategoriesEmptyPlaceholder.first {
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
                    self.selectedCategory = ""
                    self.setUnactiveModeForsubCategories()
                    self.updateAndSetNormalModeForCategories(withScroll: true)
 
                case .subcategory:
                    
                    if DataManager.shared.isExist (subcategory: trimmedTitle, inCategory: self.selectedCategory) {
                        UserMessenger.shared.showUserMessage(vc: self, message: "Подкатегория существует")
                        return
                    }
                    
                    DataManager.shared.addSubCtegory(title: trimmedTitle, forCategory: self.selectedCategory)
                    self.updateSubcateoriesTableFor(category: self.selectedCategory, andShowAddButton: true)
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
      
        okAction.setValue(interfaceButtonsColor, forKey: "titleTextColor")
        cancelAction.setValue(interfaceButtonsColor, forKey: "titleTextColor")
        
        alert.addTextField { (txtTf) in
            textfield = txtTf
            textfield.placeholder = textInputPlaceholder
            textfield.font = UIFont(name: "System", size: 20)
            textfield.autocapitalizationType = .sentences
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        present(alert, animated: true) { /*code*/ }
    }
    
    private func showDeleteCategoryAlert(category:String, row:Int) {
        let alert = UIAlertController(title: "Внимание!", message: "Удалив категорию вы также удалите подкатегории и все платежи этой категории", preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "Удалить", style: .default) { (_) in
                        
            DataManager.shared.delete(category: category, row: row)
            CoreDataManager.shared.deletePaymentsFor(category: category)
            
            self.categories = DataManager.shared.getCategories()
            self.categoriesTableView.beginUpdates()
            let indexPath = IndexPath(row: row, section: 0)
            self.categoriesTableView.deleteRows(at: [indexPath], with: .fade)
            self.categoriesTableView.endUpdates()
            
            if self.categories.isEmpty {
                self.categories = self.categoriesEmptyPlaceholder
            }
            
            self.categoriesTableView.reloadData()
            
            UserMessenger.shared.showUserMessage(vc: self, message: "Категория удалена")

        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        cancelAction.setValue(interfaceButtonsColor, forKey: "titleTextColor")
        okAction.setValue(interfaceButtonsColor, forKey: "titleTextColor")
        
        
        alert.addAction(okAction)
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func showDeleteSubcategoryAlert (subcategory: String, row: Int) {
        
        let alert = UIAlertController(title: "Внимание!", message: "подкатегория будет удалена. Хотите удалить платежи или переместить в без категории?", preferredStyle: .actionSheet)
        
        let okActionWithDeletePayments = UIAlertAction(title: "Удалить платежи", style: .default) { (_) in
                               
            DataManager.shared.delete(subcategory: subcategory, inCategory: self.selectedCategory, row: row)
            CoreDataManager.shared.deletePaymentsFor(subcategory: subcategory, inCategory: self.selectedCategory)

            self.subcategories = DataManager.shared.getSubCategoriesForCategory(category: self.selectedCategory)
           
            self.subcategoriesTableView.beginUpdates()
            let indexPath = IndexPath(row: row, section: 0)
            self.subcategoriesTableView.deleteRows(at: [indexPath], with: .fade)
            self.subcategoriesTableView.endUpdates()
            
            if self.subcategories.isEmpty {
                self.subcategories = self.subcategoriesEmptyPlaceholder
            }
            self.subcategoriesTableView.reloadData()
            UserMessenger.shared.showUserMessage(vc: self, message: "Подкатегория удалена")

        }
        
        let okActionWithSetPaymentsUncategorized = UIAlertAction(title: "Переместить в без категории", style: .default) { (_) in
                                      
                   DataManager.shared.delete(subcategory: subcategory, inCategory: self.selectedCategory, row: row)
                CoreDataManager.shared.setPaymentsAsUncatgorizedFor(subcategory: subcategory, inCategory: self.selectedCategory)
            
                   self.subcategories = DataManager.shared.getSubCategoriesForCategory(category: self.selectedCategory)
                  
                   self.subcategoriesTableView.beginUpdates()
                   let indexPath = IndexPath(row: row, section: 0)
                   self.subcategoriesTableView.deleteRows(at: [indexPath], with: .fade)
                   self.subcategoriesTableView.endUpdates()
                   
                   if self.subcategories.isEmpty {
                       self.subcategories = self.subcategoriesEmptyPlaceholder
                   }
                   self.subcategoriesTableView.reloadData()
                   UserMessenger.shared.showUserMessage(vc: self, message: "Подкатегория удалена")

               }
               
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            cancelAction.setValue(interfaceButtonsColor, forKey: "titleTextColor")
            okActionWithDeletePayments.setValue(interfaceButtonsColor, forKey: "titleTextColor")
            okActionWithSetPaymentsUncategorized.setValue(interfaceButtonsColor, forKey: "titleTextColor")
            
            alert.addAction(okActionWithDeletePayments)
            alert.addAction(okActionWithSetPaymentsUncategorized)
            alert.addAction(cancelAction)
        
            alert.view.addSubview(UIView())
        
            present(alert, animated: false)
    }

}

//MARK Extentions

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tableView {
        case categoriesTableView:
            selectedCategory = categories[indexPath.row]
            updateSubcateoriesTableFor(category: selectedCategory, andShowAddButton: true)
        case subcategoriesTableView:
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            break
        }
    }
  
}

extension CategoriesViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }

}



extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        
        switch tableView {
        case categoriesTableView:
            rows = categories.count
        case subcategoriesTableView:
            rows = subcategories.count
        default:
            rows = 0
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch tableView {
        case categoriesTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableViewCell")!
            cell.textLabel?.text = categories[indexPath.row]
            
            if categories[indexPath.row] == categoriesEmptyPlaceholder.first {
                cell.isUserInteractionEnabled = false
            }else {
                cell.isUserInteractionEnabled = true
            }
            
        case subcategoriesTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SubcategoriesTableViewCell")!
            cell.textLabel?.text = subcategories[indexPath.row]
            if subcategories[indexPath.row] == subcategoriesEmptyPlaceholder.first {
                cell.isUserInteractionEnabled = false
            } else {
                cell.isUserInteractionEnabled = true
            }
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        switch tableView {
        case categoriesTableView:
            DataManager.shared.moveCategoryFrom(position: sourceIndexPath.row, toPosition: destinationIndexPath.row)
            setUnactiveModeForsubCategories()
            updateAndSetNormalModeForCategories()
        case subcategoriesTableView:
            DataManager.shared.moveSubcategoryFor(category: selectedCategory, fromPosition: sourceIndexPath.row, toPosition: destinationIndexPath.row)
            updateSubcateoriesTableFor(category: selectedCategory, andShowAddButton: true)
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if tableView == categoriesTableView {
            setUnactiveModeForsubCategories()
        }
        
        let action = UIContextualAction(style: .normal, title: "Удалить") { [weak self] (action, view, handler) in
            
            switch tableView {
            case self!.categoriesTableView:
                self!.showDeleteCategoryAlert(category: self!.categories[indexPath.row], row: indexPath.row)
                
            case self!.subcategoriesTableView:
                self!.showDeleteSubcategoryAlert(subcategory: self!.subcategories[indexPath.row], row: indexPath.row)
            default :
                break
            }
            
        }
        
        action.backgroundColor = .red
        
        let cell = tableView.cellForRow(at: indexPath)
        
        var configuration = UISwipeActionsConfiguration()
        
        if cell?.textLabel?.text != categoriesEmptyPlaceholder.first,
        cell?.textLabel?.text != subcategoriesEmptyPlaceholder.first {
            configuration = UISwipeActionsConfiguration(actions: [action])
        }else {
            configuration = UISwipeActionsConfiguration(actions: [])
        }
        
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
}
