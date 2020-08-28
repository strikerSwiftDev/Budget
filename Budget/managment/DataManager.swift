
import Foundation

import UIKit

class DataManager {
    static let shared = DataManager()
  
    private var categories = [String]() {
        didSet {
            UserDefaults.standard.set(categories, forKey: categoriesUserDefaultsKey)
        }
    }
    private var subCategories = [String:[String]]() {
        didSet {
            UserDefaults.standard.set(subCategories, forKey: subcategoriesUserDefaultsKey)
        }
    }
    
    private var launchedBefore = false
    
    private var theVeryFirstDate: Date!
    
    private var payments = [Payment]()
    
    private var shortStringCurrency = ""
    
    private var firstWeekday = FirstWeekDay.monday
    
    private var locale = LocaleIdentificator.english
    
    private var userinterfaceStyleIndex = 1
    
    // userdefaults keys
    private let categoriesUserDefaultsKey = "categories"
    private let subcategoriesUserDefaultsKey = "subcategories"
    private let firstLaunchFlagUserDefaultsKey = "launchedBefore"
    private let theVeryFirstDateUserDefaultsKey = "theVeryFirstDate"
    private let shortStringCurrencyUserDefaultsKey = "shortStringCurrency"
    private let firstWeekDayUserDefaultsKey = "firstWeekDay"
    private let userinterfaceStyleIndexUserDefaultsKey = "userinterfaceStyleIndex"
    
    private init () {
        
        
    }
//MARK INIT
    
    //вызывать метод в первую очередь
    func initializeUserData () {
        
        if applicationLaunchedBefore() {
            loadSimpleData()
        } else {
            initializeFirtLaunch()
            UserDefaults.standard.set(true, forKey: firstLaunchFlagUserDefaultsKey)

        }
        
        if let startDate = UserDefaults.standard.object(forKey: theVeryFirstDateUserDefaultsKey) as? Date
        {
            theVeryFirstDate = startDate
            
        } else {
            theVeryFirstDate = Date()
            UserDefaults.standard.set(theVeryFirstDate, forKey: theVeryFirstDateUserDefaultsKey)
        }
        
        _ = CoreDataManager.shared
        
        shortStringCurrency = UserDefaults.standard.string(forKey: shortStringCurrencyUserDefaultsKey) ?? Consts.defaultStrCurrency
        let weekdayRawValue = UserDefaults.standard.integer(forKey: firstWeekDayUserDefaultsKey)
        
        firstWeekday = FirstWeekDay(rawValue: weekdayRawValue) ?? FirstWeekDay.monday
        
        userinterfaceStyleIndex = UserDefaults.standard.integer(forKey: userinterfaceStyleIndexUserDefaultsKey)
        setUserInterfaceStyleByIndex(index: userinterfaceStyleIndex)
        
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
    }
    
    // MARK: DIFFERENT
    
    func setUserInterfaceStyleByIndex(index: Int) {
        
        userinterfaceStyleIndex = index
        
        UserDefaults.standard.set(userinterfaceStyleIndex, forKey: userinterfaceStyleIndexUserDefaultsKey)
        
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
          fatalError("could not get scene delegate ")
        }
        
        let style = UIUserInterfaceStyle(rawValue: userinterfaceStyleIndex) ?? UIUserInterfaceStyle.unspecified

        sceneDelegate.setUserInterfaceStyleTo(style: style)

    }
    
    func getUserinterfaceStyleIndex() -> Int {
        return userinterfaceStyleIndex
    }
    
    func setLocale(newLocale:String) {
        
        if newLocale.hasPrefix("ru") || newLocale.hasPrefix("uk")  {
            locale = .russian
        } else {
            locale = .english
        }
        
        
    }
    
    func getLocale() -> LocaleIdentificator {
        return locale
    }
    
    func setFirstWeekayTo(weekday: FirstWeekDay) {
        firstWeekday = weekday
        
        UserDefaults.standard.set(weekday.rawValue, forKey: firstWeekDayUserDefaultsKey)
        
    }
    
    func getFierstWeekDay() -> FirstWeekDay {
        
        return firstWeekday
    }
    
    //
    
    func getShortStringCurrency() -> String {
        
        return shortStringCurrency
    }
    
    func saveNewShortStringCurrency(currency: String) {
        
        UserDefaults.standard.set(currency, forKey: shortStringCurrencyUserDefaultsKey)
        shortStringCurrency = currency
    }
    
    func getTheVeryFirstDate() -> Date {
        return theVeryFirstDate
    }
    
    
    // MARK: SAVE AND LOAD
    

    
    private func applicationLaunchedBefore() -> Bool {
        return UserDefaults.standard.bool(forKey: firstLaunchFlagUserDefaultsKey)
    }
    
    private func initializeFirtLaunch () {
        categories = Consts.defaultCategories
        subCategories = Consts.defaultSubCategories
    }
    
    func loadSimpleData() {
        categories = UserDefaults.standard.object(forKey: categoriesUserDefaultsKey) as? [String] ?? [String]()
        subCategories = UserDefaults.standard.object(forKey: subcategoriesUserDefaultsKey) as? [String: [String]] ?? [String: [String]]()
    }
      
    func resetSimpleData() {
        UserDefaults.standard.removeObject(forKey: categoriesUserDefaultsKey)
        UserDefaults.standard.removeObject(forKey: subcategoriesUserDefaultsKey)
        UserDefaults.standard.removeObject(forKey: firstLaunchFlagUserDefaultsKey)
        UserDefaults.standard.removeObject(forKey: firstWeekDayUserDefaultsKey)
        UserDefaults.standard.removeObject(forKey: shortStringCurrencyUserDefaultsKey)
        UserDefaults.standard.removeObject(forKey: userinterfaceStyleIndexUserDefaultsKey)
        initializeUserData()
    }
    
    
    
    
}
