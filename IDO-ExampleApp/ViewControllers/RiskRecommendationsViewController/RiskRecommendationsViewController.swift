import Foundation
import UIKit
import IdentityOrchestration
import AccountProtection

class RiskRecommendationsViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "DRS Recommendation"
        textLabel.text = "Please click on 'Run DRS' button to get DRS recommendation"
        
        submitButton.setTitle(submitButtonTitle, for: .normal)
    }
        
    override var submitButtonTitle: String? { "Run DRS" }
    
    
    override func submitButtonTapped() {
        super.submitButtonTapped()
        
        initializeDRS() { [weak self] success in
            guard success else { return }
            
            let actionType = self?.actionType ?? ""
            
            TSAccountProtection.triggerAction(actionType) { [weak self] result in
                switch result {
                case .success(let response):
                    debugPrint("[DEBUG] DRS access token: \(response.actionToken)")
                    self?.submitClientResponse(data: ["action_token": response.actionToken], optionId: .clientInput)
                case .failure(let error):
                    debugPrint("[DEBUG] No data found in response object \(error)")
                    self?.submitClientResponse(optionId: .fail)
                }
            }
        }
    }
    
    // MARK: - IDO Initialization
    private func initializeDRS(completion: @escaping (Bool) -> Void) {
        do {
            try TSAccountProtection.initializeSDK { result in
                switch result {
                case .success:
                    completion(true)
                case .failure(let error):
                    debugPrint("[DEBUG] Initialize DRS SDK error: \(error)")
                    completion(false)
                }
            }
        } catch {
            debugPrint("[DEBUG] SDK Initialization error: \(error)")
        }
    }
}
