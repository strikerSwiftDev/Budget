
import UIKit

class ReportTableViewCell: UITableViewCell {

    var paymentType: PaymentType! {
        willSet {
            
            
            switch newValue {
            case .expence:
                typeImageView.image = UIImage(named: "button_minus")
                typeImageView.backgroundColor = .red
            case .income:
                typeImageView.image = UIImage(named: "button_plus")
                typeImageView.backgroundColor = .green
            default:
                typeImageView.image = UIImage()
                typeImageView.backgroundColor = .clear
            }
            
        }
    }
    
    @IBOutlet private weak var typeImageView: UIImageView!
    
    @IBOutlet weak var valueTF: UILabel!
    
    @IBOutlet weak var categoriesTF: UILabel!
    @IBOutlet weak var subcategoriesTF: UILabel!
    
    @IBOutlet weak var timeTF: UILabel!
    
    func initWith(payment: Payment) {
        paymentType = payment.type
        categoriesTF.text = payment.category
        subcategoriesTF.text = payment.subcategory
        valueTF.text = String(payment.value) + "  " + Consts.strCurrency

        let strHour = intToString(int: payment.hour)
        let strMinute = intToString(int: payment.minute)

        timeTF.text = strHour + ":" + strMinute
        
    }
    
    private func intToString (int: Int) -> String {
        
        var str = String(int)
        if str.count < 2 {
            str = "0" + str
        }
        return str
    }

    
}
