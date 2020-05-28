
import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    var haveToUpdateMonthPaymentsFlag = true
    var haveToUpdateWeekPaymentsFlag = true
    var haveToUpdateFilteredPaymentsFlag = true
    
    private let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer

    private let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {}
    
    private func resetReportFlags () {
        haveToUpdateMonthPaymentsFlag = true
        haveToUpdateWeekPaymentsFlag = true
        haveToUpdateFilteredPaymentsFlag = true
    }
    
// MARK - SAVING
    
    func savePayment(payment: Payment) {
        
        let paymnt = NSEntityDescription.insertNewObject(forEntityName: "PaymentEntity", into: context)
        
        paymnt.setValue(payment.category, forKey: "category")
        paymnt.setValue(payment.subcategory, forKey: "subcategory")
        paymnt.setValue(payment.type.rawValue, forKey: "type")
        paymnt.setValue(payment.value, forKey: "value")
        paymnt.setValue(payment.paymentDate, forKey: "paymentDate")
            
        do {
            
            try context.save()
           }
        catch
        {
               let nserror = error as NSError
               NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
               abort()
        }
        
        resetReportFlags()
        
    }

//MRK -LOADING
    
    func loadConvertedPaymentsWith(filter: FiltersModel) -> [Payment] {
        return convertPaymentsToPaymentModel(coreDataPaymentsArray: loadPaymentsWith(filter: filter))
    }
    
    
    func loadPaymentsWith(filter: FiltersModel) -> [NSManagedObject] {
        
//        print ("""
//            filter:
//            category - \(filter.category )
//            subcategory - \(filter.subcategory )
//                from - \(filter.fromDate)
//                to - \(filter.toDate)
//            """)
        
        var predicates = [NSPredicate]()
 
        if filter.type != .overal {
            let predicate = NSPredicate(format: "type == %@", filter.type.rawValue)
            predicates.append(predicate)
        }

        if !filter.category.isEmpty {
            let predicate = NSPredicate(format: "category == %@", filter.category)
            predicates.append(predicate)
        }
        
        if !filter.subcategory.isEmpty {
           let predicate = NSPredicate(format: "subcategory == %@", filter.subcategory)
           predicates.append(predicate)
       }
        
        if filter.fromDate != nil {
            let predicate = NSPredicate(format: "paymentDate >= %@", filter.fromDate! as NSDate)
            predicates.append(predicate)
        }
        
        if filter.toDate != nil {
            let predicate = NSPredicate(format: "paymentDate >= %@", filter.toDate! as NSDate)
            predicates.append(predicate)
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PaymentEntity")
        let compound = NSCompoundPredicate.init(andPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compound
        
        do {
            let pmtns = try context.fetch(fetchRequest)
            return pmtns
        } catch let error as NSError {
                print(error)
                return []
        }
        
    }
    

    func convertPaymentsToPaymentModel(coreDataPaymentsArray: [NSManagedObject] ) -> [Payment] {
        
        var payments = [Payment]()
    
        for pmt in coreDataPaymentsArray {
            let stringType = (pmt.value(forKey: "type") as? String) ?? "no value"
            
            var type: PaymentType
            
            switch stringType {
            case PaymentType.income.rawValue:
                type = .income
            case PaymentType.expence.rawValue:
                type = .expence
            default:
                type = .overal
            }
            
            let category = (pmt.value(forKey: "category") as? String) ?? "no value"
            let subcategory = (pmt.value(forKey: "subcategory") as? String) ?? "no value"
            let value = (pmt.value(forKey: "value") as? Double) ?? 0.0
            let paymentDate = (pmt.value(forKey: "paymentDate") as? Date) ?? Consts.wrongDate
            
            let paymentModel = Payment(type: type, category: category, subcategory: subcategory, value: value, paymentDate: paymentDate)

            payments.append(paymentModel)
        }
        
        return payments
    }
    
    
// MARK - DELETING
    
    func deleteAllPayments() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PaymentEntity")
        
        do {
            let payments = try context.fetch(fetchRequest)
            
            for payment in payments {
                context.delete(payment)
            }
            
        } catch let error as NSError {
            print(error)
        }
        
        resetReportFlags()
        let date = Date()
        UserDefaults.standard.set(date, forKey: "theVeryFirstDate")

    }
    
    func deletePaymentsFor(category: String) {
        
        resetReportFlags()
        
        let filter = FiltersModel()
        filter.category = category
        
        let paymentEntities = loadPaymentsWith(filter: filter)
        for payment in paymentEntities {
            context.delete(payment)
        }
        
//        print("deletePaymentsForCategory \(category)")
    }
    
    func deletePaymentsFor(subcategory: String, inCategory:String) {
        
        resetReportFlags()
        
        let filter = FiltersModel()
        filter.category = inCategory
        filter.subcategory = subcategory
        
        let paymentEntities = loadPaymentsWith(filter: filter)
        for payment in paymentEntities {
            context.delete(payment)
        }
        
//        print("deletePaymentsForSubcategory \(subcategory)")
    }
    
    func setPaymentsAsUncatgorizedFor(subcategory: String, inCategory: String) {
        
        resetReportFlags()
        
        let filter = FiltersModel()
        filter.category = inCategory
        filter.subcategory = subcategory
        
        let paymentEntities = loadPaymentsWith(filter: filter)
        for payment in paymentEntities {
            payment.setValue(Consts.subcategoriesEmptyPlaceholder, forKey: "subcategory")
        }
        
        
        do
        {
            try context.save()
        }
        catch
        {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
//        print("setPaymentsAsUncatgorizedFor \(subcategory)")
    }
    
}
