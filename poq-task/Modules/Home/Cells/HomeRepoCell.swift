//
//  HomeRepoCell.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import UIKit
import Kingfisher
import SnapKit

final class HomeRepoCell: UITableViewCell {

    // MARK: Constants
    
    private enum LocalConstants {
        static let containerSpacing: CGFloat = 10
        static let subviewsSpacing: CGFloat = 12
        static let labelsSpacing: CGFloat = 4
        static let avatarSize: CGFloat = 44
        static let titleFontSize: CGFloat = 18
        static let descriptonFontSize: CGFloat = 18
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
        label.font = UIFont.systemFont(ofSize: LocalConstants.titleFontSize, weight: .medium)

        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: LocalConstants.descriptonFontSize, weight: .light)

        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = LocalConstants.labelsSpacing
        
        return stackView
    }()
    
    private let ownerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var repoInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ownerImageView, labelsStackView])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = LocalConstants.subviewsSpacing
        
        return stackView
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
        
        setAvataraImage(for: repo.ownerAvatarUrl)
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
        containterView.addSubview(repoInfoStackView)
        containterView.addSubview(numbersStackView)
        containterView.addSubview(languageLabel)
    }

    func setConstraints() {
        containterView.snp.remakeConstraints {
            $0.edges.equalToSuperview().inset(LocalConstants.containerSpacing)
        }
        
        repoInfoStackView.snp.remakeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(LocalConstants.subviewsSpacing)
        }
        
        ownerImageView.snp.remakeConstraints {
            $0.width.height.equalTo(LocalConstants.avatarSize)
        }
        
        numbersStackView.snp.remakeConstraints {
            $0.top.equalTo(repoInfoStackView.snp.bottom).offset(LocalConstants.subviewsSpacing)
            $0.trailing.bottom.equalToSuperview().inset(LocalConstants.subviewsSpacing)
        }
        
        languageLabel.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(LocalConstants.subviewsSpacing)
            $0.centerY.equalTo(numbersStackView.snp.centerY)
        }
    }
    
    func setAvataraImage(for ownerImageUrlString: String?) {
        guard
            let ownerImageUrlString,
            let ownerImageUrl = URL(string: ownerImageUrlString)
        else {
            return
        }
        ownerImageView.kf.setImage(with: ownerImageUrl)
    }
}
