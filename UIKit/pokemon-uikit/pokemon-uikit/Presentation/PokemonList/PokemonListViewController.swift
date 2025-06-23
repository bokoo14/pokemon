//
//  PokemonListViewController.swift
//  pokemon-uikit
//
//  Created by bokyung on 6/21/25.
//

import UIKit
import Combine
import CombineCocoa
import SnapKit
import Then

final class PokemonListViewController: UIViewController {
    
    private let viewModel: PokemonListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let topHStack = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 8
    }
    
    private let favoriteToggleButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "star"), for: .normal)
        $0.tintColor = .gray
    }
    
    private let searchBar = UISearchBar().then {
        $0.placeholder = "검색하세요"
        $0.searchBarStyle = .minimal
        $0.autocapitalizationType = .none
    }
    
    private let supertypeScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    private let supertypeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    private let typeScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
    }
    private let typeStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 30, right: 10)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(PokemonCardCell.self, forCellWithReuseIdentifier: "PokemonCardCell")
        view.register(SkeletonCardCell.self, forCellWithReuseIdentifier: "SkeletonCardCell")
        return view
    }()
    
    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        viewModel.loadPokemons()
    }
    
    private func setupUI() {
        view.addSubview(topHStack)
        view.addSubview(supertypeScrollView)
        view.addSubview(typeScrollView)
        view.addSubview(collectionView)
        
        topHStack.addArrangedSubview(searchBar)
        topHStack.addArrangedSubview(favoriteToggleButton)
        topHStack.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        searchBar.setContentHuggingPriority(.defaultLow, for: .horizontal)
        favoriteToggleButton.setContentHuggingPriority(.required, for: .horizontal)
        
        supertypeScrollView.addSubview(supertypeStackView)
        supertypeScrollView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        supertypeStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
            $0.height.equalToSuperview()
        }
        
        typeScrollView.addSubview(typeStackView)
        typeScrollView.snp.makeConstraints {
            $0.top.equalTo(supertypeScrollView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        typeStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
            $0.height.equalToSuperview()
        }
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.snp.makeConstraints {
            $0.top.equalTo(typeScrollView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        favoriteToggleButton
            .touchPublisher
            .sink { [weak self] _ in
                self?.viewModel.isShowFavoritesOnly.toggle()
            }
            .store(in: &cancellables)
        
        searchBar
            .textDidChangePublisher
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.viewModel.searchText = text
            }
            .store(in: &cancellables)
        
        viewModel.$pokemons
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isShowFavoritesOnly
            .receive(on: RunLoop.main)
            .sink { [weak self] isFav in
                let symbol = isFav ? "star.fill" : "star"
                let color = isFav ? UIColor.systemYellow : UIColor.gray
                self?.favoriteToggleButton.setImage(UIImage(systemName: symbol), for: .normal)
                self?.favoriteToggleButton.tintColor = color
            }
            .store(in: &cancellables)
        
        viewModel.$superTypes
            .receive(on: RunLoop.main)
            .sink { [weak self] types in
                self?.setupSupertypeButtons(types: types)
            }
            .store(in: &cancellables)
        
        viewModel.$types
            .receive(on: RunLoop.main)
            .sink { [weak self] types in
                self?.setupTypeButtons(types: types)
            }
            .store(in: &cancellables)
        
        viewModel.$selectedSuperType
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.setupSupertypeButtons(types: self?.viewModel.superTypes ?? [])
            }
            .store(in: &cancellables)
        
        viewModel.$selectedTypes
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.setupTypeButtons(types: self?.viewModel.types ?? [])
            }
            .store(in: &cancellables)
    }
    
    private func setupSupertypeButtons(types: [String]) {
        supertypeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for type in types {
            let button = makeFilterButton(title: type, isSupertype: true)
            supertypeStackView.addArrangedSubview(button)
        }
    }
    
    private func setupTypeButtons(types: [String]) {
        typeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for type in types {
            let button = makeFilterButton(title: type, isSupertype: false)
            typeStackView.addArrangedSubview(button)
        }
    }
    
    private func makeFilterButton(title: String, isSupertype: Bool) -> UIButton {
        let isSelected: Bool = isSupertype
            ? viewModel.selectedSuperType == title
            : viewModel.selectedTypes.contains(title)
        
        let button = UIButton(type: .system).then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(isSelected ? .white : .black, for: .normal)
            $0.backgroundColor = isSelected ? .black : .systemGray5
            $0.layer.cornerRadius = 4
        }
        
        button.touchPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                if isSupertype {
                    self.viewModel.handleSuperTypeSelection(title)
                } else {
                    self.viewModel.toggleTypeSelection(title)
                }
            }
            .store(in: &cancellables)
        
        return button
    }
}

extension PokemonListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.isLoading ? 10 : viewModel.filteredPokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.isLoading {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkeletonCardCell", for: indexPath) as! SkeletonCardCell
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCardCell", for: indexPath) as! PokemonCardCell
        let pokemon = viewModel.filteredPokemons[indexPath.item]
        cell.configure(with: pokemon)
        cell.onToggleFavorite = { [weak self] in
            self?.viewModel.toggleFavorite(for: pokemon.id)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !viewModel.isLoading else { return }
        let pokemon = viewModel.filteredPokemons[indexPath.item]
        let detailVC = PokemonDetailViewController(pokemon: pokemon) { [weak self] in
            self?.viewModel.toggleFavorite(for: pokemon.id)
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 100 {
            viewModel.loadMoreIfNeeded()
        }
    }
}
