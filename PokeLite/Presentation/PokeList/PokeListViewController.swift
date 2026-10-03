//
//  ViewController.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//

import UIKit

class PokeListViewController: UIViewController {
    
    private let appBarTitle: UILabel = {
        let label = UILabel()
        label.text = "Pokemon"
        label.font = .systemFont(ofSize: 24, weight: .heavy)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(appBarTitle)
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            appBarTitle.topAnchor.constraint(equalTo: safe.topAnchor, constant: -30),
            appBarTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appBarTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }

}

