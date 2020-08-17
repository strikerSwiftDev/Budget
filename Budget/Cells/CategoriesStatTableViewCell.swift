
import UIKit



class CategoriesStatTableViewCell: UITableViewCell {

    @IBOutlet weak var imageConstraintConst: NSLayoutConstraint!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var typeImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public func initCellWith(object:StatReportObjectModel) {
        switch object.type {
        case .expence:
            typeImage.image = UIImage(named: "expense_icon")

        case .income:
            typeImage.image = UIImage(named: "income_icon")

        default:
            typeImage.image = UIImage()
            typeImage.backgroundColor = .yellow
        }
        
        switch object.mode {
        case .categories:
            if !DataManager.shared.getSubCategoriesForCategory(category: object.name).isEmpty {
                imageConstraintConst.constant = 24
                accessoryType = .disclosureIndicator
            } else {
                imageConstraintConst.constant = 12
                accessoryType = .none
            }
            
        case .suBcategories:
            imageConstraintConst.constant = 12
            accessoryType = .none
        }
        
        valueLabel.text = String(object.value) + " " + DataManager.shared.getShortStringCurrency()
        categoryLabel.text = object.name
        
        
        
    }
    
    
}
