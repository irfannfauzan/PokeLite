//
//  TabBarViewController.swift
//  PokeLite
//
//  Created by Vokal-Ican on 03/10/26.
//

import UIKit

final class TabBarViewController: UITabBarController {

    private let pokemonListViewController: UIViewController

    init(pokemonListViewController: UIViewController) {
        self.pokemonListViewController = pokemonListViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }

    private func setupTabs() {
        pokemonListViewController.tabBarItem = UITabBarItem(
            title: "List",
            image: UIImage(systemName: "square.grid.2x2"),
            selectedImage: UIImage(systemName: "square.grid.2x2.fill")
        )
        let listNav = UINavigationController(rootViewController: pokemonListViewController)

        let favoriteVC = FavoriteViewController()
        favoriteVC.tabBarItem = UITabBarItem(
            title: "Favorite",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        let favoriteNav = UINavigationController(rootViewController: favoriteVC)

        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gearshape"),
            selectedImage: UIImage(systemName: "gearshape.fill")
        )
        let settingsNav = UINavigationController(rootViewController: settingsVC)

        viewControllers = [listNav, favoriteNav, settingsNav]
    }

    private func setupAppearance() {
        tabBar.tintColor = .systemRed
        tabBar.unselectedItemTintColor = .systemGray4

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray4
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
