

import UIKit

class GraphReportViewController: UIViewController {

    @IBOutlet weak var graphView: GraphView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var clearPanelVerticalConstraint: NSLayoutConstraint!
    private let defaultsColors: [UIColor] = [.red, .label, .blue, .darkGray, .yellow, .green, .orange, .cyan, .magenta, .purple]
    private var colorArr: [UIColor] = []
    
    private var compareObjects = [CompareObjectModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .label
        navigationItem.largeTitleDisplayMode = .never
        
        clearPanelVerticalConstraint.constant = -35
        
        colorArr = defaultsColors
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "GraphReportTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "graphReportTableViewCell")
        tableView.tableFooterView = UIView()
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
                
        activityIndicator.stopAnimating()
        
    }
    
    
    
//
    private func getPaymentsFor(filter: FiltersModel) {
        activityIndicator.startAnimating()
        DispatchQueue.global().async {
            let payments = CoreDataManager.shared.loadConvertedPaymentsWith(filter: filter)
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.calculateCompareObjectAndUpdData(payments: payments, filter: filter)
            }
        }
    }
    
    private func calculateCompareObjectAndUpdData(payments: [Payment], filter: FiltersModel) {
        var value = 0.0
        for payment in payments {
            value += payment.value
        }
        
        guard let color = colorArr.randomElement() else {return}
         guard let index = colorArr.firstIndex(of: color) else {return}
            colorArr.remove(at: index)
        
        let category = filter.category
        let subcategory = filter.subcategory
        let type = filter.type
        let fromDate = filter.fromDate ?? Consts.wrongDate
        let toDate = filter.toDate ?? Consts.wrongDate
        
        let compareObj = CompareObjectModel(category: category, subcategory: subcategory, value: value, color: color, type: type, fromDate: fromDate, toDate: toDate)
        compareObjects.append(compareObj)
        
        graphView.updateCompareData(compareObjects: compareObjects)
        tableView.reloadData()
        
        if colorArr.count == 0 {
            setAddBtnDisabled()
        }
    }
//
    private func presentFilters() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let filtersVC = storyboard.instantiateViewController(identifier: "FiltersViewControllerId") as! FiltersViewController
        filtersVC.delegate = self
        filtersVC.setUseTwoSegments()
        present(filtersVC, animated: true, completion: nil)
    }
    
    private func deleteItem(num: Int) {
        let item = compareObjects.remove(at: num)
        graphView.updateCompareData(compareObjects: compareObjects)
        colorArr.append(item.color)
        
        self.tableView.beginUpdates()
        let indexPath = IndexPath(row: num, section: 0)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        self.tableView.endUpdates()
        
        if compareObjects.isEmpty {
            hideClearPanel()
        }
//        tableView.reloadData()
        
        if colorArr.count > 0 {
            setAddBtnEnabled()
        }

    }
    
    private func setAddBtnDisabled() {
        addButton.isEnabled = false
    }
    
    private func setAddBtnEnabled() {
        addButton.isEnabled = true

    }
    
    private func showClearPanel() {
        UIView.animate(withDuration: 0.33) {
            self.clearPanelVerticalConstraint.constant = 0
            self.view.layoutIfNeeded()

        }
    }
    
    private func hideClearPanel() {
        UIView.animate(withDuration: 0.33) {
            self.clearPanelVerticalConstraint.constant = -35
            self.view.layoutIfNeeded()

        }
    }
    
// MARK: ACTIONS


    @IBAction func addButtonDidTap(_ sender: Any) {
        presentFilters()
    }
    
    
    @IBAction func clearButtonDidTap(_ sender: Any) {
        hideClearPanel()
        compareObjects = []
        tableView.reloadData()
        graphView.updateCompareData(compareObjects: compareObjects)
        colorArr = defaultsColors
        setAddBtnEnabled()
    }
    
}

//MARK: EXTENTIONS

extension GraphReportViewController: FiltersViewControllerDelegate {
    func filtersApplied(filters: FiltersModel) {
        if compareObjects.isEmpty {
            showClearPanel()
        }
        getPaymentsFor(filter: filters)
        
    }
    
    
}

extension GraphReportViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
}

extension GraphReportViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compareObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "graphReportTableViewCell") as! GraphReportTableViewCell
        let compareObject = compareObjects[indexPath.row]
        cell.setupCellFor(compareObject:compareObject)
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        let item = compareObjects.remove(at: sourceIndexPath.row)
        compareObjects.insert(item, at: destinationIndexPath.row)
        graphView.updateCompareData(compareObjects: compareObjects)
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let action = UIContextualAction(style: .normal, title: "Удалить") { [weak self] (action, view, handler) in
            self!.deleteItem(num:indexPath.row)
        }

        action.backgroundColor = .red
        
        var configuration = UISwipeActionsConfiguration()
        
        configuration = UISwipeActionsConfiguration(actions: [action])
        
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    
    
}

extension GraphReportViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
       
}
