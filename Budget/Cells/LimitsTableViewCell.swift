
import UIKit

class LimitsTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var repeatImageView: UIImageView!
    
    @IBOutlet weak var repeatLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var restLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var restTitleLabel: UILabel!
    
    private var isOvered = false
    
    private var progress: Float = 1.1 {
        didSet {
            
            if progress < 0 {
                progress = 0
            }
            
//            print(progress)
            
            progressBar.progress = progress
            switch progress {
            case 0.0..<0.3:
                progressBar.tintColor = .systemRed
            case 0.3..<0.6:
                progressBar.tintColor = .systemOrange
            case 0.6..<0.75:
             progressBar.tintColor = .systemYellow
            case 0.75...1.0:
                if !isOvered {
                    progressBar.tintColor = .systemGreen
                } else {
                    progressBar.tintColor = .systemRed
                }
                

            default:
                progressBar.tintColor = .blue
            }


        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    func initCell(limit: LimitModel, expence: Double) {
        categoryLabel.text = limit.category
        valueLabel.text = String(limit.value) + " " + DataManager.shared.getShortStringCurrency()
        
        let rest = limit.value - expence
        
        var multipler = rest / limit.value
        
        if multipler > 1 {
            multipler = 1
        }
        
        if multipler < 0 {
            multipler = 1
        }
        
        
        var restToDisplay = rest
        restTitleLabel.text = "Остаток"
        isOvered = false
        
        if rest < 0 {
           restToDisplay = abs(rest)
            restTitleLabel.text = "Превышено"
            isOvered = true
        }
        
        progress = Float(multipler)
        
        restLabel.text = String(restToDisplay) + " " + DataManager.shared.getShortStringCurrency()
        
        if limit.regular {
            repeatImageView.image = UIImage(named: "repeat_icon")
            repeatLabel.alpha = 1
        } else {
            repeatImageView.image = UIImage()
            repeatLabel.alpha = 0
        }
        

    }
    
    
}
