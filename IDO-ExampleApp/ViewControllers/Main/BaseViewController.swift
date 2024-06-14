import UIKit
import IdentityOrchestration

class BaseViewController: UIViewController, NibLoadable, ActionHandlerProtocol {
    
    private var data: [String: Any]?
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var submitButtonTitle: String? {
        data?["button_text"] as? String ?? "OK"
    }
    
    var viewTitle: String? {
        data?["title"] as? String
    }
    
    var viewDescription: String? {
        data?["text"] as? String
    }
    
    var actionType: String? {
        data?["action_type"] as? String
    }
    
    func dataValue(forKey key: String) -> String? {
        data?[key] as? String
    }
    
    func jsonObject(forKey key: String) -> Dictionary<String, Any>? {
        data?[key] as? Dictionary<String, Any>
    }
    
    func dict() -> Dictionary<String, Any>? {
        data
    }
    
    func reloadData() {
        debugPrint("Data of: \(self.debugDescription) was reloaded")
    }

    func showErrorToast(error: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showErrorToast(message: error)
        }
    }
    
    func startLoadingIndicator() {
        TSLoadingIndicator.shared.startAnimation()
    }
    
    func stopLoadingIndicator() {
        TSLoadingIndicator.shared.stopAnimation()
    }
    
    func submitButtonTapped() {
        // Should be implemented in subclasses
        startLoadingIndicator()
    }
    
    func submitClientResponse(data: [String: Any]? = nil, optionId: TSIdoClientResponseOptionType) {
        TSIdo.submitClientResponse(clientResponseOptionId: optionId, data: data)
    }
    
    @IBAction func onSubmitButton(_ sender: UIButton) {
        submitButtonTapped()
    }
    
    func handle(_ response: TSIdoServiceResponse, navigationController: UINavigationController?) {
        guard let actionData = response.data else { debugPrint("[DEBUG] No data found in response object"); return }
        
        self.data = actionData
        if dict() != nil {
            debugPrint("requestdata: " + dict()!.debugDescription)
        }
        navigationController?.pushViewController(self, animated: true)
    }
}

extension BaseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        return true
    }
}

