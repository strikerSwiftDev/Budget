
import Foundation

class LimitsManager {
    static let shared = LimitsManager()
    
    private let limitsUserDefaultKey = "limitsUserDefaultKey"
    
    private var limits = [LimitModel]()
    private var expenceSumm = [(String, Double)]()
    
    
    func initLimitsAndExpences () {
        uploadMonthExpences()
        uploadLimits()
        
    }
    
    private func uploadLimits () {

        limits = []
        if let objects = UserDefaults.standard.value(forKey: limitsUserDefaultKey) as? Data {
           let decoder = JSONDecoder()
           if let objectsDecoded = try? decoder.decode(Array.self, from: objects) as [LimitModel] {
              limits = objectsDecoded
           }
        }

    }
    
    private func addNew(category: String) {
        if !category.isEmpty {
            let newCategory = (category, 0.0)
            expenceSumm.append(newCategory)
        }
    }
    
    private func uploadMonthExpences() {
        // use bacground tread only
        
        let today = Date()
        
        var dateComponents = DateComponents()
        dateComponents.year = Calendar.current.component(.year, from: today)
        dateComponents.month = Calendar.current.component(.month, from: today)
        dateComponents.day = 1
        let targetDate = Calendar.current.date(from: dateComponents)
        
        let paymentType = PaymentType.expence
        
        let filter = FiltersModel()
        filter.fromDate = targetDate
        filter.type = paymentType
        
        let payments = CoreDataManager.shared.loadConvertedPaymentsWith(filter: filter)
        
        convertPaymentsToExpenceSumm(payments: payments)
    }
    
    private func convertPaymentsToExpenceSumm(payments: [Payment]) {
        expenceSumm = []
        let categories = DataManager.shared.getCategories()
        
        for category in categories {
            
           let filteredArr = payments.filter{$0.category == category}
            
            let value = filteredArr.reduce(0, {$0 + $1.value})
            let obj = (category, value)
            expenceSumm.append(obj)
            
        }
        
    }
    
    func updateExpencesAfterPayment(category: String, value: Double) {
        
        var newExpenceSum = expenceSumm.filter() {$0.0 != category}
        let expences = expenceSumm.filter(){$0.0 == category}
        guard let expence = expences.first else {return}
        
        let newValue = expence.1 + value
        let newExpence = (category, newValue)
        
        newExpenceSum.append(newExpence)
        expenceSumm = newExpenceSum
 
    }
    
    func proceedNewMonth() {
        deleteAllNotRegularLimits()
    }
    
    func deleteAllLimits() {
        UserDefaults.standard.removeObject(forKey: limitsUserDefaultKey)
        limits = []
    }
    
    func deleteAllNotRegularLimits()  {
        let reguLarLimits = limits.filter() {$0.regular == true}
        limits = reguLarLimits
        reSaveLimits()
    }
    
    func deleteLimit(for category: String)  {
        UserDefaults.standard.removeObject(forKey: limitsUserDefaultKey)
        let newLimits = limits.filter() {$0.category != category}
        limits = newLimits
        reSaveLimits()
    }
    
    func addLimitForCategory(limit : LimitModel) {
        limits.append(limit)
        reSaveLimits()
    }
    
    private func reSaveLimits() {
        UserDefaults.standard.removeObject(forKey: limitsUserDefaultKey)

        let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(limits){
            UserDefaults.standard.set(encoded, forKey: limitsUserDefaultKey)
        }

    }
    
    func getLimits() -> [LimitModel] {
        return limits
    }
    
    func getExpences() -> [(String, Double)] {
        return expenceSumm
    }
    
    
    
    
    
    
}
