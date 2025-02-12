//
//  HomeViewController.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import UIKit
import Combine
import SnapKit

final class HomeViewController: UIViewController {

    // MARK: Private Properties

    private let viewModel: HomeViewModeling
    private var cancellables = Set<AnyCancellable>()

    // MARK: Views

    private let spinnerView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.startAnimating()
        view.hidesWhenStopped = true
        return view
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.register(HomeRepoCell.self, forCellReuseIdentifier: HomeRepoCell.identity)
        return tableView
    }()
    
    private let tableViewFooterSpinnerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 64))

        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()

        view.addSubview(spinner)
        spinner.snp.remakeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        return view
    }()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()

    // MARK: Init

    init(viewModel: HomeViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTableView()
        addSubviews()
        setConstraints()
        observe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = .localizable(.poq_home_title)
        navigationController?.setupNavigationBar(animated: animated)
    }
    
    // MARK: Private
    
    @objc private func handleRefresh() {
        viewModel.onPullToRefresh()
    }
}

// MARK: - UI Setup

private extension HomeViewController {

    func setupView() {
        view.backgroundColor = .backgroundPrimary
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.tableFooterView = tableViewFooterSpinnerView
        tableView.refreshControl = refreshControl
    }

    func addSubviews() {
        view.addSubview(spinnerView)
        view.addSubview(tableView)
    }

    func setConstraints() {
        spinnerView.snp.remakeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        tableView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - Data Binding

private extension HomeViewController {

    func observe() {
        viewModel.loadingState
            .sink { [weak self] loadingState in
                guard let self else { return }

                switch loadingState {
                case .empty:
                    spinnerView.startAnimating()
                    tableView.isHidden = true

                case .loading:
                    spinnerView.startAnimating()
                    tableView.isHidden = true

                case .finished:
                    spinnerView.stopAnimating()
                    tableView.isHidden = false

                case .failed(let error):
                    spinnerView.stopAnimating()
                    presentError(
                        title: .localizable(.poq_generic_something_went_wrong_message),
                        message: error.localizedDescription
                    )
                }
            }
            .store(in: &cancellables)

        viewModel.dataSource
            .sink { [weak self] dataSoruce in
                guard let self else { return }
                
                tableView.dataSource = dataSoruce
                tableView.reloadData()
                refreshControl.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.tableViewPagination
            .sink { [weak self] paginationStatus in
                guard let self else { return }

                switch paginationStatus {
                case .empty:
                    break
                case .loading:
                    tableViewFooterSpinnerView.isHidden = false
                case .finished:
                    tableViewFooterSpinnerView.isHidden = true
                case .failed(let error):
                    tableViewFooterSpinnerView.isHidden = true
                    presentError(
                        title: .localizable(.poq_generic_something_went_wrong_message),
                        message: error.localizedDescription
                    )
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onRepoSelection(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cellCount = (tableView.dataSource as? HomeDataSource)?.numberOfCells else {
            return
        }

        if indexPath.row == cellCount - 1 {
            viewModel.onBottomScroll()
        }
    }
}
