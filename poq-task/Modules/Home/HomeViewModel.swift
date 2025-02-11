//
//  HomeViewModel.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import Foundation
import Combine

typealias HomeDataSourcePublisher = AnyPublisher<HomeDataSource, Never>
typealias LoadingStatePublisher = AnyPublisher<LoadingState, Never>

// MARK: - DetailsScreenViewModeling

protocol HomeViewModeling {
    var loadingState: LoadingStatePublisher { get }
    var dataSource: HomeDataSourcePublisher { get }
    
    func onRepoSelection(_ indexPath: IndexPath)
}

// MARK: - DetailsScreenViewModel

final class HomeViewModel {

    // MARK: Private Properties

    private let router: HomeRouting
    private let repoService: RepoServicing
    private var cancellables = Set<AnyCancellable>()

    // MARK: Subjects

    private let loadingStateSubject: CurrentValueSubject<LoadingState, Never> = .init(.empty)
    private let dataSourceSubject: CurrentValueSubject<HomeDataSource, Never> = .init(HomeDataSource())

    // MARK: Init

    init(
        router: HomeRouting,
        repoService: RepoServicing = RepoService()
    ) {
        self.router = router
        self.repoService = repoService

        getUserDetails()
    }

    // MARK: Private Methods

    private func getUserDetails() {
        loadingStateSubject.send(.loading)

        repoService.getReposList(for: "square")
            .sink { [weak self] completion in
                guard let self else { return }

                switch completion {
                case .finished:
                    loadingStateSubject.send(.finished)

                case .failure(let error):
                    loadingStateSubject.send(.failed(error))
                }
            } receiveValue: { [weak self] repos in
                guard let self else { return }

                let dataSource = self.dataSourceSubject.value
                dataSource.createCells(repos: repos)
                dataSourceSubject.send(dataSource)
            }
            .store(in: &cancellables)
    }
}

// MARK: - DetailsScreenViewModeling

extension HomeViewModel: HomeViewModeling {

    // MARK: Publishers

    var loadingState: LoadingStatePublisher {
        loadingStateSubject.eraseToAnyPublisher()
    }

    var dataSource: HomeDataSourcePublisher {
        dataSourceSubject.eraseToAnyPublisher()
    }
    
    // MARK: Methods
    
    func onRepoSelection(_ indexPath: IndexPath) {
        let repo = dataSourceSubject.value.getCell(for: indexPath)
        
        switch repo {
        case .reposCell(let viewModel):
            router.presentBrowser(with: viewModel.url)
        }
    }
}
