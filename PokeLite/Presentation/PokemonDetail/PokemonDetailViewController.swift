//
//  PokemonDetailViewController.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    private let viewModel: PokemonDetailViewModel
    
    private var imageLoadTask: Task<Void, Never>?
    
    private let backgroundColors: [UIColor] = [
        .systemGreen,
        .systemBlue,
        .systemRed,
        .systemYellow,
        .systemPurple,
        .systemOrange,
        .systemTeal,
        .systemPink
    ]
    
    init(viewModel: PokemonDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder){
        fatalError("")
    }
        
    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "bulbasaur")
        imgView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()

    private let contentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Bulbasaur"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        view.backgroundColor = backgroundColors.randomElement() ?? .systemGreen

        view.addSubview(imageView)
        view.addSubview(contentContainerView)
        view.addSubview(loadingIndicator)
        view.addSubview(statusLabel)
        contentContainerView.addSubview(nameLabel)
        
        contentContainerView.layer.cornerRadius = 28
        contentContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentContainerView.clipsToBounds = true

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            contentContainerView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            nameLabel.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -24),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
        
        bindViewModel()
        
        Task {
            await viewModel.loadDetail()
        }
    }
    
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }
    }
    
    private func render(_ state: PokemonDetailState) {
        switch state {
        case .loading:
            statusLabel.isHidden = true
            loadingIndicator.startAnimating()
        case .loaded(let pokemon):
            loadingIndicator.stopAnimating()
            statusLabel.isHidden = true
            populate(with: pokemon)
        case .empty:
            loadingIndicator.stopAnimating()
            statusLabel.isHidden = false
            statusLabel.text = "Pokemon not found! :("
        case .error(let message):
            loadingIndicator.stopAnimating()
            statusLabel.isHidden = false
            statusLabel.text = message
        }
    }

    private func populate(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name.capitalized
        imageView.image = nil
        let spriteURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(viewModel.pokemonId).png")
        loadImage(from: spriteURL)
    }

    private func loadImage(from url: URL?) {
        imageLoadTask?.cancel()
        guard let url else { return }
        
        imageLoadTask = Task { [weak self] in
            guard let (data, _) = try? await URLSession.shared.data(from: url),
                  let image = UIImage(data: data),
                  !Task.isCancelled else { return }
            
            await MainActor.run {
                self?.imageView.image = image
            }
            
        }
    }
}
