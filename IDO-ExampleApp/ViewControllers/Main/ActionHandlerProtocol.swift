import Foundation
import IdentityOrchestration
import UIKit

protocol ActionHandlerProtocol {
    static func instantiate() -> Self
    func handle(_ response: TSIdoServiceResponse, navigationController: UINavigationController?)
}
