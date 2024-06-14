import Foundation
import UIKit

class DisplayInformationViewController: BaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = viewTitle
        
        do {
            if let userToken = dataValue(forKey: "text"), userToken.starts(with: "ey") {
                textLabel.text = try decode(jwtToken: userToken).debugDescription
            } else {
                textLabel.text = viewDescription
            }
        } catch {
            textLabel.text = viewDescription
        }
        
        
        submitButton.setTitle(submitButtonTitle, for: .normal)
    }
    
    override func submitButtonTapped() {
        super.submitButtonTapped()
        
        submitClientResponse(optionId: .clientInput)
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
