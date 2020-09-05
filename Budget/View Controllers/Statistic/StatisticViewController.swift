
import UIKit

class StatisticViewController: UIViewController {

    @IBOutlet weak var generatorBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        if Consts.isDebugBuild {
            generatorBtn.alpha = 1
        } else {
            generatorBtn.alpha = 0
        }
        
    }
    
    @IBAction func loadPayments(_ sender: Any) {
        let generator = PaymentsGenerator()
        generator.generateRandomPayments(quantity: 1000)
    }
    

    
}


