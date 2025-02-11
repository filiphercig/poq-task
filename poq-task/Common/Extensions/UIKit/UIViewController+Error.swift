//
//  UIViewController+Error.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import UIKit
import SafariServices

// MARK: - Error Handling

extension UIViewController {

    func presentError(title: String, message: String, retryButtonAction: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let retryButtonAction {
            alert.addAction(.init(title: "Retry", style: .default, handler: retryButtonAction))
        }
        alert.addAction(.init(title: "Cancel", style: .destructive))

        self.present(alert, animated: true)
    }
}

// MARK: - External Browser

extension UIViewController {
    
    func presentExternalBrowser(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.modalPresentationStyle = .overFullScreen
        safariViewController.preferredControlTintColor = .systemBlue
        present(safariViewController, animated: true, completion: nil)
    }
}
