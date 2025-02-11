//
//  AppController.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import UIKit

@MainActor
final class AppController {

    // MARK: - Private Properties

    private let window: UIWindow

    private var navigationController: UINavigationController? {
        window.rootViewController as? UINavigationController
    }

    // MARK: - Init

    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = UINavigationController()
        self.window.makeKeyAndVisible()
    }

    // MARK: - Public Methods

    func navigateHomeScreen() {
        let homeRouter = HomeRouter()
        let viewController = homeRouter.createViewController()
        navigationController?.setViewControllers([viewController], animated: false)
    }
}
