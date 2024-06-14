//
//  LoginFormViewController.swift
//  IDO-ExampleApp
//
//  Created by Maurice Luizink on 23/04/2024.
//

import Foundation
import UIKit
import IdentityOrchestration
import TSAuthenticationSDK

class LoginFormViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeIdoSDK()
        initializeAuthenticationSDK()
        
        let signData = jsonObject(forKey: "json_data")?["sign_data"] as? Dictionary<String, String>
        debugPrint("signdata: \(signData?.debugDescription ?? "empty")")
        debugPrint("userid: \(userId ?? "")")
        
        if (!((signData?.isEmpty) == nil) && !((userId?.isEmpty) == nil)) {
            TSAuthentication.shared.approvalWebAuthn(username: userId ?? "", approvalData: signData!) {
            result in
                switch result {
                case .success(let registrationResult):
                    // Handle success
                    debugPrint("Signing successful: \(registrationResult)")
                    debugPrint("webencoded result: \(registrationResult.result)")
                    TSIdo.submitClientResponse(clientResponseOptionId: TSIdoClientResponseOptionType.custom(id: "passkeys"), data: ["webauthn_encoded_result": registrationResult.result])
                    
                case .failure(let error):
                    // Handle failure
                    debugPrint("Signing failed with error: \(error)")
                }
            }
        } else {
            TSAuthentication.shared.authenticateWebAuthn(username: userId ?? "") { result in
                switch result {
                case .success(let registrationResult):
                    // Handle success
                    debugPrint("Authentication successful: \(registrationResult)")
                    debugPrint("webencoded result: \(registrationResult.result)")
                    TSIdo.submitClientResponse(clientResponseOptionId: TSIdoClientResponseOptionType.custom(id: "passkeys"), data: ["webauthn_encoded_result": registrationResult.result])
                    
                case .failure(let error):
                    // Handle failure
                    debugPrint("Authentication failed with error: \(error)")
                }
            }
        }
    }
    
    private var userId: String? {
        dataValue(forKey: "username")
    }
    
    func initializeIdoSDK() {
        do {
            try TSIdo.initializeSDK()
        } catch {
            debugPrint("[DEBUG] Error: \(error)")
            showAlert(title: "IDO SDK Initialization Error", message: "\(error)")
        }
    }
    
    private func initializeAuthenticationSDK() {
        do {
            try TSAuthentication.shared.initializeSDK()
        } catch {
            debugPrint("[DEBUG] Error: \(error)")
            showAlert(title: "SDK Initialization Error", message: "\(error)")
        }
    }
}
