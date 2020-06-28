
import Foundation
import UIKit

class CompareObjectModel {
    
    let category:String!
    let subcategory:String!
    let value:Double!
    let color: UIColor!
    let type: PaymentType!
    var fromDate: Date!
    var toDate: Date!
    
    init(category: String = "", subcategory: String = "", value: Double = 0.0, color:UIColor = .clear, type: PaymentType = .overal, fromDate: Date = Consts.wrongDate, toDate: Date = Consts.wrongDate) {
        
        self.category = category
        self.subcategory = subcategory
        self.value = value
        self.color = color
        self.type = type
        self.fromDate = fromDate
        self.toDate = toDate
    }
    
}
