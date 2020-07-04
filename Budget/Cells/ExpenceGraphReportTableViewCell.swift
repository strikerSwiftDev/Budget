
import UIKit

class ExpenceGraphReportTableViewCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    public func initCell (value: Double) {
        valueLabel.text = String(value)
    }
}
