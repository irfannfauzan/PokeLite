//
//  PokemonListViewController.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//
import UIKit

class PokeListViewController: UIViewController {

    private let pokemons: [Pokemon] = [
        Pokemon(id: 1, name: "bulbasaur", imageURL: nil),
        Pokemon(id: 2, name: "ivysaur", imageURL: nil),
        Pokemon(id: 3, name: "venusaur", imageURL: nil),
        Pokemon(id: 4, name: "charmander", imageURL: nil)
    ]

    private let appBarTitle: UILabel = {
        let label = UILabel()
        label.text = "Pokemon"
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        view.addSubview(appBarTitle)
        view.addSubview(collectionView)

        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            appBarTitle.topAnchor.constraint(equalTo: safe.topAnchor),
            appBarTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appBarTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            collectionView.topAnchor.constraint(equalTo: appBarTitle.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension PokeListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pokemons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PokeGridCell.reuseIdentifier,
            for: indexPath
        ) as? PokeGridCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: pokemons[indexPath.item])
        return cell
    }
}

extension PokeListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 12
        let width = (collectionView.bounds.width - spacing) / 2
        return CGSize(width: width, height: width * 1.3)
    }
}

