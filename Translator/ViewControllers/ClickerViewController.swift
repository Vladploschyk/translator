import UIKit

final class ClickerViewController: UIViewController {

    private let titleLabel = UILabel()
    private let options = ["Rate Us", "Share App", "Contact Us", "Restore Purchases", "Privacy Policy", "Terms of Use"]
    private var buttons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemMint
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        titleLabel.text = "Settings"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)

        for title in options {
            var config = UIButton.Configuration.filled()
            config.baseBackgroundColor = UIColor(red: 0.89, green: 0.91, blue: 1.0, alpha: 1.0)
            config.baseForegroundColor = .black
            config.image = UIImage(systemName: "chevron.right")
            config.imagePlacement = .trailing
            config.imagePadding = 0
            config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20)
            config.cornerStyle = .large

            let button = UIButton(configuration: config, primaryAction: nil)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            let attributedString = NSAttributedString(string: title, attributes: [
                .font: UIFont.systemFont(ofSize: 17, weight: .medium),
                .paragraphStyle: paragraphStyle
            ])
            button.setAttributedTitle(attributedString, for: .normal)
            button.configuration?.title = nil
            button.contentHorizontalAlignment = .fill
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            buttons.append(button)
        }
    }

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        var previousView: UIView = titleLabel

        for button in buttons {
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 16),
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
                button.heightAnchor.constraint(equalToConstant: 48)
            ])
            previousView = button
        }
    }
}
