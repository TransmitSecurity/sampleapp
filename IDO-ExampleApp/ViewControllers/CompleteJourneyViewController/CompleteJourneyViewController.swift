import Foundation
import UIKit
import KeychainSwift

class CompleteJourneyViewController: BaseViewController {
        
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        let token = dataValue(forKey: "token")
        let keychain = KeychainSwift()
        if(!((token?.isEmpty) == nil)) {
            do {
                let decodedToken = try decode(jwtToken: token!)
                debugPrint("[DEBUG] token values: \(decodedToken)")
                if( (decodedToken["pid"] as! String) != Settings.authJourneyId ) { //Only register userId from the registration flow.
                    keychain.set(token!, forKey: "userToken") //Token is not used in the journey, it is for debug purpose only.
                    keychain.set(decodedToken["sub"] as! String, forKey: "userId") //UserId is being passed as parameter in the authentication journey(s).
                    debugPrint("[DEBUG] store token: \(String(describing: token))")
                    debugPrint("[DEBUG] store userId: \(String(describing: decodedToken["sub"]))")
                }
            } catch {
                debugPrint("[DEBUG] Error: \(error)")
            }
        }
    }
    
    private func setupUI() {
        removeBackButton()
        submitButton.setTitle(submitButtonTitle, for: .normal)
    }
    
    override func submitButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func decode(jwtToken jwt: String) throws -> [String: Any] {

        enum DecodeErrors: Error {
            case badToken
            case other
        }

        func base64Decode(_ base64: String) throws -> Data {
            let base64 = base64
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            let padded = base64.padding(toLength: ((base64.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
            guard let decoded = Data(base64Encoded: padded) else {
                throw DecodeErrors.badToken
            }
            return decoded
        }

        func decodeJWTPart(_ value: String) throws -> [String: Any] {
            let bodyData = try base64Decode(value)
            let json = try JSONSerialization.jsonObject(with: bodyData, options: [])
            guard let payload = json as? [String: Any] else {
                throw DecodeErrors.other
            }
            return payload
        }

        let segments = jwt.components(separatedBy: ".")
        return try decodeJWTPart(segments[1])
    }
}
