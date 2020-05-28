
import Foundation

class DataManager {
    static let shared = DataManager()
  
    private var categories = [String]() {
        didSet {
            UserDefaults.standard.set(categories, forKey: strKeyForCategories)
        }
    }
    private var subCategories = [String:[String]]() {
        didSet {
            UserDefaults.standard.set(subCategories, forKey: strKeyForSubcategories)
        }
    }
    
    private var launchedBefore = false
    
    private var theVeryFirstDate: Date!
    
    private var payments = [Payment]()
    
    // userdefaults keys
    private let strKeyForCategories = "categories"
    private let strKeyForSubcategories = "subcategories"
    private let strKeyForFirstLaunchFlag = "launchedBefore"
    private let theVeryFirstDateKey = "theVeryFirstDate"
    
    private init () {
        
        
    }
    
//MARK: categories

    func addCtegory(title: String){
        categories.insert(title, at: 0)
        subCategories[title] = []
    }
    
    func delete(category:String, row:Int) {
        if categories[row] == category {
            categories.remove(at: row)
            subCategories[category] = nil
        }else {
            print("ошибка - удаляемая категория не соответсвует позиции в массиве")
        }
        
    }
    
    func getCategories() -> [String] {
        return categories
    }
    
    func moveCategoryFrom(position:Int, toPosition:Int) {
        let category = categories.remove(at: position)
        categories.insert(category, at: toPosition)
    }
    
    func isExist (category: String) -> Bool {
        for title in categories {
            if title == category {
                return true
            }
        }
        return false
    }

    
    //    MARK subcategories
    
    func addSubCtegory(title: String, forCategory: String) {
        
        if var subcategories = subCategories[forCategory] {
            subcategories.insert(title, at: 0)
            subCategories[forCategory] = subcategories
        }

    }
    
    func delete(subcategory:String, inCategory:String, row:Int) {
        if var subcategories = subCategories[inCategory] {
            subcategories.remove(at: row)
            subCategories[inCategory] = subcategories
        }

    }

    
    func getSubCategoriesForCategory(category:String) -> [String] {
        if let subcategories = subCategories[category] {
            return subcategories
        } else {
            return []
        }
        
    }
    
    func moveSubcategoryFor(category: String, fromPosition:Int, toPosition: Int) {
        if var subcategories = subCategories[category] {
            let subcategory = subcategories.remove(at: fromPosition)
            subcategories.insert(subcategory, at: toPosition)
            
            subCategories[category] = subcategories
        }
    }
    
    func isExist (subcategory: String, inCategory: String) -> Bool {
        
        if let subcategories = subCategories[inCategory] {
            for title in subcategories {
                if title == subcategory {
                    return true
                }
            }
        }
        
        return false
    }
    
    //MARK: PAYMENTS
    
    func addPayment(payment: Payment) {
        payments.append(payment)
//        print(payment)
    }
    
    // MARK: SAVE AND LOAD
    
    //вызывать метод в первую очередь
    func initializeUserData () {
        
        if applicationLaunchedBefore() {
            loadSimpleData()
        } else {
            initializeFirtLaunch()
            UserDefaults.standard.set(true, forKey: strKeyForFirstLaunchFlag)

        }
        
        if let startDate = UserDefaults.standard.object(forKey: theVeryFirstDateKey) as? Date
        {
            theVeryFirstDate = startDate
            
        } else {
            theVeryFirstDate = Date()
            UserDefaults.standard.set(theVeryFirstDate, forKey: theVeryFirstDateKey)
        }
        
        _ = CoreDataManager.shared
        
        
    }
    
    func getTheVeryFirstDate() -> Date {
        return theVeryFirstDate
    }
    
    private func applicationLaunchedBefore() -> Bool {
        return UserDefaults.standard.bool(forKey: strKeyForFirstLaunchFlag)
    }
    
    private func initializeFirtLaunch () {
        categories = Consts.defaultCategories
        subCategories = Consts.defaultSubCategories
    }
    
    func loadSimpleData() {
        categories = UserDefaults.standard.object(forKey: strKeyForCategories) as? [String] ?? [String]()
        subCategories = UserDefaults.standard.object(forKey: strKeyForSubcategories) as? [String: [String]] ?? [String: [String]]()
    }
    
//    func saveSimpleData () {
//        UserDefaults.standard.set(categories, forKey: "categories")
//        UserDefaults.standard.set(subCategories, forKey: "subcategories")
//    }
    
    func resetSimpleData() {
        UserDefaults.standard.removeObject(forKey: strKeyForCategories)
        UserDefaults.standard.removeObject(forKey: strKeyForSubcategories)
        UserDefaults.standard.removeObject(forKey: strKeyForFirstLaunchFlag)
        initializeUserData()
    }
    
    
    
    
}
