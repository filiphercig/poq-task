//
//  HomeRepoCell.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import UIKit
import SnapKit

final class HomeRepoCell: UITableViewCell {

    // MARK: Constants
    
    private enum LocalConstants {
        static let containerSpacing: CGFloat = 10
        static let subviewsSpacing: CGFloat = 12
    }
    
    // MARK: Views

    private let containterView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundSecondary
        view.layer.cornerRadius = 12
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = .init(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1

        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)

        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)

        return label
    }()

    private let forksView = HomeRepoCellIconNumberPairView(iconName: "arrow.branch")
    private let starsView = HomeRepoCellIconNumberPairView(iconName: "star")
    private let followersView = HomeRepoCellIconNumberPairView(iconName: "eye")

    private lazy var numbersStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [forksView, starsView, followersView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillProportionally

        return stackView
    }()

    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .orange

        return label
    }()

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupCell()
        addSubviews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public

    func update(repo: Model.Repo) {
        titleLabel.text = repo.name
        descriptionLabel.text = repo.description
        languageLabel.text = repo.language?.uppercased()

        forksView.update(number: repo.forks)
        starsView.update(number: repo.stargazersCount)
        followersView.update(number: repo.watchers)
    }
}

// MARK: - UI Setup

private extension HomeRepoCell {

    func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
    }

    func addSubviews() {
        contentView.addSubview(containterView)
        containterView.addSubview(titleLabel)
        containterView.addSubview(descriptionLabel)
        containterView.addSubview(numbersStackView)
        containterView.addSubview(languageLabel)
    }

    func setConstraints() {
        containterView.snp.remakeConstraints {
            $0.edges.equalToSuperview().inset(LocalConstants.containerSpacing)
        }
        
        titleLabel.snp.remakeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(LocalConstants.subviewsSpacing)
        }
        
        descriptionLabel.snp.remakeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(LocalConstants.subviewsSpacing)
        }
        
        numbersStackView.snp.remakeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(LocalConstants.subviewsSpacing)
            $0.trailing.bottom.equalToSuperview().inset(LocalConstants.subviewsSpacing)
        }
        
        languageLabel.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(LocalConstants.subviewsSpacing)
            $0.centerY.equalTo(numbersStackView.snp.centerY)
        }
    }
}
