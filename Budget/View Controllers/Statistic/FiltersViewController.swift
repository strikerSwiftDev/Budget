
import UIKit

protocol FiltersViewControllerDelegate: class {
    func filtersApplied(filters:FiltersModel)
}

class FiltersViewController: UIViewController {
    @IBOutlet weak var categoriesTF: UITextField!
    @IBOutlet weak var subcategoriesTF: UITextField!
    @IBOutlet weak var fromDateTf: UITextField!
    @IBOutlet weak var toDateTf: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var cancelBTN: UIButton!
    
    @IBOutlet weak var applyBTN: UIButton!
    
    
    weak var delegate: FiltersViewControllerDelegate?
    
    private var tableContentArray = [String]()
    private var selectedCategory = ""
    private let selectAllStr = Consts.allString
    
    private var useTwoSegments = false
    
    var currentPicker : UIDatePicker?
    
    var fromDate: Date?
    var toDate: Date? {
        didSet {
            if toDate != nil {
                
                let newDate = Calendar.current.date(byAdding: .day, value: 1, to: toDate!)
                toDate = newDate
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    public func setUseTwoSegments() {
        useTwoSegments = true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //
        
        if useTwoSegments {
            segmentControl.removeSegment(at: 2, animated: false)
            segmentControl.selectedSegmentIndex = 1
        }else {
            segmentControl.selectedSegmentIndex = 2
        }

        categoriesTF.text = selectAllStr
        subcategoriesTF.text = ""
        fromDateTf.text = selectAllStr
        toDateTf.text = selectAllStr
        fromDate = nil
        toDate = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate = nil
        useTwoSegments = false
    }
    
    private func setFilters() {
        let filters = FiltersModel()
        filters.category = categoriesTF.text ?? ""
        if filters.category == selectAllStr {
            filters.category = ""
        }
        filters.subcategory = subcategoriesTF.text ?? ""
        if filters.subcategory == selectAllStr {
            filters.subcategory = ""
        }
        filters.fromDate = fromDate
        filters.toDate = toDate
        var paymentType: PaymentType
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            paymentType = .income
        case 1:
            paymentType = .expence
        default:
            paymentType = .overal
        }
        
        filters.type = paymentType
        
        delegate?.filtersApplied(filters: filters)

    }
    
    
    private func presentPopUpcontroller(ID:Int) {
        
        disableControls()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let popVC = storyboard.instantiateViewController(withIdentifier: "popupVCID")
        
        var sourseView = UIView()
        var sourceRect = CGRect()
        
        switch ID {
        case 1:
            sourseView = categoriesTF
            sourceRect = CGRect(x: categoriesTF.bounds.midX, y: categoriesTF.bounds.maxY, width: 0, height: 0)
        case 2:
            sourseView = subcategoriesTF
            sourceRect = CGRect(x: subcategoriesTF.bounds.midX, y: subcategoriesTF.bounds.maxY, width: 0, height: 0)
        case 3:
            sourseView = fromDateTf
            sourceRect = CGRect(x: fromDateTf.bounds.midX, y: fromDateTf.bounds.minY, width: 0, height: 0)
        case 4:
            sourseView = toDateTf
            sourceRect = CGRect(x: toDateTf.bounds.midX, y: toDateTf.bounds.minY, width: 0, height: 0)
        default:
            break
        }
        
        popVC.modalPresentationStyle = .popover
        popVC.popoverPresentationController?.delegate = self
        popVC.popoverPresentationController?.sourceView = sourseView
        popVC.popoverPresentationController?.sourceRect = sourceRect
        popVC.preferredContentSize = CGSize(width: 250, height: 250)
        
        setupPopoverViewFor(ID: ID, popVC: popVC)
        
        present(popVC, animated: true)
    }
    
    
    private func setupPopoverViewFor (ID: Int, popVC : UIViewController) {
        if ID == 1 || ID == 2 {
            
            let table = UITableView(frame: CGRect(x: 0.0, y: 0.0, width: popVC.view.frame.width, height: popVC.view.frame.height))
            popVC.view.addSubview(table)
            table.delegate = self
            table.dataSource = self
            table.tableFooterView = UIView()
                        
            table.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")
            
            switch ID {
            case 1:
                table.tag = 1
                tableContentArray = DataManager.shared.getCategories()
                tableContentArray.insert(selectAllStr, at: 0)
            case 2:
                table.tag = 2
                tableContentArray = DataManager.shared.getSubCategoriesForCategory(category:    selectedCategory)
                tableContentArray.insert(selectAllStr, at: 0)
//                tableContentArray.insert(Consts.subcategoriesEmptyPlaceholder, at: 1)
            default:
                break
            }
            
        } else {
            
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
            
            switch ID {
            case 3:
                picker.tag = 1
            case 4:
                picker.tag = 2
                if fromDate != nil {
                    picker.minimumDate = fromDate
                }
            default:
                break
            }
            
            currentPicker = picker
            btn.addTarget(self, action: #selector (setDate), for: UIControl.Event.touchUpInside)
            
        }
        
        
    }
    
    @objc func setDate(sender: UIButton!) {
        guard let picker = currentPicker else {return}
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "RU_ru")
        let strDate = formatter.string(from: picker.date)
        
        var components = DateComponents()
        components.year = Calendar.current.component(.year, from: picker.date)
        components.month = Calendar.current.component(.month, from: picker.date)
        components.day = Calendar.current.component(.day, from: picker.date)
        
        let myDate = Calendar.current.date(from: components)
        
        switch picker.tag {
        case 1:
            fromDateTf.text = strDate
            fromDate = myDate
        case 2:
            toDateTf.text = strDate
            toDate = myDate
        default:
            break
        }
        
        currentPicker = nil
        
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        
        enableControls()
    }
    
    private func disableControls() {
        applyBTN.isEnabled = false
        cancelBTN.isEnabled = false
        applyBTN.alpha = 0.5
        cancelBTN.alpha = 0.5
    }
    
    private func enableControls() {
        applyBTN.isEnabled = true
        cancelBTN.isEnabled = true
        applyBTN.alpha = 1
        cancelBTN.alpha = 1
    }
    
    //MARK texfields actions
    
    @IBAction func categoriesTfDidTap(_ sender: Any) {
        
        categoriesTF.resignFirstResponder()
        presentPopUpcontroller(ID: 1)
    }
    
    @IBAction func subcategoriesTfDidTap(_ sender: Any) {
        subcategoriesTF.resignFirstResponder()
        if selectedCategory.count > 0 {
            presentPopUpcontroller(ID: 2)
        } else {
            
            UserMessenger.shared.showUserMessage(vc: self, message: "Выберите категорию")
            
        }
        
    }
    
    @IBAction func fromDateTfDidTap(_ sender: Any) {
        fromDateTf.resignFirstResponder()
        presentPopUpcontroller(ID: 3)
    }
    
    @IBAction func toDateTfDidTap(_ sender: Any) {
        toDateTf.resignFirstResponder()
        presentPopUpcontroller(ID: 4)
    }
    
    @IBAction func applyBtnDidTap(_ sender: Any) {
        setFilters()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelBtnDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension FiltersViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return.none
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {   enableControls()
    }
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let text = tableContentArray[indexPath.row]
        
        switch tableView.tag {
        case 1:
            categoriesTF.text = text
            if selectedCategory != text {
                subcategoriesTF.text = ""
                selectedCategory = text
            }
            if selectedCategory != selectAllStr {
                subcategoriesTF.text = selectAllStr
                subcategoriesTF.isUserInteractionEnabled = true
            } else {
                subcategoriesTF.text = ""
                subcategoriesTF.isUserInteractionEnabled = false
            }
            
            
        case 2:
            subcategoriesTF.text = text
        default:
            break
        }
        
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        
        enableControls()
        
    }
}

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell")!
        cell.textLabel?.text = tableContentArray[indexPath.row]
        
        return cell
    }
    
    
}
