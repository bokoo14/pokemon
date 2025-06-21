//
//  SkeletonCardCell.swift
//  pokemon-uikit
//
//  Created by bokyung on 6/21/25.
//

import UIKit
import SnapKit
import Then

final class SkeletonCardCell: UICollectionViewCell {

    private let imagePlaceholder = UIView().then {
        $0.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }

    private let textPlaceholder = UIView().then {
        $0.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowRadius = 2
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)

        contentView.addSubview(imagePlaceholder)
        contentView.addSubview(textPlaceholder)

        imagePlaceholder.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(8)
            $0.height.equalTo(imagePlaceholder.snp.width).multipliedBy(1.25)
        }

        textPlaceholder.snp.makeConstraints {
            $0.top.equalTo(imagePlaceholder.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(8)
            $0.height.equalTo(20)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
}
