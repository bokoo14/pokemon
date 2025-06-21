//
//  PokemonDetailViewController.swift
//  pokemon-uikit
//
//  Created by bokyung on 6/21/25.
//


import UIKit
import Kingfisher
import SnapKit
import Then

final class PokemonDetailViewController: UIViewController {
    private let pokemon: Pokemon
    private let viewModel: PokemonListViewModel

    init(pokemon: Pokemon, viewModel: PokemonListViewModel) {
        self.pokemon = pokemon
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = pokemon.name
        setupUI()
    }

    private func setupUI() {
        let imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFit
            $0.kf.setImage(with: URL(string: pokemon.imageURL))
        }

        let favoriteButton = UIButton(type: .system).then {
            $0.setImage(UIImage(systemName: pokemon.isFavorite ? "star.fill" : "star"), for: .normal)
            $0.tintColor = pokemon.isFavorite ? .yellow : .gray
            $0.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        }

        view.addSubview(imageView)
        view.addSubview(favoriteButton)

        imageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(300)
        }

        favoriteButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
    }

    @objc private func toggleFavorite() {
        viewModel.toggleFavorite(for: pokemon.id)
        navigationController?.popViewController(animated: true)
    }
}
