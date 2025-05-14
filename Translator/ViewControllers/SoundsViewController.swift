import UIKit
import AVFoundation

final class SoundsViewController: UIViewController {
    
    private var player: AVAudioPlayer?
    
    private let sounds: [(title: String, file: String)] = [
        ("Dog Bark", "bark"),
        ("Dog Growl", "growl"),
        ("Cat Meow", "meow"),
        ("Cat Purr", "purr")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemMint
        setupButtons()
    }
    
    private func setupButtons() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        for (index, sound) in sounds.enumerated() {
            let button = makeButton(title: sound.title)
            button.tag = index
            button.addTarget(self, action: #selector(soundButtonTapped(_:)), for: .touchUpInside)
            stack.addArrangedSubview(button)
        }
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func makeButton(title: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
        
        let button = UIButton(configuration: config)
        return button
    }
    
    @objc private func soundButtonTapped(_ sender: UIButton) {
        let sound = sounds[sender.tag]
        playSound(named: sound.file)
    }
    
    private func playSound(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("⚠️ Sound not found: \(name)")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("❌ Failed to play sound: \(error)")
        }
    }
}
