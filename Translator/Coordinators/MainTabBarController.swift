import UIKit

final class MainTabBarController: UITabBarController {

    private let tabBarBackgroundView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupTabBarAppearance()
        addCustomTabBarBackground()
    }

    private func setupTabs() {
        let translatorVC = UINavigationController(rootViewController: TranslatorViewController())
        translatorVC.tabBarItem = UITabBarItem(
            title: "Translator",
            image: UIImage(systemName: "bubble.left.and.bubble.right"),
            tag: 0
        )

        let clickerVC = UINavigationController(rootViewController: ClickerViewController())
        clickerVC.tabBarItem = UITabBarItem(
            title: "Clicker",
            image: UIImage(systemName: "gearshape"),
            tag: 1
        )

        let soundsVC = UINavigationController(rootViewController: SoundsViewController())
        soundsVC.tabBarItem = UITabBarItem(
            title: "Sounds",
            image: UIImage(systemName: "speaker.wave.2"),
            tag: 2
        )

        let articlesVC = UINavigationController(rootViewController: ArticlesViewController())
        articlesVC.tabBarItem = UITabBarItem(
            title: "Articles",
            image: UIImage(systemName: "doc.text"),
            tag: 3
        )

        viewControllers = [translatorVC, clickerVC, soundsVC, articlesVC]
    }

    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear

        appearance.stackedLayoutAppearance.normal.iconColor = .black
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.systemGray
        ]

        appearance.stackedLayoutAppearance.selected.iconColor = .black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance

        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.backgroundColor = .clear
    }

    private func addCustomTabBarBackground() {
        tabBarBackgroundView.backgroundColor = .white
        tabBarBackgroundView.layer.cornerRadius = 20
        tabBarBackgroundView.layer.masksToBounds = false
        tabBarBackgroundView.layer.shadowColor = UIColor.black.cgColor
        tabBarBackgroundView.layer.shadowOpacity = 0.05
        tabBarBackgroundView.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBarBackgroundView.layer.shadowRadius = 10

        view.addSubview(tabBarBackgroundView)
        view.bringSubviewToFront(tabBar)

        tabBarBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBarBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tabBarBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tabBarBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            tabBarBackgroundView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}
