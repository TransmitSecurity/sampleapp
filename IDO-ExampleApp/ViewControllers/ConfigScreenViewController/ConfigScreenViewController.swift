//
//  ConfigScreenViewController.swift
//  IDO-ExampleApp
//
//  Created by Maurice Luizink on 07/05/2024.
//

import Foundation
import UIKit
import KeychainSwift

class ConfigScreenViewController: UIViewController, NibLoadable {
    
    
    @IBOutlet weak var clientIdField: UITextField!
    
    @IBOutlet weak var baseUrlField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let keychain = KeychainSwift()
        if let clientId = keychain.get("clientId") {
            clientIdField.text = clientId
        }
        if let baseUrl = keychain.get("baseUrl") {
            baseUrlField.text = baseUrl
        }
    }
    
    @IBAction func onSubmitButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        let keychain = KeychainSwift()

        if let clientId = clientIdField.text {
            keychain.set(clientId, forKey: "clientId")
        }
        if let baseUrl = baseUrlField.text {
            keychain.set(baseUrl, forKey: "baseUrl")
        }
    }
}
