
import Foundation

class StatReportObjectModel {
    
    var name = ""
    var value = 0.0
    var mode = TableViewMode.categories
    var type = PaymentType.expence
    
    init(name:String, value: Double, mode: TableViewMode, type: PaymentType) {
        self.name = name
        self.value = value
        self.mode = mode
        self.type = type
    }
    
    
}
