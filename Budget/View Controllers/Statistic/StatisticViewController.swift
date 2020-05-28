
import UIKit

class StatisticViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    @IBAction func loadPayments(_ sender: Any) {
        let generator = PaymentsGenerator()
        generator.generateRandomPayments(quantity: 1000)
    }
    

    
}


