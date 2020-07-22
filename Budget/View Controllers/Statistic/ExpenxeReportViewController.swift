
import UIKit

class ExpenxeReportViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var graphView: ExpenceReportGraphView!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var startDate = Consts.wrongDate
    private var finishDate = Consts.wrongDate
    private let theVeryFirsDate = DataManager.shared.getTheVeryFirstDate()
    private let todayDate = Date()
    
    private var values = [EspenceReportCompareObjectModel]()
    
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
        
        navigationController?.navigationBar.tintColor = .label
        navigationItem.largeTitleDisplayMode = .never
        
        segmentControl.selectedSegmentIndex = 0
        initTableView()
        counter = 0

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
        
        let filter = calculatedFilterByDates()
        
        checkMinimumDateRangeLimit()
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "RU_ru")
        formatter.dateFormat = "LLLL" + " " + "yyyy" + " г"
        let strDate1 = formatter.string(from: startDate)
        formatter.dateFormat = "MMMM" + " " + "yyyy" + " г"
        let strDate2 = formatter.string(from: startDate)
        formatter.dateFormat = "dd"
        let strFromDay = formatter.string(from: startDate)
        let strToDay = formatter.string(from: finishDate)
        
        switch displayMode {
        case .month:
            infoLabel.text = strDate1
        case .week:
            infoLabel.text = strFromDay + " - " + strToDay + "    " + strDate2
        }
       
        uploadDataFor(myFilter: filter)
    }
    
    private func calculatedFilterByDates() -> FiltersModel {
        
        let filter = FiltersModel()
        var components = DateComponents()
        filter.type = .expence
        
        let monthDiff = 1 * counter
        let weekDiff = 7 * counter
        
        switch displayMode {
        case .month:
            guard let targetDate = Calendar.current.date(byAdding: .month, value: monthDiff, to: todayDate) else {break}
            
            components.year = Calendar.current.component(.year, from: targetDate)
            components.month = Calendar.current.component(.month, from: targetDate)
            components.day = 1
            startDate = Calendar.current.date(from: components)!
            
            let date1 = Calendar.current.date(byAdding: .month, value: 1, to: startDate)!
            finishDate = Calendar.current.date(byAdding: .day, value: -1, to: date1)!

        case .week:
            let weekday = Calendar.current.component(.weekday, from: todayDate) - 2 - weekDiff
            let targetDate = Calendar.current.date(byAdding: .day, value: -weekday, to: todayDate)!
            
            components.year = Calendar.current.component(.year, from: targetDate)
            components.month = Calendar.current.component(.month, from: targetDate)
            components.day = Calendar.current.component(.day, from: targetDate)
            
            startDate = Calendar.current.date(from: components)!
            finishDate = Calendar.current.date(byAdding: .day, value: 7, to: startDate)!
        }
        
        if finishDate > todayDate {
            finishDate = todayDate
        }
        
        filter.fromDate = startDate
        filter.toDate = finishDate

        return filter
        
    }
    
    
    private func uploadDataFor(myFilter: FiltersModel) {

        DispatchQueue.global().async {
            let fiteredPaymentsFromCoreData = CoreDataManager.shared.loadConvertedPaymentsWith(filter: myFilter)
            let result = self.preparedCompareObjectsFrom(rawPayments: fiteredPaymentsFromCoreData)
            self.values = result.0
            let shift = result.1
            
            DispatchQueue.main.async {
                  
                self.activityIndicator.stopAnimating()
                self.graphView.setReportModeAndDisplayGraph(mode: self.displayMode, compareObjects : self.values, shift: shift)
                self.tableView.reloadData()
            }
            
        }
            
    }
    
    private func preparedCompareObjectsFrom(rawPayments: [Payment]) -> ([EspenceReportCompareObjectModel], Int) {

        let startCount = 1
        var endCount = 0
//        var shift = 0
        let shift = 0
        
        switch displayMode {
        case .month:
            endCount = Calendar.current.component(.day, from: finishDate)
        case .week:
            endCount = startCount + 6
        }
        
        var compareObjs = [EspenceReportCompareObjectModel]()
        
        for i in startCount...endCount {
            
            var paymentsByTheDay = [Payment]()
            
            switch displayMode {
            case .month:
                paymentsByTheDay = rawPayments.filter{$0.day == i}
            case .week:
                paymentsByTheDay = rawPayments.filter{$0.normalWeekDay == i}
            }
            
            let date = Calendar.current.date(byAdding: .day, value: (i - 1), to: startDate) ?? Consts.wrongDate
            
//            if date! < theVeryFirsDate {
//                shift += 1
//                continue
//            }
            
            if date > todayDate {
                break
            }
            
            let compareObj = EspenceReportCompareObjectModel(value: 0, date: date)

            if !paymentsByTheDay.isEmpty {
                let value = paymentsByTheDay.reduce(0, {$0 + $1.value})
                compareObj.value = value
            }
            
            compareObjs.append(compareObj)
            
        }

        return (compareObjs, shift)
    }
    
    private func checkMinimumDateRangeLimit() {

        if startDate <= theVeryFirsDate {
            previousButton.isEnabled = false
            previousButton.alpha = 0.2
        } else {
            previousButton.isEnabled = true
            previousButton.alpha = 1
        }
        
    }
    
    
    
    
//MARK: ACTIONS
    @IBAction func segmentControlChanged(_ sender: Any) {
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            displayMode = .month
        default:
            displayMode = .week
        }
        
        counter = 0

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
        graphView.showMarkCollumn(index: indexPath.row)
    }
    
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
        cell.initCellWithCompareObj(compareObj: values[indexPath.row], displayMode: displayMode)

        return cell
    }
    
    
}
