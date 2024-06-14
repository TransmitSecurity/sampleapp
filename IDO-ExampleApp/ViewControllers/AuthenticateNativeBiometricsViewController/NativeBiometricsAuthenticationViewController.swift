import Foundation
import UIKit
import IdentityOrchestration
import TSAuthenticationSDK

class NativeBiometricsAuthenticationViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var userIdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = viewTitle ?? "Authenticate Mobile Biometrics"
        
        textLabel.text = viewDescription
        
        userIdLabel.text = userId ?? "Unknown user id"
        
        initializeAuthenticationSDK()
    }
    
    private var userId: String? {
        dataValue(forKey: "user_identifier")
    }
    
    private var challenge: String? {
        dataValue(forKey: "biometrics_challenge")
    }
    
    override func submitButtonTapped() {
        super.submitButtonTapped()
        
        guard let userId else {
            debugPrint("[DEBUG] No user identifier has been provided")
            showAlert(title: "No user identifier has been provided", message: "")
            return
        }
        
        guard let challenge else {
            debugPrint("[DEBUG] No challenge value found in server response")
            showAlert(title: "No challenge value found in server response", message: "")
            return
        }
        
        TSAuthentication.shared.authenticateNativeBiometrics(username: userId, challenge: challenge) { [weak self] result in
            switch result {
            case .success(let response):
                
                let data: [String: Any] = [
                    "publicKeyId": response.publicKeyId,
                    "signedChallenge": response.signature,
                    "userIdentifier": userId
                ]

                self?.submitClientResponse(data: data, optionId: .clientInput)
            case .failure(let error):
                debugPrint("[DEBUG] Error: \(error)")
                self?.showAlert(title: "Authentication Error", message: "\(error)")
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
