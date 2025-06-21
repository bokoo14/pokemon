//
//  PokemonCardViewController.swift
//  pokemon-uikit
//
//  Created by bokyung on 6/21/25.
//

import UIKit
import Kingfisher
import SnapKit
import Then

final class PokemonCardViewController: UICollectionViewCell {

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let nameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
    }

    private let favoriteButton = UIButton().then {
        $0.tintColor = .gray
    }

    var onToggleFavorite: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(favoriteButton)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true

        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(8)
            $0.height.equalTo(imageView.snp.width).multipliedBy(0.75)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(8)
        }

        favoriteButton.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(8)
        }

        favoriteButton.addTarget(self, action: #selector(tapFavorite), for: .touchUpInside)
    }

    required init?(coder: NSCoder) { fatalError() }

    @objc private func tapFavorite() {
        onToggleFavorite?()
    }

    func configure(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name
        if let url = URL(string: pokemon.imageURL) {
            imageView.kf.setImage(with: url)
        }
        let star = pokemon.isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: star), for: .normal)
        favoriteButton.tintColor = pokemon.isFavorite ? .yellow : .gray
    }
}
