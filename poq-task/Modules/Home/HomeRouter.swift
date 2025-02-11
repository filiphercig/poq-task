//
//  HomeRouter.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import Foundation

protocol HomeRouting {
    func presentBrowser(with url: String)
}

final class HomeRouter: HomeRouting {

    // MARK: ViewController

    weak var viewController: HomeViewController?

    // MARK: Public Methods

    func createViewController() -> HomeViewController {
        let viewModel = HomeViewModel(router: self)
        let viewController = HomeViewController(viewModel: viewModel)
        self.viewController = viewController

        return viewController
    }
    
    func presentBrowser(with url: String) {
        viewController?.presentExternalBrowser(with: url)
    }
}
