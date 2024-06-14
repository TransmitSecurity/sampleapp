//
//  Extensions.swift
//  IDO-ExampleApp
//
//  Created by Transmit Security on 18/02/2024.
//

import Foundation
import IdentityOrchestration
import UIKit

extension TSIdoJourneyError {
    
    var title: String {
        return "Journey error"
    }
    
    var message: String {
        switch self {
        case .clientResponseNotValid:
            return "The client response to the Journey is not valid."
        case .networkError:
            return "Could not connect to server, or server did not respond before timeout."
        case .notInitialized:
            return "The SDK is not initialized."
        case .serverError:
            return "Unexpected server error."
        case .initializationError:
            return "Initialization error"
        case .invalidCredentials:
            return "Invalid Credentials"
        @unknown default:
            return "Unknown error"
        }
    }
}

