import Foundation
import UIKit

class FormPhoneViewController: BaseViewController {
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.setTitle(submitButtonTitle, for: .normal)
    }
    
    override func submitButtonTapped() {
        super.submitButtonTapped()
        
        submitClientResponse(data: [
            "phoneNumber": phoneNumberTextField.text ?? "",
        ],
                             optionId: .clientInput)
    }
}
