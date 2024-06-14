import Foundation
import UIKit

class RejectAccessViewController: BaseViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        removeBackButton()
        messageLabel.text = viewDescription
    }
    
    override func submitButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
