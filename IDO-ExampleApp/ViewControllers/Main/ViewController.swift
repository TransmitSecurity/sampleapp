
import UIKit
import IdentityOrchestration
import KeychainSwift
import TSAuthenticationSDK
import AuthenticationServices
import AccountProtection

class ViewController: BaseViewController {

    @IBOutlet weak var userIdLabel: UILabel!

    
    let actionHandlersMap: [String: ActionHandlerProtocol.Type] = [
        "Error": ErrorViewController.self,
        "Rejection": RejectAccessViewController.self,
        "email": FormEmailViewController.self,
        "phone": FormPhoneViewController.self,
        "selfie": IdentityVerificationViewController.self,
        "Information": DisplayInformationViewController.self,
        "Success": CompleteJourneyViewController.self,
        "DrsTriggerAction": RiskRecommendationsViewController.self,
        "NativeBiometricsRegistration": NativeBiometricsRegistrationViewController.self,
        "NativeBiometricsAuthentication": NativeBiometricsAuthenticationViewController.self,
        "EmailOTPAuthentication": EmailOTPAuthenticationViewController.self,
        "SMSOTPAuthentication": SMSOTPAuthenticationViewController.self,
        "WebAuthnRegistration":
            RegisterWebAuthnViewController.self,
        "loginForm": LoginFormViewController.self,
        "IdentityVerification": IdentityVerificationViewController.self
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        let keychain = KeychainSwift()
        if let userId = keychain.get("userId") {
            debugPrint("[DEBUG] use userId for user: \(String(describing: userId))")
            userIdLabel.text = userId
        } else {
            userIdLabel.text = "unknown"
        }
        initializeIDOSDK()
        initializeAuthenticationSDK()
        initializeDRSSDK()
    }

    @IBAction func onStartJourney(_ sender: Any) {
        startJourney()
    }
    
    @IBAction func onConfigOpen(_ sender: Any){
        let handler = ConfigScreenViewController.instantiate()
        navigationController?.pushViewController(handler, animated: true)
    }
    
    @IBAction func onStartAuthenticationJourney(_ sender: Any) {
    
        startLoadingIndicator()
        let keychain = KeychainSwift()
        if let userToken = keychain.get("userToken"), let userId = keychain.get("userId") {
            print("userToken: \(userToken)")
            TSAccountProtection.setUserId(userId)
            TSAccountProtection.triggerAction("login") { result in
                switch result {
                case .success(let response):
                    debugPrint("[DEBUG] actiontoken:" + (response.actionToken))
                    debugPrint("[DEBUG] use token for user: \(String(describing: userToken)) and userId: \(String(describing: userId))")
                    TSIdo.startJourney(journeyId: Settings.authJourneyId,options: TSIdoStartJourneyOptions.init(additionalParams: ["token":userToken, "userId":userId, "actionToken": response.actionToken]))
                case .failure(let error):
                    debugPrint("[DEBUG] failure, reason:" + error.localizedDescription)
                }
            }
            //TSIdo.startJourney(journeyId: Settings.authJourneyId)
        }else if let userId = keychain.get("userId") {
            TSAccountProtection.setUserId(userId)
            TSAccountProtection.triggerAction("login") { result in
                switch result {
                case .success(let response):
                    debugPrint("[DEBUG] actiontoken:" + (response.actionToken))
                    debugPrint("[DEBUG] use userId for user: \(String(describing: userId))")
                    TSIdo.startJourney(journeyId: Settings.authJourneyId,options: TSIdoStartJourneyOptions.init(additionalParams: ["userId":userId, "actionToken": response.actionToken]))
                case .failure(let error):
                    debugPrint("[DEBUG] failure, reason:" + error.localizedDescription)
                }
            }
            
        } else  {
            showAlert(title: "No User", message: "Register First")
            stopLoadingIndicator()
        }

    }
    // MARK: - IDO Initialization
    private func initializeIDOSDK() {
        do {
            try TSIdo.initializeSDK()
        } catch {
            debugPrint("[DEBUG] SDK Initialization error: \(error)")
        }
        
        TSIdo.delegate = self
    }
    
    private func initializeAuthenticationSDK() {
        do {
            try TSAuthentication.shared.initializeSDK()
        } catch {
            debugPrint("[DEBUG] Error: \(error)")
            showAlert(title: "SDK Auth Initialization Error", message: "\(error)")
        }
    }
    
    private func initializeDRSSDK() {
        do {
            try TSAccountProtection.initializeSDK()
        } catch {
            debugPrint("[DEBUG] Error: \(error)")
            showAlert(title: "SDK DRS Initialization Error", message: "\(error)")
        }
    }
    
    private func startJourney() {
        TSAccountProtection.triggerAction("register") { result in
            switch result {
            case .success(let response):
                debugPrint("[DEBUG] actiontoken:" + (response.actionToken))
                TSIdo.startJourney(journeyId: Settings.regJourneyId,options: TSIdoStartJourneyOptions.init(additionalParams: ["actionToken": response.actionToken]))
            case .failure(let error):
                debugPrint("[DEBUG] failure, reason:" + error.localizedDescription)
            }
        }
    }
    
    private var presentedController: BaseViewController? {
        presentedViewController as? BaseViewController
    }
}

 
extension ViewController: TSIdoDelegate {
    func TSIdoDidReceiveResult(_ result: Result<TSIdoServiceResponse, TSIdoJourneyError>) {
        stopLoadingIndicator()
        switch result {
        case .success(let response):
            debugPrint("[DEBUG] success, step: " + (response.journeyStepId?.identifier ?? "unknown"))
            self.handleIdoResponse(response)
        case .failure(let error):
            debugPrint("[DEBUG] failure, reason:" + error.localizedDescription)
            self.handleJourneyError(error)
        }
    }
    
    private func handleIdoResponse(_ response: TSIdoServiceResponse) {
        guard let stepId = response.journeyStepId else {
            debugPrint("[DEBUG] Missing step id in the journey response")
            return
        }

        if let handler = actionHandlersMap[stepId.identifier]?.instantiate() {
            debugPrint("[DEBUG] executing handler in the journey response: " + stepId.identifier)

            // Check for 'Success' identifier and handle JSON data for redirect
            if stepId.identifier == "Success", let jsonData = response.data?["json_data"] as? [String: Any] {
                handleSuccessResponse(jsonData: jsonData)
            } else {
                handler.handle(response, navigationController: navigationController)
            }
        } else {
            debugPrint("[DEBUG] Missing handler id in the journey response: " + stepId.identifier)
        }
    }
    
    /// Handles the success response by checking the presence of journey redirects and starting new journeys.
    private func handleSuccessResponse(jsonData: [String: Any]) {
        if let redirObj = jsonData["journey_redirect"] as? [String: Any], let journeyId = redirObj["journey_id"] as? String {
            // Extract parameters if available, otherwise use an empty dictionary
            let paramObj = redirObj["params"] as? [String: Any] ?? [:]
            TSIdo.startJourney(journeyId: journeyId, options: TSIdoStartJourneyOptions(additionalParams: paramObj))
        }
    }
    
    private func handleJourneyError(_ error: TSIdoJourneyError) {
        debugPrint("[DEBUG] Journey error occured: \(error.localizedDescription)")
        showAlert(title: error.title, message: error.message)
    }
}
