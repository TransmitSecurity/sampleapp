//
//  TSLoadingIndicator.swift
//  TSXPassKeys
//
//  Created by Transmit Security on 21/11/2022.
//

import UIKit

class TSLoadingIndicator {

    static let shared: TSLoadingIndicator = .init()
    
    private init() { }
    
    private var container: UIView?
    private var activityIndicator: UIActivityIndicatorView?
    
    func stopAnimation(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.1, animations: {
            self.activityIndicator?.stopAnimating()
            self.container?.alpha = 0.5
        }) { (finish)  in
            self.container?.removeFromSuperview()
            self.activityIndicator = nil
            self.container = nil
            completion?()
        }
    }
    
    
    func startAnimation(completion: (() -> Void)? = nil) {
        
        if activityIndicator == nil {
            
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            
            if let presenter = keyWindow?.rootViewController {
                let container = UIView()
                self.container = container

                container.alpha = 1
                container.frame = presenter.view.frame
                container.center = presenter.view.center
                container.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                
                let loadingView = UIView()
                loadingView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
                loadingView.center = presenter.view.center
                loadingView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
                loadingView.clipsToBounds = true
                loadingView.layer.cornerRadius = 10
                
                activityIndicator = UIActivityIndicatorView()
                
                activityIndicator?.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0);
                activityIndicator?.style = UIActivityIndicatorView.Style.large
                activityIndicator?.color = UIColor(red: 28.0/255, green: 39.0/255.0, blue: 69.0/255.0, alpha: 1.0)
                activityIndicator?.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)

                
                loadingView.addSubview(activityIndicator!)
                container.addSubview(loadingView)
                presenter.view.addSubview(container)
                
                activityIndicator?.startAnimating()
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.container?.alpha = 1.0
                }) { (finish) in
                    completion?()
                }
                
            }
        }
        
    }
}

extension UIViewController {
    
    @objc func hideBackButtonTitle() {
        self.navigationController?.navigationBar.topItem?.title = " "
    }
    
   @objc func removeBackButton() {
        self.navigationItem.hidesBackButton = true
    }
    
    @objc func setCustomBackButton(image: UIImage? = UIImage(named: "back")) {
        //Initialising "back button"
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(image, for: UIControl.State.normal)
        btnLeftMenu.addTarget(self, action: #selector(onClickBack), for: UIControl.Event.touchUpInside)
        btnLeftMenu.frame = CGRect(x:0, y:0, width:44, height:44)
       // btnLeftMenu.imageEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0);
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
        
    }
    
    @objc func onClickBack() {
        if (self.navigationController?.viewControllers.count)! > 1 {
            _ = self.navigationController?.popViewController(animated: true)
        }else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    // Show an alert
    @objc func showAlert(title: String?, message: String?, style: UIAlertController.Style = .alert, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let okayBtn = UIAlertAction(title: "Ok", style: .default, handler: completion)
        alert.addAction(okayBtn)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func showErrorToast(message: String, font: UIFont = UIFont.systemFont(ofSize: 14.0, weight: .regular), duration: Float = 3.0) {
        toast(message: message, font: font, backgroundColor: UIColor(red: 208.0 / 255.0, green: 2.0 / 255.0, blue: 27.0 / 255.0, alpha: 1.0), duration: duration)
    }
    
    @objc func showToast(message: String, font: UIFont = UIFont.systemFont(ofSize: 14.0, weight: .regular), duration: Float = 3.0) {
        toast(message: message, font: font, duration: duration)
    }
    
    @objc private func toast(message: String, font: UIFont = UIFont.systemFont(ofSize: 14.0, weight: .regular), backgroundColor: UIColor = .black, duration: Float = 3.0) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = backgroundColor.withAlphaComponent(0.75)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 6;
        toastContainer.clipsToBounds  =  true
        
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center;
        toastLabel.font = font
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        
        toastContainer.addSubview(toastLabel)
        view.addSubview(toastContainer)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 10)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -10)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -10)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 10)
        toastContainer.addConstraints([a1, a2, a3, a4])
        
        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 24)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -24)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -24)
        view.addConstraints([c1, c2, c3])
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: TimeInterval(duration), options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
    
}

