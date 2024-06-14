//
//  UIViewControllerExtensions.swift
//  IDO-ExampleApp
//
//  Created by Igor Babitski on 19/02/2024.
//

import Foundation
import UIKit

protocol NibLoadable {
    // MARK: - Methods
    static func instantiate() -> Self
}


extension NibLoadable where Self: UIViewController {

    static var viewControllerIdentifier: String {
        return String(describing: self)
    }

    // MARK: - Methods

    static func instantiate() -> Self {
        let viewController = Self(nibName: viewControllerIdentifier, bundle: nil)

        return viewController
    }

}
