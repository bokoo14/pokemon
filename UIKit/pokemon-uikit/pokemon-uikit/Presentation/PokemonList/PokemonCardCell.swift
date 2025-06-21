//
//  PokemonCardCell.swift
//  pokemon-uikit
//
//  Created by bokyung on 6/21/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

class PokemonCardCell: UICollectionViewCell {
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
    }

    private let nameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.textColor = .label
        $0.lineBreakMode = .byTruncatingTail
    }

    private let favoriteButton = UIButton(type: .system).then {
        $0.tintColor = .gray
    }

    var onToggleFavorite: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.05
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)

        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(favoriteButton)

        imageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(8)
            $0.height.equalTo(imageView.snp.width).multipliedBy(1.25)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(8)
            $0.right.equalTo(favoriteButton.snp.left).offset(-8)
        }

        favoriteButton.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.right.equalToSuperview().inset(8)
            $0.size.equalTo(24)
        }
    }

    @objc private func favoriteButtonTapped() {
        onToggleFavorite?()
    }

    func configure(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name

        if let url = URL(string: pokemon.imageURL), !pokemon.imageURL.isEmpty {
            imageView.kf.setImage(with: url, placeholder: placeholderImage())
        } else {
            imageView.image = placeholderImage()
        }

        let favoriteSymbol = pokemon.isFavorite ? "star.fill" : "star"
        let favoriteColor = pokemon.isFavorite ? UIColor.systemYellow : UIColor.gray
        favoriteButton.setImage(UIImage(systemName: favoriteSymbol), for: .normal)
        favoriteButton.tintColor = favoriteColor
    }

    private func placeholderImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1.25))
        return renderer.image { context in
            UIColor.gray.withAlphaComponent(0.3).setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }
}
