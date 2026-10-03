//
//  PokeGridCell.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//

import UIKit

final class PokeGridCell: UICollectionViewCell {
    static let reuseIdentifier = "PokeGridCell"

    private let cardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(cardContainer)
        cardContainer.addSubview(imageView)
        cardContainer.addSubview(nameLabel)
        cardContainer.addSubview(numberLabel)

        NSLayoutConstraint.activate([
            cardContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

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

    func configure(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name.capitalized
        numberLabel.text = String(format: "#%03d", pokemon.id)
    }
}
