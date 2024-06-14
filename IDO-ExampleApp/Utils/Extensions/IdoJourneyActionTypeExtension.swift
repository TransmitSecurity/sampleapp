import Foundation
import IdentityOrchestration

extension TSIdoJourneyActionType {
    var identifier: String {
        switch self {
        case .custom(name: let name):
            return name
        case .rejection:
            return "Rejection"
        case .success:
            return "Success"
        case .information:
            return "Information"
        case .debugBreak:
            return "DebugBreak"
        case .waitForAnotherDevice:
            return "WaitForAnotherDevice"
        case .drsTriggerAction:
            return "DrsTriggerAction"
        case .identityVerification:
            return "IdentityVerification"
        case .webAuthnRegistration:
            return "WebAuthnRegistration"
        case .registerDeviceAction:
            return "RegisterDeviceAction"
        case .validateDeviceAction:
            return "ValidateDeviceAction"
        case .nativeBiometricsRegistration:
            return "NativeBiometricsRegistration"
        case .nativeBiometricsAuthenticaton:
            return "NativeBiometricsAuthentication"
        case .emailOTPAuthentication:
            return "EmailOTPAuthentication"
        case .smsOTPAuthentication:
            return "SMSOTPAuthentication"
        @unknown default:
            return "Unknown"
        }
    }
}
