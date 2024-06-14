import Foundation
import UIKit

class FormEmailViewController: BaseViewController {
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton!.setTitle(submitButtonTitle, for: .normal)
    }
    
    override func submitButtonTapped() {
        super.submitButtonTapped()
        
        submitClientResponse(data: [
            "emailAddress": emailAddressTextField.text ?? "",
            "password": passwordTextField.text ?? "",
        ],
                             optionId: .clientInput)
    }
}
