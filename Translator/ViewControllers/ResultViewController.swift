import UIKit

protocol ResultViewControllerDelegate: AnyObject {
    func didFinishResult()
}

final class ResultViewController: UIViewController {

    private let message: String
    private let petType: PetType
    weak var delegate: ResultViewControllerDelegate?

    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    private let characterImageView = UIImageView()
    private let bubbleView = UIView()
    private let bubbleLabel = UILabel()
    private let lineImageView = UIImageView()

    init(message: String, petType: PetType) {
        self.message = message
        self.petType = petType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemMint
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        // Title
        titleLabel.text = "Result"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)

        // Close Button
        closeButton.setTitle("", for: .normal)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black
        closeButton.backgroundColor = .white
        closeButton.layer.cornerRadius = 24
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(closeButton)

        // Bubble
        bubbleView.backgroundColor = UIColor(red: 0.84, green: 0.86, blue: 1.0, alpha: 1.0)
        bubbleView.layer.cornerRadius = 16
        bubbleView.layer.masksToBounds = true
        view.addSubview(bubbleView)

        bubbleLabel.text = message
        bubbleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        bubbleLabel.textColor = .black
        bubbleLabel.numberOfLines = 0
        bubbleLabel.textAlignment = .center
        bubbleView.addSubview(bubbleLabel)

        // Character
        characterImageView.image = UIImage(named: petType == .dog ? "dog" : "cat")
        characterImageView.contentMode = .scaleAspectFit
        view.addSubview(characterImageView)

        // Line
        lineImageView.image = UIImage(named: "line")
        lineImageView.contentMode = .scaleAspectFit
        view.addSubview(lineImageView)
    }

    private func setupConstraints() {
        [titleLabel, closeButton, characterImageView, bubbleView, bubbleLabel, lineImageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            closeButton.widthAnchor.constraint(equalToConstant: 48),
            closeButton.heightAnchor.constraint(equalToConstant: 48),

            characterImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            characterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 150),
            characterImageView.heightAnchor.constraint(equalToConstant: 150),

            lineImageView.bottomAnchor.constraint(equalTo: characterImageView.topAnchor, constant: -4),
            lineImageView.centerXAnchor.constraint(equalTo: characterImageView.rightAnchor),
            lineImageView.widthAnchor.constraint(equalToConstant: 100),
            lineImageView.heightAnchor.constraint(equalToConstant: 100),

            bubbleView.bottomAnchor.constraint(equalTo: lineImageView.topAnchor, constant: 8),
            bubbleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bubbleView.widthAnchor.constraint(equalToConstant: 280),
            bubbleView.heightAnchor.constraint(equalToConstant: 120),

            bubbleLabel.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor),
            bubbleLabel.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor),
            bubbleLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 10),
            bubbleLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -10)
        ])
    }

    @objc private func closeTapped() {
        dismiss(animated: true) {
            self.delegate?.didFinishResult()
        }
    }
}
