
import UIKit

class GraphReportTableViewCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var colorIndicatorView: GraphReportTableViewCell!
    @IBOutlet weak var indicatorImage: UIImageView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var subcategoriesLabel: UILabel!

    @IBOutlet weak var fromDateLabel: UILabel!
    
    @IBOutlet weak var toDateLabel: UILabel!
    
    private var strCurrency = DataManager.shared.getShortStringCurrency()
    private let selectAllStr = "< ВСЕ >"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func setupCellFor(compareObject: CompareObjectModel)  {
        valueLabel.text = String(compareObject.value) + " " + strCurrency
        colorIndicatorView.backgroundColor = compareObject.color
        colorIndicatorView.layer.cornerRadius = 10

        var category = ""
        var subCategory = ""
        
        if  compareObject.category != nil, !compareObject.category.isEmpty {
            category = compareObject.category
        } else {
            category = selectAllStr
        }
        if  compareObject.subcategory != nil, !compareObject.subcategory.isEmpty {
            subCategory = compareObject.subcategory

        } else {
            subCategory = selectAllStr
        }
        
        categoriesLabel.text = category
        subcategoriesLabel.text = subCategory
        
        fromDateLabel.text = "от " + convertDateToString(date: compareObject.fromDate)
        toDateLabel.text = "до " + convertDateToString(date: compareObject.toDate)
        
        indicatorImage.backgroundColor = .clear
        
        switch compareObject.type {
            case .expence:
                indicatorImage.image = UIImage(named: "expense_icon")

            case .income:
                indicatorImage.image = UIImage(named: "income_icon")

            default:
                indicatorImage.image = UIImage()
                indicatorImage.backgroundColor = .yellow

            }
        
    }
    
    private func convertDateToString(date: Date?) -> String {
        
        if date == nil {
            return "-/-"
        }
        
        if date == Consts.wrongDate {
            return "-/- "
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = Locale(identifier: "RU_ru")
        let str = formatter.string(from: date!)
        return str
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
