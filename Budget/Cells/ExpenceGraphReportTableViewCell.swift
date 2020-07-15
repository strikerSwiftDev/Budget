
import UIKit

class ExpenceGraphReportTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    public func initCellWithCompareObj (compareObj: EspenceReportCompareObjectModel) {
        if let value = compareObj.value {
            valueLabel.text = String(value) + " " + Consts.strCurrency
        } else {
            valueLabel.text = "!! no value !!"
        }
        
        if let date = compareObj.date {
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "RU_ru")
            formatter.dateFormat = "EE" + ",   " + "dd MMMM yyyy" + " г"

            dateLabel.text = formatter.string(from: date)
        } else {
            dateLabel.text = "!!! no date !!!"
        }
        
    }
}
