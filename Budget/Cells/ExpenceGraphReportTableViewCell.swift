
import UIKit

class ExpenceGraphReportTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var bigDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    public func initCellWithCompareObj (compareObj: EspenceReportCompareObjectModel, displayMode: ExpenceReportMode) {
        if let value = compareObj.value {
            valueLabel.text = String(value) + " " + DataManager.shared.getShortStringCurrency()
        } else {
            valueLabel.text = "!! no value !!"
        }
        
        if let date = compareObj.date {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "RU_ru")
            formatter.dateFormat = "EE"
            let strWeekDay = formatter.string(from: date)
            formatter.dateFormat = "dd MMMM yyyy" + " г"
            let strDateforWeekMode = formatter.string(from: date)
            
            formatter.dateFormat = "dd"
            let strDay = formatter.string(from: date)
            formatter.dateFormat = "MMMM yyyy" + " г" + ",    " + "EE"
            let strDateForMonthMode = formatter.string(from: date)
            
            switch displayMode {
            case .month:
                bigDateLabel.text = strDay
                dateLabel.text = strDateForMonthMode
            case .week:
                bigDateLabel.text = strWeekDay
                dateLabel.text = strDateforWeekMode
            }

        } else {
            dateLabel.text = "!!! no date !!!"
        }
        
    }
}
