
import Foundation
import UIKit

class CompareObjectModel {
    
    let category:String!
    let subcategory:String!
    let value:Double!
    let color: UIColor!
    
    init(category: String = "", subcategory: String = "", value: Double = 0.0, color:UIColor = .clear) {
        self.category = category
        self.subcategory = subcategory
        self.value = value
        self.color = color
    }
    
}
