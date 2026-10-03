//
//  PokemonListViewController.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//
import UIKit

class PokemonListViewController: UIViewController {
    
    private let viewModel: PokemonViewModel
    
    private let makeDetailViewController: (Int) -> UIViewController
    
    init(viewModel: PokemonViewModel, makeDetailViewController: @escaping (Int) -> UIViewController) {
            self.viewModel = viewModel
            self.makeDetailViewController = makeDetailViewController
            super.init(nibName: nil, bundle: nil)
        }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.register(PokeGridCell.self, forCellWithReuseIdentifier: PokeGridCell.reuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        title = "Pokemon"
        let appereance = UINavigationBarAppearance()
        appereance.configureWithOpaqueBackground()
        appereance.backgroundColor = .systemRed
        appereance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appereance
        navigationItem.scrollEdgeAppearance = appereance
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(collectionView)
        view.addSubview(loadingIndicator)
        view.addSubview(statusLabel)

        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
           
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

        ])
        
        bindViewModel()
        
        Task {
            await viewModel.loadPokemon()
        }
    }
    
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }
    }
    
    private func render(_ state: PokemonState) {
        switch state {
        case .loading:
            collectionView.isHidden = true
            statusLabel.isHidden = true
            loadingIndicator.startAnimating()
        case .loaded:
            loadingIndicator.stopAnimating()
            statusLabel.isHidden = true
            collectionView.isHidden = false
            collectionView.reloadData()
        case .empty:
            loadingIndicator.stopAnimating()
            collectionView.isHidden = true
            statusLabel.isHidden = false
            statusLabel.text = "Pokemon not found! :("
        case .error(let message):
            loadingIndicator.stopAnimating()
            collectionView.isHidden = true
            statusLabel.isHidden = false
            statusLabel.text = message
        }
    }
}

extension PokemonListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.pokemon.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PokeGridCell.reuseIdentifier,
            for: indexPath
        ) as? PokeGridCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.pokemon[indexPath.item],number: indexPath.item + 1)
        return cell
    }
}

extension PokemonListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 12
        let width = (collectionView.bounds.width - spacing) / 2
        return CGSize(width: width, height: width * 1.3)
    }
}

extension PokemonListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailPokemon = makeDetailViewController(indexPath.item + 1)
        navigationController?.pushViewController(detailPokemon, animated: true)
    }
}

