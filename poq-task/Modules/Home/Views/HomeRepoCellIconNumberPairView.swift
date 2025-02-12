//
//  HomeRepoCellIconNumberPairView.swift
//  poq-task
//
//  Created by Hercig, Filip (148) on 11.02.25.
//

import UIKit
import SnapKit

final class HomeRepoCellIconNumberPairView: UIView {
    
    // MARK: Constants
    
    private enum LocalConstants {
        static let spacing: CGFloat = 4
        static let numberLabelWidth: CGFloat = 30
    }
    
    // MARK: Views
    
    private let iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.tintColor = .textPrimary
        icon.contentMode = .scaleAspectFit
        
        return icon
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        
        return label
    }()
    
    // MARK: Init
    
    init(iconName: String) {
        super.init(frame: .zero)
        
        iconImageView.image = .init(systemName: iconName)
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Setup
    
    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(numberLabel)
    }
    
    private func setConstraints() {
        iconImageView.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(LocalConstants.spacing)
            $0.centerX.equalTo(numberLabel.snp.centerX)
            $0.width.equalTo(LocalConstants.numberLabelWidth)
        }
        
        numberLabel.snp.remakeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(LocalConstants.spacing)
            $0.leading.trailing.bottom.equalToSuperview().inset(LocalConstants.spacing)
            $0.width.equalTo(LocalConstants.numberLabelWidth)
        }
    }
    
    // MARK: Public
    
    func update(number: Int) {
        numberLabel.text = "\(number)"
    }
}
