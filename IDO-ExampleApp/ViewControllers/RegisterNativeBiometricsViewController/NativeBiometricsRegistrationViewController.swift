import Foundation
import UIKit
import IdentityOrchestration
import TSAuthenticationSDK

class NativeBiometricsRegistrationViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var userIdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = viewTitle ?? "Register Mobile Biometrics"
        
        textLabel.text = viewDescription
        
        userIdLabel.text = userId ?? "Unknown user id"
        
        initializeAuthenticationSDK()
    }
    
    private var userId: String? {
        dataValue(forKey: "user_identifier")
    }
    
    override func submitButtonTapped() {
        super.submitButtonTapped()
        
        guard let userId else {
            debugPrint("[DEBUG] No user identifier has been provided")
            showAlert(title: "No user identifier has been provided", message: "")
            return
        }
        
        TSAuthentication.shared.registerNativeBiometrics(username: userId) { [weak self] result in
            switch result {
            case .success(let response):
                
                var data: [String: Any] = [
                    "publicKey": response.publicKey,
                    "publicKeyId": response.publicKeyId,
                    "os": "ios"
                ]
                
                if let attestation = response.attestation {
                    data["attestation"] = attestation
                }
                
                self?.submitClientResponse(data: data, optionId: .clientInput)
            case .failure(let error):
                debugPrint("[DEBUG] Error: \(error)")
                self?.showAlert(title: "Authentication Error", message: "\(error)", style: .alert, completion: { UIAlertAction in
                    self?.stopLoadingIndicator()
                    self?.submitClientResponse(data: [:], optionId: .fail)
                })
            }
        }
    }
    
    // MARK: - IDO Initialization
    private func initializeAuthenticationSDK() {
        do {
            try TSAuthentication.shared.initializeSDK()
        } catch {
            debugPrint("[DEBUG] Error: \(error)")
            showAlert(title: "SDK Initialization Error", message: "\(error)")
        }
    }
}
