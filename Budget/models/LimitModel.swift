
import Foundation


struct LimitModel {
    
    let cateory: String
    let value: Double
    let regular: Bool
    
    
    init(category: String, value: Double, regular:Bool) {
        
        self.cateory = category
        self.value = value
        self.regular = regular
        
    }
    
}
