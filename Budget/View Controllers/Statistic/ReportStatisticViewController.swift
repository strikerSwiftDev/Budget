
import UIKit

class ReportStatisticViewController: UIViewController {

    
    @IBOutlet weak var infoIncomeLabel: UILabel!
    @IBOutlet weak var infoExpenceLabel: UILabel!
    @IBOutlet weak var infoTotalLabel: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    
    @IBOutlet weak var infoViewVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var filterBtn: UIBarButtonItem!
    
    @IBOutlet weak var selector: UISegmentedControl!
    
    @IBOutlet weak var reportTableView: UITableView!
    
    @IBOutlet weak var reportActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableViewActivityIndicator: UIActivityIndicatorView!
    
    private var areFiltersSelected = false
    
    private var sortedPaymentsArray = [[Payment]]()
    
    private var monthPaymentsArray = [[Payment]]()
    private var weekPaymentsArray = [[Payment]]()
    private var filteredPaymentsArray = [[Payment]]()
    
    private var manualFilter: FiltersModel?
    
    private var expenceSumForInfo: Double = 0
    private var incomeSumForInfo: Double = 0
    private var totalSumForInfo: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .label
        navigationItem.largeTitleDisplayMode = .never
        initialiseTableView()
        
        selector.selectedSegmentIndex = 1
        filterBtn.isEnabled = false
        updateReportDataFor(selectorState: .week)
        infoViewVerticalConstraint.constant = 0
        resetInfoStats()
        showInfo()
    }
    
    private func resetInfoStats() {
        expenceSumForInfo = 0
        incomeSumForInfo = 0
        totalSumForInfo = 0

    }
    
    private func initialiseTableView () {
        reportTableView.delegate = self
        reportTableView.dataSource = self
        
        let nib = UINib(nibName: "ReportTableViewCell", bundle: nil)
        reportTableView.register(nib, forCellReuseIdentifier: "ReportTableViewCellId")
        
        reportTableView.tableFooterView = UIView()
    }
    
    
    private func presentFiltesVC () {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let filtersVC = storyboard.instantiateViewController(identifier: "FiltersViewControllerId") as! FiltersViewController
        filtersVC.modalPresentationStyle = .popover
        filtersVC.delegate = self
        present(filtersVC, animated: true, completion: nil)
    }
    
    private func updateReportDataFor(selectorState: ReportSelectorState) {
        
        let filter = FiltersModel()
        let date = Date()
        
        switch selectorState {
        case .mounth:
            if CoreDataManager.shared.haveToUpdateMonthPaymentsFlag {
                var components = DateComponents()
                components.year = Calendar.current.component(.year, from: date)
                components.month = Calendar.current.component(.month, from: date)
                components.day = 1
                let newDate = Calendar.current.date(from: components)
                filter.fromDate = newDate
                uploadAndUpadteDataFor(filter: filter)
            } else {
                sortedPaymentsArray = monthPaymentsArray
                reportTableView.reloadData()
            }
            
        case .week:
            if CoreDataManager.shared.haveToUpdateWeekPaymentsFlag {
                let weekday = Calendar.current.component(.weekday, from: date) - 2
                let targetDate = Calendar.current.date(byAdding: .day, value: -weekday, to: date)!
                
                var components = DateComponents()
                components.year = Calendar.current.component(.year, from: targetDate)
                components.month = Calendar.current.component(.month, from: targetDate)
                components.day = Calendar.current.component(.day, from: targetDate)
                let newDate = Calendar.current.date(from: components)
                
                filter.fromDate = newDate
                uploadAndUpadteDataFor(filter: filter)
            } else {
                sortedPaymentsArray = weekPaymentsArray
                reportTableView.reloadData()
            }
            
        case .filter:
            if CoreDataManager.shared.haveToUpdateFilteredPaymentsFlag {
                    if manualFilter != nil {
                        uploadAndUpadteDataFor(filter: manualFilter!)
                    } else {
                        presentFiltesVC()
                    }
            } else {
                sortedPaymentsArray = filteredPaymentsArray
                reportTableView.reloadData()
            }
        }
        
    }
    
    private func uploadAndUpadteDataFor(filter: FiltersModel) {
        reportActivityIndicator.startAnimating()
        tableViewActivityIndicator.startAnimating()
        resetInfoStats()
        showInfo()
        
        DispatchQueue.global().async {
            let fiteredPaymentsFromCoreData = CoreDataManager.shared.loadConvertedPaymentsWith(filter: filter)
            self.sortedPaymentsArray = self.filterAndPreparePaymentsArray(rawPayments: fiteredPaymentsFromCoreData)
            self.calculateInfoFor(payments: fiteredPaymentsFromCoreData, filter: filter)
            
            DispatchQueue.main.async {
                
                switch self.selector.selectedSegmentIndex {
                case 0:
                    self.monthPaymentsArray = self.sortedPaymentsArray
//                    CoreDataManager.shared.haveToUpdateMonthPaymentsFlag = false
                case 1:
                    self.weekPaymentsArray = self.sortedPaymentsArray
//                    CoreDataManager.shared.haveToUpdateWeekPaymentsFlag = false
                case 2:
                    self.filteredPaymentsArray = self.sortedPaymentsArray
//                    CoreDataManager.shared.haveToUpdateFilteredPaymentsFlag = false
                default:
                    break
                }
                self.showInfo()
                self.reportTableView.reloadData()
                self.reportActivityIndicator.stopAnimating()
                self.tableViewActivityIndicator.stopAnimating()
            }
        }
        
    }
    
    private func showInfo() {
        infoExpenceLabel.text = String(expenceSumForInfo) + " " + Consts.strCurrency
        infoIncomeLabel.text = String(incomeSumForInfo) + " " + Consts.strCurrency
        infoTotalLabel.text = String(totalSumForInfo) + " " + Consts.strCurrency
    }
    
    private func calculateInfoFor(payments: [Payment], filter: FiltersModel) {
        let expencePayments = payments.filter { $0.type == .expence }
        let incomePayments = payments.filter { $0.type == .income }
        expenceSumForInfo = expencePayments.reduce(0, {$0 + $1.value})
        incomeSumForInfo = incomePayments.reduce(0, {$0 + $1.value})
        
        switch filter.type {
        case .income:
            totalSumForInfo = incomeSumForInfo
        case .expence:
            totalSumForInfo = expenceSumForInfo
        case .overal:
            totalSumForInfo = incomeSumForInfo - expenceSumForInfo
        }
        
    }
    
    private func filterAndPreparePaymentsArray(rawPayments: [Payment]) -> [[Payment]]{
        
        var resultArray = [[Payment]]()
        
        var dateSet : Set<Date> = []
        
        for pmt in rawPayments {

            dateSet.insert(pmt.date)
        }
        
        let sortedDateArr = dateSet.sorted(by: {$0 > $1})
        
        for date in sortedDateArr {
            
            var unsortedArr = [Payment]()
            
            for pmnt in rawPayments {
                
                if pmnt.date == date {
                    unsortedArr.append(pmnt)
                }
            }
            
            let sortedArr = unsortedArr.sorted(by: {$0.time > $1.time})
            resultArray.append(sortedArr)
        }
            return resultArray
    }
    
    private func intToString (int: Int) -> String {
        
        var str = String(int)
        if str.count < 2 {
            str = "0" + str
        }
        return str
    }
    
// MARK actions
  
    @IBAction func selectorChanged(_ sender: Any) {
        
        switch selector.selectedSegmentIndex {
        case ReportSelectorState.mounth.rawValue:
            filterBtn.isEnabled = false
            updateReportDataFor(selectorState: .mounth)
            infoViewVerticalConstraint.constant = 0
            infoImageView.image = UIImage()
        case ReportSelectorState.week.rawValue:
            filterBtn.isEnabled = false
            updateReportDataFor(selectorState: .week)
            infoViewVerticalConstraint.constant = 0
            infoImageView.image = UIImage()
        case ReportSelectorState.filter.rawValue:
            filterBtn.isEnabled = true
            updateReportDataFor(selectorState: .filter)
        default:
            break
        }
        
    }
    
    
     @IBAction func filtersButtonDidTap(_ sender: Any) {
        presentFiltesVC()
     }
     

}

extension ReportStatisticViewController: FiltersViewControllerDelegate {
    func filtersApplied(filters: FiltersModel) {
        manualFilter = filters
        uploadAndUpadteDataFor(filter: filters)
        
        switch filters.type {
        case .expence:
            infoViewVerticalConstraint.constant = -35
            infoImageView.image = UIImage(named: "expense_icon")
        case .income:
            infoViewVerticalConstraint.constant = -35
            infoImageView.image = UIImage(named: "income_icon")
        case .overal:
            infoViewVerticalConstraint.constant = 0
            infoImageView.image = UIImage()

        }
        
        
        
    }
   
}

extension ReportStatisticViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedPaymentsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPaymentsArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportTableViewCellId", for: indexPath) as! ReportTableViewCell
        let payment = sortedPaymentsArray[indexPath.section][indexPath.row]
        cell.initWith(payment: payment)

        return cell
    }
    
    
}

extension ReportStatisticViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if let payment = sortedPaymentsArray[section].first {
        
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMMM yyyy"
            formatter.locale = Locale(identifier: "RU_ru")
            let strDate = formatter.string(from: payment.date)
            return strDate
            
        } else { return ""}
        
        
    }
    
}
