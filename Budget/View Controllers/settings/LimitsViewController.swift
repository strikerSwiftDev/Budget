
import UIKit

class LimitsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    private var categories = [String]()
    private var limits = [LimitModel]()
    private var expences = [(String, Double)]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .label
        navigationItem.largeTitleDisplayMode = .never
        
        initTableView()
        
        self.navigationController?.presentationController?.delegate = self

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
//        print("limits VC will appear")
    }
    
    private func initTableView () {
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "LimitsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LimitsTableViewCellID")
        
        let nib1 = UINib(nibName: "LimitsEmptyTableViewCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "LimitsEmptyTableViewCellID")
        
        tableView.tableFooterView = UIView()
        
        tableView.allowsSelection = false
        
    }
    
    private func updateData() {
        
        categories = DataManager.shared.getCategories()
        limits = LimitsManager.shared.getLimits()
        expences = LimitsManager.shared.getExpences()
        
        tableView.reloadData()
    }
    
    
    
    
    private func returnLimitModelFor(category: String) -> LimitModel? {
        
        return limits.filter{$0.category == category}.first

    }
    
//    private func editLimitFor(category: String) {
//        presentSetLimitsFor(category: category)
//    }
    
    private func deleteLimitFor(category: String, cellRow: Int) {
        deleteLimit(category: category)
//
//        self.tableView.beginUpdates()
//        let indexPath = IndexPath(row: cellRow, section: 0)
//        self.tableView.deleteRows(at: [indexPath], with: .automatic)
//        self.tableView.endUpdates()


        tableView.reloadData()

    }
    
    private func setLimitFor(category: String) {
        presentSetLimitsFor(category: category)
    }
    
    private func deleteLimit(category: String) {
        LimitsManager.shared.deleteLimit(for: category)
        let newLimits = limits.filter() {$0.category != category}
        limits = newLimits
    }
    
    private func presentSetLimitsFor(category: String) {
        let storyboard = UIStoryboard(name: "Settings", bundle: nil)
        let setFiltersVC = storyboard.instantiateViewController(identifier: "SetLimitsViewControllerID") as! SetLimitsViewController
        setFiltersVC.setCategory(category: category)
        setFiltersVC.delegate = self
                
        present(setFiltersVC, animated: true, completion: nil)
        
    }

}

extension LimitsViewController: SetLimitsViewControllerDelegate {
    func limilUppied(limit: LimitModel) {
        LimitsManager.shared.addLimitForCategory(limit: limit)
        limits.append(limit)
        tableView.reloadData()
    }
    
    func limitCancelled() {
    }
    
    
}

extension LimitsViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {   print("viewControllerDismissed")
    }
}

extension LimitsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let category = categories[indexPath.row]
        
        if let limitmodel = returnLimitModelFor(category: category) {
            
            let expence = expences.filter(){$0.0 == category}
            let expenceValue = expence.first?.1 ?? 0
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LimitsTableViewCellID" , for: indexPath) as! LimitsTableViewCell
            cell.initCell(limit: limitmodel, expence: expenceValue)
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LimitsEmptyTableViewCellID" , for: indexPath) as! LimitsEmptyTableViewCell
            cell.initFor(category: category)
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let category = categories[indexPath.row]
        if returnLimitModelFor(category: category) != nil {

            return nil
            
        } else {
            
            let setAction = UIContextualAction(style: .normal, title: "") { [weak self] (action, view, handler) in
                tableView.reloadData()
                handler(true)
                self!.setLimitFor(category: category)
                        
            }
            setAction.backgroundColor = .systemGreen
            setAction.image = UIImage(named: "edit_icon")
            var configuration = UISwipeActionsConfiguration()
            
            configuration = UISwipeActionsConfiguration(actions: [setAction])
            
            configuration.performsFirstActionWithFullSwipe = false
            return configuration
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let category = categories[indexPath.row]
        if returnLimitModelFor(category: category) != nil {
            
            let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] (action, view, handler) in
                self!.deleteLimitFor(category: category, cellRow: indexPath.row)
                        
            }
            deleteAction.backgroundColor = .systemRed
            deleteAction.image = UIImage(named: "delete_icon")

            
            var configuration = UISwipeActionsConfiguration()
            
            configuration = UISwipeActionsConfiguration(actions: [deleteAction])
            
            configuration.performsFirstActionWithFullSwipe = false
            return configuration
            
        } else {
            return nil
        }
        
    }
    
}

extension LimitsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if returnLimitModelFor(category: categories[indexPath.row]) != nil {
            return 120
        } else {
            return 50
        }

    }

    
}


