
import UIKit

enum TableViewMode {
    case categories
    case suBcategories
}

class CategoriesStatViewController: UIViewController {

    @IBOutlet weak var segmentControlVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var backButtonViewVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var modeSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var fromDateTF: UITextField!
    @IBOutlet weak var toDateTF: UITextField!
    
    
    private var objects = [StatReportObjectModel]()
    private var storedCategoriesObjects = [StatReportObjectModel]()
    private var currentPayments = [Payment]()
    
    private var fromDate: Date? = nil
    private var toDate: Date? = nil
    private var mode = PaymentType.expence
    
    private var tableViewMode = TableViewMode.categories
    
    private let selectAllStr = "< ВСЕ >"
    var currentPicker : UIDatePicker?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .label
        navigationItem.largeTitleDisplayMode = .never
        
        activityIndicator.stopAnimating()
        initTableView()
        backButtonViewVerticalConstraint.constant = -30
    }
    
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "CategoriesStatTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CategoriesStatTableViewCellIdentifier")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fromDateTF.text = selectAllStr
        toDateTF.text = selectAllStr
        updateDataForCategories()
        
    }
    
    private func updateDataForCategories() {
        deactivateAllControls()
        let filter = FiltersModel()
        filter.fromDate = fromDate
        filter.toDate = toDate
        filter.type = mode
        
        DispatchQueue.global().async {
            self.currentPayments = CoreDataManager.shared.loadConvertedPaymentsWith(filter: filter)
            self.objects = self.convertedPaymentsToCompareObjects(payments: self.currentPayments)
            DispatchQueue.main.async {
                self.activateAllControls()
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    private func convertedPaymentsToCompareObjects(payments: [Payment]) -> [StatReportObjectModel] {
        
        var statObjects = [StatReportObjectModel]()
        
        let names = DataManager.shared.getCategories()
        
        for name in names {
            
           let filteredArr = payments.filter{$0.category == name}
            
            let value = filteredArr.reduce(0, {$0 + $1.value})
            let obj = StatReportObjectModel(name: name, value: value, mode: tableViewMode, type: mode)
            statObjects.append(obj)
            
        }
        
        return statObjects.sorted(by: {$0.value > $1.value})
    }
    

    
    
    private func updateDataForSubcategories(category:String) {
        let subCategoryPayments = currentPayments.filter { $0.category == category }
        var statObjects = [StatReportObjectModel]()
        let names = DataManager.shared.getSubCategoriesForCategory(category: category)
    
        for name in names {
            let filteredArray = subCategoryPayments.filter { $0.subcategory == name }
            let value = filteredArray.reduce(0, {$0 + $1.value})
            let obj = StatReportObjectModel(name: name, value: value, mode: tableViewMode, type: mode)
            statObjects.append(obj)
        }
        
        objects = statObjects.sorted(by: {$0.value > $1.value})
        tableView.reloadData()
    }
    
    
    
    
    private func presentPopUpcontroller(ID: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popVC = storyboard.instantiateViewController(withIdentifier: "popupVCID")
        
        var sourseView = UIView()
        var sourceRect = CGRect()
        
        sourseView = modeSegmentControl
        sourceRect = CGRect(x: modeSegmentControl.bounds.midX, y: modeSegmentControl.bounds.minY, width: 0, height: 0)
        
        popVC.modalPresentationStyle = .popover
        popVC.popoverPresentationController?.delegate = self
        popVC.popoverPresentationController?.sourceView = sourseView
        popVC.popoverPresentationController?.sourceRect = sourceRect
        popVC.preferredContentSize = CGSize(width: 250, height: 250)
        
        let picker = UIDatePicker(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 250))
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ru_RU")
        
        if Consts.isDebugBuild {
            picker.minimumDate = UserDefaults.standard.object(forKey: "theVeryFirstDate") as? Date
        }else {
            picker.minimumDate = DataManager.shared.getTheVeryFirstDate()
        }
        
        picker.maximumDate = Date()
        popVC.view.addSubview(picker)
        
        let btnX = picker.frame.width/2 - 75
        let btnY = picker.frame.height - 45
        
        let btn = UIButton(frame: CGRect(x: Int(btnX), y: Int(btnY), width: 150, height: 50))
        
        let font = UIFont.boldSystemFont(ofSize: 20)
        let attributedText = NSAttributedString(string: "Установить", attributes: [NSAttributedString.Key.font: font, .foregroundColor: UIColor.label])
        
        let attributedTextForHiglited = NSAttributedString(string: "Установить", attributes: [NSAttributedString.Key.font: font, .foregroundColor: UIColor.gray])
        
        btn.setAttributedTitle(attributedText, for: .normal)
        btn.setAttributedTitle(attributedTextForHiglited, for: .highlighted)
        
        popVC.view.addSubview(btn)
        btn.addTarget(self, action: #selector (setDate), for: UIControl.Event.touchUpInside)
        
        switch ID {
        case 1:
            picker.tag = 1
        case 2:
            picker.tag = 2
            if fromDate != nil {
                picker.minimumDate = fromDate
            }
        default:
            break
        }
        
        currentPicker = picker
        
        present(popVC, animated: true)
    }
    
    @objc func setDate(sender: UIButton!) {
        guard let picker = currentPicker else {return}
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "RU_ru")
        let strDate = formatter.string(from: picker.date)

        switch picker.tag {
        case 1:
            fromDateTF.text = strDate
            fromDate = picker.date
        case 2:
            toDateTF.text = strDate
            toDate = picker.date
        default:
            break
        }
        
        currentPicker = nil
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        updateDataForCategories()
    }
    
    private func deactivateAllControls() {
        activityIndicator.startAnimating()
        modeSegmentControl.isEnabled = false

    }
    private func activateAllControls() {
        activityIndicator.stopAnimating()
        modeSegmentControl.isEnabled = true
    }
    
    private func showBackButton() {
        UIView.animate(withDuration: 0.22) {
            self.backButtonViewVerticalConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.22) {
            self.segmentControlVerticalConstraint.constant = -self.modeSegmentControl.frame.height
            self.view.layoutIfNeeded()
        }
        
    }
    
    private func hideBackButton() {
        UIView.animate(withDuration: 0.22) {
            self.backButtonViewVerticalConstraint.constant = -30
            self.view.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.22) {
            self.segmentControlVerticalConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    @IBAction func fromDateTfTapped(_ sender: Any) {
        fromDateTF.resignFirstResponder()
        if tableViewMode == .categories {
            presentPopUpcontroller(ID: 1)
        }
        
    }
    
    
    @IBAction func toDateTfTapped(_ sender: Any) {
        toDateTF.resignFirstResponder()
        if tableViewMode == .categories {
            presentPopUpcontroller(ID: 2)
        }
        
    }
    

    
    @IBAction func segmentControlValueChanged(_ sender: Any) {
        switch modeSegmentControl.selectedSegmentIndex {
        case 0:
            mode = .expence
        case 1:
            mode = .income
        default:
            break
        }

        updateDataForCategories()
        
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        tableViewMode = .categories
        objects = storedCategoriesObjects
        tableView.reloadData()
        hideBackButton()
        storedCategoriesObjects = []
        
    }
    
    
}

extension CategoriesStatViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return.none
    }
}

extension CategoriesStatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
        let category = objects[indexPath.row].name
        
        if tableViewMode == .categories, !DataManager.shared.getSubCategoriesForCategory(category: category).isEmpty {
            tableViewMode = .suBcategories
            storedCategoriesObjects = objects
            updateDataForSubcategories(category: category)
            showBackButton()
        } else if tableViewMode == .categories {
            UserMessenger.shared.showUserMessage(vc: self, message: "Нет подкатегорий")
        }
        
        
        
    }
}

extension CategoriesStatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesStatTableViewCellIdentifier") as! CategoriesStatTableViewCell
        cell.initCellWith(object: objects[indexPath.row])
        
        return cell
        
    }
    
    
}
