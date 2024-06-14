//
//  IdentityVerificationViewController.swift
//  IDO-ExampleApp
//
//  Created by Maurice Luizink on 22/05/2024.
//

import Foundation
import UIKit
import KeychainSwift
import IdentityOrchestration
import IdentityVerification
import AVFoundation

class IdentityVerificationViewController: BaseViewController, IDVStatusObserverDelegate {
    private let idvObserver = IDVStatusObserver()

    @IBOutlet weak var status: UILabel!
    
    
    func updateStatusLabel(with text: String) {
        DispatchQueue.main.async {
            self.status.text = text
        }
    }
        
    private var devicetoken: String? {
        jsonObject(forKey: "app_data")?["devicetoken"] as? String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeIdoSDK()
        initializeIDVSDK()
        
        idvObserver.delegate = self
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // User has already authorized camera access
            TSIdentityVerification.startFaceAuth(deviceSessionId: devicetoken!)
            break
        case .notDetermined: // User hasn't yet authorized camera access
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted { // User has granted camera access
                    
                    TSIdentityVerification.startFaceAuth(deviceSessionId: self.devicetoken!)
                } else {
                    // Handle unauthorized state
                    debugPrint("[DEBUG] Error: Camera denied")
                    self.showAlert(title: "Error: Camera access", message: "denied")
                }
            }
            break

        case .denied:
            // Handle authorization state
            debugPrint("[DEBUG] Error: Camera denied")
            showAlert(title: "Error: Camera access", message: "denied")
            break
        case .restricted:
            // Handle authorization state
            debugPrint("[DEBUG] Error: Camera restricted")
            showAlert(title: "Error: Camera access", message: "restricted")
            break
        @unknown default:
            // Handle unauthorized state
            debugPrint("[DEBUG] Error: Camera unauthorized")
            showAlert(title: "Error: Camera access", message: "unauthorized")
            break
        }
       
    }
    
    
    
    func initializeIdoSDK() {
        do {
            try TSIdo.initializeSDK()
        } catch {
            debugPrint("[DEBUG] Error: \(error)")
            showAlert(title: "IDO SDK Initialization Error", message: "\(error)")
        }
    }
    
    func initializeIDVSDK() {
        do {
            try TSIdentityVerification.initializeSDK()
            TSIdentityVerification.faceAuthDelegate = idvObserver
        } catch {
            debugPrint("[DEBUG] Error: \(error)")
            showAlert(title: "IDV SDK Initialization Error", message: "\(error)")
        }
    }
}
protocol IDVStatusObserverDelegate: AnyObject {
    func updateStatusLabel(with text: String)
}
private class IDVStatusObserver: TSIdentityFaceAuthenticationDelegate {
    weak var delegate: IDVStatusObserverDelegate?
    
    
    func faceAuthenticationDidStartCapturing() {
        delegate?.updateStatusLabel(with: "Start Capture")
        debugPrint("start capturing")
    }

    /** Notifies when user has finished uploading images and the face authentication is being processed. */
    func faceAuthenticationDidStartProcessing() {
        delegate?.updateStatusLabel(with: "Processing")
        debugPrint("processing")
    }

    /** Notifies when face authentication process completed, and the result can be obtained (via backend request). */
    func faceAuthenticationDidComplete() {
        delegate?.updateStatusLabel(with: "Completed")
        TSIdo.submitClientResponse(clientResponseOptionId: .clientInput, data: ["status": "completed"])
        debugPrint("completed")
    }

    /** Notifies when face authentication process being canceled by user */
    func faceAuthenticationDidCancel() {
        delegate?.updateStatusLabel(with: "Canceled")
        TSIdo.submitClientResponse(clientResponseOptionId: .clientInput, data: ["status": "canceled"])
        debugPrint("canceled")
    }

    /** Notifies the user about updates to the face authentication status.
     - Parameters:
       - error: The verification error
     */
    func faceAuthenticationDidFail(with error: IdentityVerification.TSIdentityVerificationError) {
        delegate?.updateStatusLabel(with: "Error")
        TSIdo.submitClientResponse(clientResponseOptionId: .clientInput, data: ["status": "error","error":error.localizedDescription])
        debugPrint("Verification error: \(error)")
    }
}
