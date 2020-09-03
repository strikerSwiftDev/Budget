
import UIKit

class LimitsEmptyTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initFor(category: String) {
        categoryLabel.text = category
    }
    
    
    
}
