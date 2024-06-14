//
//  Storyboardable.swift
//  IDO-ExampleApp
//
//  Created by Igor Babitski on 18/02/2024.
//

import Foundation
import UIKit

protocol Storyboardable {
    // MARK: - Methods

    static func instantiate() -> Self
}

extension Storyboardable where Self: UIViewController {

    // MARK: - Properties
    static var storyboardName: String {
        return "Main"
    }

    static var storyboardBundle: Bundle {
        return .main
    }

    // MARK: -

    static var storyboardIdentifier: String {
        return String(describing: self)
    }

    // MARK: - Methods

    static func instantiate() -> Self {
        guard let viewController = UIStoryboard(name: storyboardName, bundle: storyboardBundle).instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("Unable to Instantiate View Controller With Storyboard Identifier \(storyboardIdentifier)")
        }

        return viewController
    }

}
