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
    var tableViewPagination: LoadingStatePublisher { get }
    
    func onRepoSelection(_ indexPath: IndexPath)
    func onBottomScroll()
}

// MARK: - DetailsScreenViewModel

final class HomeViewModel {

    // MARK: Private Properties

    private let router: HomeRouting
    private let repoService: RepoServicing
    private var cancellables = Set<AnyCancellable>()
    
    private let organizationName = Constants.API.organizationName
    private var pageNumber = 1
    private var hasMorePages = true

    // MARK: Subjects

    private let loadingStateSubject: CurrentValueSubject<LoadingState, Never> = .init(.empty)
    private let dataSourceSubject: CurrentValueSubject<HomeDataSource, Never> = .init(HomeDataSource())
    private let tableViewPaginationSubject: CurrentValueSubject<LoadingState, Never> = .init(.finished)

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

        repoService.getReposList(for: organizationName, page: pageNumber)
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
    
    var tableViewPagination: LoadingStatePublisher {
        tableViewPaginationSubject.eraseToAnyPublisher()
    }
    
    // MARK: Methods
    
    func onRepoSelection(_ indexPath: IndexPath) {
        let repo = dataSourceSubject.value.getCell(for: indexPath)
        
        switch repo {
        case .reposCell(let viewModel):
            router.presentBrowser(with: viewModel.url)
        }
    }
    
    func onBottomScroll() {
        guard
            tableViewPaginationSubject.value != .loading,
            hasMorePages
        else {
            return
        }
        
        tableViewPaginationSubject.send(.loading)
        pageNumber += 1
        
        repoService.getReposList(for: organizationName, page: pageNumber)
            .sink { [weak self] completion in
                guard let self else { return }

                switch completion {
                case .finished:
                    tableViewPaginationSubject.send(.finished)

                case .failure(let error):
                    tableViewPaginationSubject.send(.failed(error))
                }
            } receiveValue: { [weak self] repos in
                guard let self else { return }
                
                hasMorePages = repos.isEmpty == false

                let dataSource = dataSourceSubject.value
                dataSource.createCells(repos: repos, isPaginating: true)
                dataSourceSubject.send(dataSource)
            }
            .store(in: &cancellables)
    }
}
