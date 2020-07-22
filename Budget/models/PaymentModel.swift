
import Foundation

struct Payment {
    var type: PaymentType
    let category:String!
    var subcategory:String
    var value: Double
    var year: Int
    var month: Int
    var weekOfYear: Int
    var weekDay: Int
    var day: Int
    var hour: Int
    var minute: Int
    var paymentDate: Date
    var normalWeekDay: Int
    
    var date = Date()
    var time = Date()
    
    var dateInSecondsSince2001 = 0
    
    init (type: PaymentType, category:String, subcategory:String, value:Double, paymentDate:Date) {
        self.type = type
        self.category = category
        self.subcategory = subcategory
        self.value = value
        self.paymentDate = paymentDate
        
        
        self.year = Calendar.current.component(.year, from: paymentDate)
        self.month = Calendar.current.component(.month, from: paymentDate)
        self.weekOfYear = Calendar.current.component(.weekOfYear, from: paymentDate)
        self.weekDay = Calendar.current.component(.weekday, from: paymentDate)
        self.day = Calendar.current.component(.day, from: paymentDate)
        self.hour = Calendar.current.component(.hour, from: paymentDate)
        self.minute = Calendar.current.component(.minute, from: paymentDate)
        
        var componentsForDate = DateComponents()
        var componentsForTime = DateComponents()
        
        componentsForDate.year = year
        componentsForDate.month = month
        componentsForDate.day = day
        componentsForDate.hour = 0
        componentsForDate.minute = 0
        
        componentsForTime.year = 0
        componentsForTime.month = 0
        componentsForTime.day = 0
        componentsForTime.hour = hour
        componentsForTime.minute = minute
        
        date = Calendar.current.date(from: componentsForDate) ?? Consts.wrongDate
        time = Calendar.current.date(from: componentsForTime) ?? Consts.wrongDate
        dateInSecondsSince2001 = Int(date.timeIntervalSinceReferenceDate)
        
        if weekDay == 1 {
            normalWeekDay = 7
        } else {
            normalWeekDay = weekDay - 1
        }
        
//        print(weekDay, normalWeekDay)
//        print(dateInSecondsSince2001)
    }
}
