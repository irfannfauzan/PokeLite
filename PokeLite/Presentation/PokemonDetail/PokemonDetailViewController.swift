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

    private let imageHeight: CGFloat = 280

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let colorBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()

    private let contentContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var grassBadge = makeBadge(text: "Grass", backgroundColor: .systemGreen.withAlphaComponent(0.2), textColor: .systemGreen)
    private lazy var poisonBadge = makeBadge(text: "Poison", backgroundColor: .systemPurple.withAlphaComponent(0.2), textColor: .systemPurple)

    private lazy var badgesStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [grassBadge, poisonBadge])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "#0001"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let pokeballIconView: UIView = {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 24
        container.translatesAutoresizingMaskIntoConstraints = false

        let icon = UIImageView(image: UIImage(systemName: "circle.righthalf.filled"))
        icon.tintColor = .systemRed
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(icon)

        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 26),
            icon.heightAnchor.constraint(equalToConstant: 26),
        ])
        return container
    }()

    private lazy var weightCard = makeStatCard(iconName: "arrow.up.left.and.arrow.down.right", label: "Weight", value: "6.9 kg")
    private lazy var heightCard = makeStatCard(iconName: "ruler", label: "Height", value: "0.7 m")

    private lazy var statsRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [weightCard, heightCard])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var movesCard = makeStatCard(iconName: "flame", label: "Moves", value: "Overgrow")
    private lazy var move1Card = makeStatCard(iconName: "flame", label: "Moves", value: "Overgrow")
    private lazy var move2Card = makeStatCard(iconName: "bolt", label: "Moves", value: "Tackle")
    private lazy var move3Card = makeStatCard(iconName: "leaf", label: "Moves", value: "Vine Whip")

    private lazy var movesStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [move1Card, move2Card, move3Card])
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white.withAlphaComponent(0.3)
        config.baseForegroundColor = .black
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "chevron.left")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        return button
    }()

    init(viewModel: PokemonDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(colorBackgroundView)
        colorBackgroundView.addSubview(imageView)
        contentView.addSubview(contentContainerView)

        contentContainerView.addSubview(badgesStack)
        contentContainerView.addSubview(numberLabel)
        contentContainerView.addSubview(nameLabel)
        contentContainerView.addSubview(pokeballIconView)
        contentContainerView.addSubview(statsRowStack)
        contentContainerView.addSubview(movesStack)

        setupNavigationBar()

        scrollView.delegate = self

        contentContainerView.layer.cornerRadius = 28
        contentContainerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentContainerView.clipsToBounds = true

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            colorBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorBackgroundView.heightAnchor.constraint(equalToConstant: imageHeight),

            imageView.centerXAnchor.constraint(equalTo: colorBackgroundView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: colorBackgroundView.centerYAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            contentContainerView.topAnchor.constraint(equalTo: colorBackgroundView.bottomAnchor, constant: -24),
            contentContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            badgesStack.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 24),
            badgesStack.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 24),

            numberLabel.centerYAnchor.constraint(equalTo: badgesStack.centerYAnchor),
            numberLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -24),

            nameLabel.topAnchor.constraint(equalTo: badgesStack.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 24),

            pokeballIconView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            pokeballIconView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -24),
            pokeballIconView.widthAnchor.constraint(equalToConstant: 48),
            pokeballIconView.heightAnchor.constraint(equalToConstant: 48),

            statsRowStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
            statsRowStack.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 24),
            statsRowStack.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -24),
            statsRowStack.heightAnchor.constraint(equalToConstant: 130),

            movesStack.topAnchor.constraint(equalTo: statsRowStack.bottomAnchor, constant: 16),
            movesStack.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 24),
            movesStack.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -24),
            movesStack.heightAnchor.constraint(equalToConstant: 410),
            movesStack.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -24),
        ])

        bindViewModel()

        Task {
            await viewModel.loadDetail()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupNavigationBar() {
        title = ""
        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 36),
            backButton.heightAnchor.constraint(equalToConstant: 36),
        ])
    }

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }
    }

    private func render(_ state: PokemonDetailState) {
        switch state {
        case .loaded(let pokemon):
            let color = PokemonColor.uiColor(for: pokemon.color.name)
            view.backgroundColor = color
            colorBackgroundView.backgroundColor = color
            nameLabel.text = pokemon.name.capitalized
            title = pokemon.name.capitalized
            loadImage(id: viewModel.pokemonId)
            numberLabel.text = "#000\(viewModel.pokemonId)"
        default:
            break
        }
    }

    private func loadImage(id: Int) {
        imageLoadTask?.cancel()
        let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
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

    private func makeBadge(text: String, backgroundColor: UIColor, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = " \(text)  "
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = textColor
        label.backgroundColor = backgroundColor
        label.textAlignment = .center
        label.layer.cornerRadius = 14
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .horizontal)

        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 28),
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
        ])

        return label
    }

    private func makeStatCard(iconName: String, label: String, value: String) -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        card.translatesAutoresizingMaskIntoConstraints = false

        let iconContainer: UIView = {
            let view = UIView()
            view.backgroundColor = .systemGreen.withAlphaComponent(0.2)
            view.layer.cornerRadius = 16
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

        let iconView: UIImageView = {
            let imageView = UIImageView(image: UIImage(systemName: iconName))
            imageView.tintColor = .systemGreen
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()

        let labelText: UILabel = {
            let text = UILabel()
            text.text = label
            text.font = .systemFont(ofSize: 13, weight: .regular)
            text.textColor = .systemGray
            text.translatesAutoresizingMaskIntoConstraints = false
            return text
        }()

        let valueText: UILabel = {
            let text = UILabel()
            text.text = value
            text.font = .systemFont(ofSize: 20, weight: .bold)
            text.textColor = .black
            text.translatesAutoresizingMaskIntoConstraints = false
            return text
        }()

        card.addSubview(iconContainer)
        iconContainer.addSubview(iconView)
        card.addSubview(labelText)
        card.addSubview(valueText)

        NSLayoutConstraint.activate([
            iconContainer.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            iconContainer.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            iconContainer.widthAnchor.constraint(equalToConstant: 32),
            iconContainer.heightAnchor.constraint(equalToConstant: 32),

            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 16),
            iconView.heightAnchor.constraint(equalToConstant: 16),

            labelText.topAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: 12),
            labelText.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),

            valueText.topAnchor.constraint(equalTo: labelText.bottomAnchor, constant: 4),
            valueText.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            valueText.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
        ])

        return card
    }
}

extension PokemonDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let progress = min(max(offsetY / imageHeight, 0), 1)

        if progress >= 1 {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            navigationItem.standardAppearance = appearance
            navigationItem.scrollEdgeAppearance = appearance

            navigationController?.setNavigationBarHidden(false, animated: true)
            backButton.isHidden = true
        } else {
            navigationController?.setNavigationBarHidden(true, animated: true)
            backButton.isHidden = false
        }
    }
}
