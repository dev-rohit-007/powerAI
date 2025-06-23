import UIKit

class ViewController: UIViewController {

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to PowerAI"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let playerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Open Video Player", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "PowerAI"

        // Add subviews
        view.addSubview(welcomeLabel)
        view.addSubview(playerButton)

        // Add target
        playerButton.addTarget(self, action: #selector(openPlayerTapped), for: .touchUpInside)

        // Setup constraints
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            playerButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            playerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerButton.widthAnchor.constraint(equalToConstant: 200),
            playerButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    @objc private func openPlayerTapped() {
        let playerVC = PlayerViewController()
        navigationController?.pushViewController(playerVC, animated: true)
    }
}
