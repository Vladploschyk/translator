import UIKit

final class TranslatorViewController: UIViewController {

    private let titleLabel = UILabel()
    private let humanLabel = UILabel()
    private let petLabel = UILabel()
    private let switchButton = UIButton(type: .system)

    private let mainContainer = UIView()
    private let speakContainer = UIView()
    private let micImageView = UIImageView()
    private let speakLabel = UILabel()

    private let selectorCard = UIView()
    private let catButton = UIButton()
    private let dogButton = UIButton()

    private let characterImageView = UIImageView()
    private let loadingLabel = UILabel()

    private let permissionsManager = PermissionsManager()
    private let speechRecognizer = SpeechRecognizer()
    private let petTranslator = PetTranslator()

    private var selectedPet: PetType = .dog
    private var isHumanToPet = true
    private var isRecording = false
    private var recordedText: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemMint
        setupUI()
        setupConstraints()
        updateSelectionUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        titleLabel.text = "Translator"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)

        humanLabel.text = "HUMAN"
        humanLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        humanLabel.textColor = .black

        petLabel.text = "PET"
        petLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        petLabel.textColor = .black

        switchButton.setImage(UIImage(systemName: "arrow.left.arrow.right"), for: .normal)
        switchButton.tintColor = .black
        switchButton.addTarget(self, action: #selector(switchMode), for: .touchUpInside)

        view.addSubview(humanLabel)
        view.addSubview(switchButton)
        view.addSubview(petLabel)
        view.addSubview(mainContainer)

        speakContainer.backgroundColor = .white
        speakContainer.layer.cornerRadius = 20
        speakContainer.layer.shadowColor = UIColor.black.cgColor
        speakContainer.layer.shadowOpacity = 0.1
        speakContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        mainContainer.addSubview(speakContainer)

        micImageView.image = UIImage(named: "micro")?.withRenderingMode(.alwaysTemplate)
        micImageView.tintColor = .black
        micImageView.contentMode = .scaleAspectFit

        speakLabel.text = "Start Speak"
        speakLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        speakLabel.textColor = .black
        speakLabel.textAlignment = .center

        let speakStack = UIStackView(arrangedSubviews: [micImageView, speakLabel])
        speakStack.axis = .vertical
        speakStack.spacing = 10
        speakStack.alignment = .center
        speakContainer.addSubview(speakStack)

        speakStack.translatesAutoresizingMaskIntoConstraints = false
        micImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            speakStack.centerXAnchor.constraint(equalTo: speakContainer.centerXAnchor),
            speakStack.centerYAnchor.constraint(equalTo: speakContainer.centerYAnchor),
            micImageView.widthAnchor.constraint(equalToConstant: 50),
            micImageView.heightAnchor.constraint(equalToConstant: 50)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(startSpeakingTapped))
        speakContainer.addGestureRecognizer(tap)

        selectorCard.layer.cornerRadius = 20
        selectorCard.backgroundColor = .white
        selectorCard.layer.shadowColor = UIColor.black.cgColor
        selectorCard.layer.shadowOpacity = 0.1
        selectorCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        mainContainer.addSubview(selectorCard)

        catButton.setImage(UIImage(named: "cat"), for: .normal)
        catButton.layer.cornerRadius = 10
        catButton.imageView?.contentMode = .scaleAspectFit
        catButton.addTarget(self, action: #selector(selectCat), for: .touchUpInside)
        selectorCard.addSubview(catButton)

        dogButton.setImage(UIImage(named: "dog"), for: .normal)
        dogButton.layer.cornerRadius = 10
        dogButton.imageView?.contentMode = .scaleAspectFit
        dogButton.addTarget(self, action: #selector(selectDog), for: .touchUpInside)
        selectorCard.addSubview(dogButton)

        view.addSubview(characterImageView)
        view.addSubview(loadingLabel)
        loadingLabel.isHidden = true
    }

    // MARK: - Constraints
    private func setupConstraints() {
        [titleLabel, humanLabel, petLabel, switchButton,
         mainContainer, speakContainer, selectorCard,
         catButton, dogButton, characterImageView, loadingLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -25),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            humanLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            humanLabel.trailingAnchor.constraint(equalTo: switchButton.leadingAnchor, constant: -40),
            humanLabel.centerYAnchor.constraint(equalTo: switchButton.centerYAnchor),

            switchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            switchButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),

            petLabel.leadingAnchor.constraint(equalTo: switchButton.trailingAnchor, constant: 40),
            petLabel.centerYAnchor.constraint(equalTo: switchButton.centerYAnchor),

            mainContainer.topAnchor.constraint(equalTo: switchButton.bottomAnchor, constant: 40),
            mainContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainContainer.heightAnchor.constraint(equalToConstant: 180),
            mainContainer.widthAnchor.constraint(equalToConstant: 280),

            speakContainer.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            speakContainer.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            speakContainer.widthAnchor.constraint(equalToConstant: 160),
            speakContainer.heightAnchor.constraint(equalToConstant: 160),

            selectorCard.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor),
            selectorCard.topAnchor.constraint(equalTo: speakContainer.topAnchor),
            selectorCard.widthAnchor.constraint(equalToConstant: 80),
            selectorCard.heightAnchor.constraint(equalToConstant: 160),

            catButton.topAnchor.constraint(equalTo: selectorCard.topAnchor, constant: 10),
            catButton.leadingAnchor.constraint(equalTo: selectorCard.leadingAnchor, constant: 10),
            catButton.trailingAnchor.constraint(equalTo: selectorCard.trailingAnchor, constant: -10),
            catButton.heightAnchor.constraint(equalToConstant: 60),

            dogButton.topAnchor.constraint(equalTo: catButton.bottomAnchor, constant: 10),
            dogButton.leadingAnchor.constraint(equalTo: selectorCard.leadingAnchor, constant: 10),
            dogButton.trailingAnchor.constraint(equalTo: selectorCard.trailingAnchor, constant: -10),
            dogButton.heightAnchor.constraint(equalToConstant: 60),

            characterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            characterImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            characterImageView.widthAnchor.constraint(equalToConstant: 150),
            characterImageView.heightAnchor.constraint(equalToConstant: 150),

            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingLabel.topAnchor.constraint(equalTo: characterImageView.topAnchor, constant: -40)
        ])
    }

    // MARK: - Reset UI
    func resetUIToInitialState() {
        speakContainer.isHidden = false
        selectorCard.isHidden = false
        humanLabel.isHidden = false
        petLabel.isHidden = false
        switchButton.isHidden = false
        loadingLabel.isHidden = true

        speakLabel.text = "Start Speak"
        micImageView.image = UIImage(named: "micro")?.withRenderingMode(.alwaysTemplate)
        micImageView.isHidden = false
    }

    private func updateRecordingUI(started: Bool) {
        if started {
            speakLabel.text = "Recording..."
            micImageView.image = UIImage(named: "waveform")?.withRenderingMode(.alwaysTemplate)
        } else {
            speakLabel.text = "Start Speak"
            micImageView.image = UIImage(named: "micro")?.withRenderingMode(.alwaysTemplate)
        }
    }

    private func showTranslationProcessUI() {
        speakContainer.isHidden = true
        selectorCard.isHidden = true
        humanLabel.isHidden = true
        petLabel.isHidden = true
        switchButton.isHidden = true

        loadingLabel.isHidden = false
        loadingLabel.text = "Process of translation..."
        loadingLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        loadingLabel.textColor = .black
        loadingLabel.textAlignment = .center
    }

    @objc private func switchMode() {
        isHumanToPet.toggle()
        if isHumanToPet {
            humanLabel.text = "HUMAN"
            petLabel.text = "PET"
        } else {
            humanLabel.text = "PET"
            petLabel.text = "HUMAN"
        }
    }

    @objc private func selectCat() {
        selectedPet = .cat
        updateSelectionUI()
    }

    @objc private func selectDog() {
        selectedPet = .dog
        updateSelectionUI()
    }

    private func updateSelectionUI() {
        catButton.backgroundColor = selectedPet == .cat ? UIColor.systemBlue.withAlphaComponent(0.2) : .clear
        dogButton.backgroundColor = selectedPet == .dog ? UIColor.systemGreen.withAlphaComponent(0.2) : .clear
        characterImageView.image = UIImage(named: selectedPet == .dog ? "dog" : "cat")
    }

    @objc private func startSpeakingTapped() {
        if isRecording {
            print("🛑 Stop recording tapped")
            isRecording = false
            updateRecordingUI(started: false)
            speechRecognizer.stopRecording()

            showTranslationProcessUI()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let pet = self.selectedPet
                let translated = self.petTranslator.translate(humanText: self.recordedText, petType: pet)

                let resultVC = ResultViewController(message: translated, petType: pet)
                resultVC.modalPresentationStyle = .fullScreen
                resultVC.delegate = self
                self.present(resultVC, animated: true)
            }
        } else {
            print("🎤 Start recording tapped")
            isRecording = true
            updateRecordingUI(started: true)
            recordedText = ""

            permissionsManager.requestMicrophonePermission { [weak self] micGranted in
                guard micGranted else {
                    self?.showMicrophoneAccessAlert()
                    return
                }

                self?.speechRecognizer.requestAuthorization { granted in
                    guard granted else {
                        self?.showSpeechAccessAlert()
                        return
                    }

                    try? self?.speechRecognizer.startRecording { [weak self] text in
                        self?.recordedText = text ?? ""
                        print("✅ Final recognized: \(self?.recordedText ?? "")")
                    }
                }
            }
        }
    }

    private func showMicrophoneAccessAlert() {
        let alert = UIAlertController(title: "Microphone Access Denied",
                                      message: "Please enable microphone access in Settings.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func showSpeechAccessAlert() {
        let alert = UIAlertController(title: "Speech Recognition Denied",
                                      message: "Please enable speech recognition access in Settings.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

extension TranslatorViewController: ResultViewControllerDelegate {
    func didFinishResult() {
        resetUIToInitialState()
    }
}
