//
//  RegisterWebAuthViewController.swift
//  IDO-ExampleApp
//
//  Created by Maurice Luizink on 21/04/2024.
//

import Foundation
import UIKit
import IdentityOrchestration
import TSAuthenticationSDK

class RegisterWebAuthnViewController: BaseViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var discoverableLabel: UILabel!
    @IBOutlet weak var crossplatformLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeIdoSDK()
        initializeAuthenticationSDK()
        usernameLabel.text = userId
        displayNameLabel.text = displayName
        discoverableLabel.text = discoverable
        crossplatformLabel.text = crossPlatform
        //TSAuthentication.shared.registerWebAuthn(username: "zk1wc13zcx2s1uo576gqi", displayName: displayName) { result in
        TSAuthentication.shared.registerWebAuthn(username: userId!, displayName: displayName) { result in

        //TSAuthentication.shared.registerWebAuthn(username: internalUserId!, displayName: displayName) { result in
            switch result {
            case .success(let registrationResult):
                // Handle success
                print("Registration successful: \(registrationResult.result)")
                debugPrint("[DEBUG] encoded_result: \(registrationResult.result)")
                TSIdo.submitClientResponse(clientResponseOptionId: .clientInput, data: ["webauthn_encoded_result": registrationResult.result])
            case .failure(let error):
                // Handle failure
                print("Registration failed with error: \(error)")
            }
        }
    }
    
    
    private var userId: String? {
        dataValue(forKey: "username")
    }
    private var displayName: String? {
        dataValue(forKey: "display_name")
    }
    private var internalUserId: String? {
        jsonObject(forKey: "json_data")?["username"] as? String
    }
    private var discoverable: String? {
        dataValue(forKey: "register_as_discoverable")
    }
    private var crossPlatform: String? {
        dataValue(forKey: "allow_cross_platform_authenticators")
    }
    override func submitButtonTapped() {
        
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
