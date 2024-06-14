//
//  EmailOTPAuthenticationViewController.swift
//  IDO-ExampleApp
//
//  Created by Igor Babitski on 11/04/2024.
//

import UIKit
import IdentityOrchestration

class EmailOTPAuthenticationViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var otpInput: UITextField!
    
    override var submitButtonTitle: String? { "Authenticate" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeIdoSDK()

        titleLabel.text = viewTitle ?? "Email OTP Authentication"
        
        textLabel.text = viewDescription ?? "Please enter you "
        
        submitButton.setTitle(submitButtonTitle, for: .normal)
    }
    
    override func submitButtonTapped() {
        guard let passcode = otpInput.text, !passcode.isEmpty else {
            showAlert(title: "Incorrect OTP passcode", message: "The passcode should be a non-empty, numeric string.")
            return
        }
        
        super.submitButtonTapped()
        
        TSIdo.submitClientResponse(clientResponseOptionId: .clientInput, data: ["passcode": passcode])
    }
    
    func initializeIdoSDK() {
        do {
            try TSIdo.initializeSDK()
        } catch {
            debugPrint("[DEBUG] Error: \(error)")
            showAlert(title: "IDO SDK Initialization Error", message: "\(error)")
        }
    }
}
