//
//  PaymentsGenerator.swift
//  Budget
//
//  Created by Anatoliy Anatolyev on 24.04.2020.
//  Copyright © 2020 Anatoliy Anatolyev. All rights reserved.
//

import Foundation


class PaymentsGenerator  {
    
    
    var minimalDate = Date()
    let categories = DataManager.shared.getCategories()
    
    
    init () {
        
    }
    
    
    func generateRandomPayments(quantity: Int) {
        
        for _ in 0...quantity {
            
            let value = Int.random(in: 0...1000)
            
            let category = categories.randomElement() ?? Consts.categoriesEmptyPlaceholder
            
            var subcategories = DataManager.shared.getSubCategoriesForCategory(category: category)
            subcategories.insert(Consts.subcategoriesEmptyPlaceholder, at: 0)
            let subcategory = subcategories.randomElement() ?? Consts.subcategoriesEmptyPlaceholder
            
            let typeIndex = Int.random(in: 0...1)
            var type = PaymentType.overal
            switch typeIndex {
            case 0:
                type = .income
            default:
                type = .expence
            }
            
            let date = getGeneratedCorrectDate()

            let payment = Payment(type: type, category: category, subcategory: subcategory, value: Double(value), paymentDate: date)
            
            if date < minimalDate {
                minimalDate = date
            }
            
            CoreDataManager.shared.savePayment(payment: payment)
            
        }
            
        UserDefaults.standard.set(minimalDate, forKey: "theVeryFirstDate")
        
    }
    
    func getGeneratedCorrectDate() -> Date {

        var date = Date()
        let today = Date()
        
        repeat {
            let year = 2020 - Int.random(in: 0...1)
            let month = Int.random(in: 1...12)
            let day = Int.random(in: 1...29)

            let hour = Int.random(in: 0...23)
            let minute = Int.random(in: 0...59)

            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = day
            components.hour = hour
            components.minute = minute

            date = Calendar.current.date(from: components) ?? today
            
        } while date > today
        
        return date
    }
    
    
}
