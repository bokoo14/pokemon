//
//  PokemonDetailViewController.swift
//  pokemon-uikit
//
//  Created by bokyung on 6/21/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class PokemonDetailViewController: UIViewController {
    
    private var pokemon: Pokemon
    private let onToggleFavorite: () -> Void
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .systemGray6
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 24)
        $0.textAlignment = .center
    }
    
    private let logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private let infoContainer = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 10
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowRadius = 4
    }
    
    private let infoTitleLabel = UILabel().then {
        $0.text = "포켓몬 정보"
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    private let favoriteButton = UIButton(type: .system)
    private let idLabel = UILabel()
    private let typesLabel = UILabel()
    
    init(pokemon: Pokemon, onToggleFavorite: @escaping () -> Void) {
        self.pokemon = pokemon
        self.onToggleFavorite = onToggleFavorite
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupUI()
        configure()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [imageView, nameLabel, logoImageView, infoContainer].forEach {
            contentView.addSubview($0)
        }
        
        [infoTitleLabel, favoriteButton, idLabel, typesLabel].forEach {
            infoContainer.addSubview($0)
        }
        
        scrollView.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(300)
            $0.width.lessThanOrEqualTo(view).offset(-40)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        infoContainer.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        infoTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(infoTitleLabel)
        }
        
        idLabel.snp.makeConstraints {
            $0.top.equalTo(infoTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        typesLabel.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func configure() {
        if let url = URL(string: pokemon.imageURL), !pokemon.imageURL.isEmpty {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
        
        nameLabel.text = pokemon.name
        
        if let logoURL = URL(string: pokemon.logoImage), !pokemon.logoImage.isEmpty {
            logoImageView.kf.setImage(with: logoURL)
        }
        
        favoriteButton.setImage(UIImage(systemName: pokemon.isFavorite ? "star.fill" : "star"), for: .normal)
        favoriteButton.tintColor = pokemon.isFavorite ? .systemYellow : .gray
        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        
        idLabel.text = "아이디: \(pokemon.id)"
        typesLabel.text = "타입: \((pokemon.types ?? []).joined(separator: ", "))"
    }
    
    private func updateFavoriteButton() {
        favoriteButton.setImage(UIImage(systemName: pokemon.isFavorite ? "star.fill" : "star"), for: .normal)
        favoriteButton.tintColor = pokemon.isFavorite ? .systemYellow : .gray
    }
    
    @objc private func didTapFavorite() {
        onToggleFavorite()
        pokemon.isFavorite.toggle()
        updateFavoriteButton()
    }
}
