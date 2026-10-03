//
//  PokeGridCell.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//

import UIKit

final class PokeGridCell: UICollectionViewCell {
    
    static let reuseIdentifier = "PokeGridCell"
    
    private var imageLoadTask: Task<Void, Never>?
    
    private var isFavorite: Bool = false

    private let cardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .systemRed
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "heart")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
        button.addTarget(self, action: #selector(favoriteTouchDown), for: .touchDown)
        button.addTarget(self, action: #selector(favoriteTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        imageView.image = nil
    }

    private func setupViews() {
        contentView.addSubview(cardContainer)
        cardContainer.addSubview(imageView)
        cardContainer.addSubview(nameLabel)
        cardContainer.addSubview(numberLabel)
        cardContainer.addSubview(favoriteButton)

        NSLayoutConstraint.activate([
            cardContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 20),
            favoriteButton.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -20),
            favoriteButton.widthAnchor.constraint(equalToConstant: 28),
            favoriteButton.heightAnchor.constraint(equalToConstant: 28),
            
            imageView.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 12),
            imageView.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -12),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -12),

            numberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            numberLabel.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 12),
            numberLabel.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: -12),
        ])
    }
    
    @objc private func didTapFavorite() {
        isFavorite.toggle()

        var config = favoriteButton.configuration
        config?.image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        favoriteButton.configuration = config

        }
    
    @objc private func favoriteTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.favoriteButton.alpha = 0.5
        }
    }

    @objc private func favoriteTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.favoriteButton.alpha = 1.0
        }
    }

    func configure(with pokemon: Pokemon, number: Int) {
        nameLabel.text = pokemon.name.capitalized
        numberLabel.text = String(format: "#%03d", number)
        imageView.image = nil
        let spriteURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(number).png")
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
