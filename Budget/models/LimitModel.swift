
import Foundation


struct LimitModel: Encodable, Decodable {
    
    let category: String
    let value: Double
    let regular: Bool
    
    
    init(category: String, value: Double, regular:Bool) {
        
        self.category = category
        self.value = value
        self.regular = regular
        
    }
    
}
