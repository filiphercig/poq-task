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

    private lazy var spinnerView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.startAnimating()
        view.hidesWhenStopped = true
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        tableView.register(HomeRepoCell.self, forCellReuseIdentifier: HomeRepoCell.identity)
        return tableView
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
        addSubviews()
        setConstraints()
        observe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = "Square"
        navigationController?.setupNavigationBar(animated: animated)
    }
}

// MARK: - UI Setup

private extension HomeViewController {

    func setupView() {
        view.backgroundColor = .backgroundPrimary
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
                        title: "Localizable",
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
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onRepoSelection(indexPath)
    }
}
