//
//  UINavigationController+.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import UIKit

extension UINavigationController {
    
    func setupNavigationBar(animated: Bool) {
        setNavigationBarHidden(false, animated: animated)
        navigationBar.tintColor = .textPrimary
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.textPrimary]
        navigationBar.isTranslucent = false
        navigationBar.layer.masksToBounds = false
        navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationBar.layer.shadowOpacity = 0.1
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        navigationBar.layer.shadowRadius = 4

        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.textPrimary]
        navBarAppearance.shadowColor = nil
        navBarAppearance.backgroundColor = .backgroundSecondary
        navigationBar.standardAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
    }
}
