

import Foundation

enum PaymentType: String {
    case income = "Доход"
    case expence = "Расход"
    case overal = "Общий"
}

enum ReportSelectorState: Int {
    case mounth = 0
    case week = 1
    case filter = 2
}


enum CategoryType {
    case category
    case subcategory
}




