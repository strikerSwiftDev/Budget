
import UIKit

class ExpenxeReportViewController: UIViewController {

    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var graphView: ExpenceReportGraphView!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var values = [Double]()
    
    private var counter = 0 {
        didSet {
            counterLabel.text = String(counter)
            if counter >= 0 {
                nextButton.isEnabled = false
                nextButton.alpha = 0.2
            }else {
                nextButton.isEnabled = true
              nextButton.alpha = 1
            }
            showReport()
        }
    }
    
    private var displayMode: ExpenceReportMode = .month
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControl.selectedSegmentIndex = 0
        counter = 0
        initTableView()
        showReport()
    }
    
    private func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "ExpenceGraphReportTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ExpenceGraphReportTableViewCellId")
        
//        tableView.tableFooterView = UIView()
    }
    
    
    
    private func showReport() {
        activityIndicator.startAnimating()
        
        let filter = FiltersModel()
        let date = Date()
        var components = DateComponents()
        filter.type = .expence
        
        
        switch displayMode {
        case .month:
            components.year = Calendar.current.component(.year, from: date)
            components.month = Calendar.current.component(.month, from: date)
            components.day = 1
        case .week:
            let weekday = Calendar.current.component(.weekday, from: date) - 2
            let targetDate = Calendar.current.date(byAdding: .day, value: -weekday, to: date)!
            
            components.year = Calendar.current.component(.year, from: targetDate)
            components.month = Calendar.current.component(.month, from: targetDate)
            components.day = Calendar.current.component(.day, from: targetDate)
        }
        
        let newDate = Calendar.current.date(from: components)
        filter.fromDate = newDate
        uploadDataFor(filter: filter)
        
    }
    
    private func uploadDataFor(filter: FiltersModel) {
        
        DispatchQueue.global().async {
            let fiteredPaymentsFromCoreData = CoreDataManager.shared.loadConvertedPaymentsWith(filter: filter)
            self.values = self.preparedValuesFrom(rawPayments: fiteredPaymentsFromCoreData)
            DispatchQueue.main.async {
                  
                self.activityIndicator.stopAnimating()
                self.graphView.setReportModeAndDisplayGraph(mode: self.displayMode, values: self.values)
                self.tableView.reloadData()
            }
            
        }
            
    }
    
    private func preparedValuesFrom(rawPayments: [Payment]) -> [Double] {
        
        print(rawPayments)
        
        return [13,20,10,12.8, 38]
    }
    
    
    
    
//MARK: ACTIONS
    @IBAction func segmentControlChanged(_ sender: Any) {
        counter = 0
        switch segmentControl.selectedSegmentIndex {
        case 0:
            displayMode = .month
        default:
            displayMode = .week
        }
        showReport()
    }
    
    @IBAction func prevButtonDidTap(_ sender: Any) {
        counter -= 1
    }
    
    @IBAction func nextButtonDidTap(_ sender: Any) {
        counter += 1
    }
    
}

extension ExpenxeReportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        if let payment = sortedPaymentsArray[section].first {
//
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd MMMM yyyy"
//            formatter.locale = Locale(identifier: "RU_ru")
//            let strDate = formatter.string(from: payment.date)
//            return strDate
//
//        } else { return ""}
//
//
//    }
    
}

extension ExpenxeReportViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return values.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenceGraphReportTableViewCellId", for: indexPath) as! ExpenceGraphReportTableViewCell
        cell.initCell(value: values[indexPath.row])

        return cell
    }
    
    
}
