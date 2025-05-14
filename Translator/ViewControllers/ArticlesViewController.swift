import UIKit

final class ArticlesViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private let articles: [Article] = [
        Article(title: "Why Dogs Bark", subtitle: "Understanding canine communication"),
        Article(title: "Cat Body Language", subtitle: "How to read feline emotions"),
        Article(title: "Training Tips", subtitle: "Positive reinforcement techniques"),
        Article(title: "Pet Nutrition Basics", subtitle: "Feeding your furry friend right")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemMint
        setupTableView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ArticlesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let article = articles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var config = cell.defaultContentConfiguration()
        config.text = article.title
        config.secondaryText = article.subtitle
        config.image = UIImage(systemName: "doc.text")
        cell.contentConfiguration = config
        
        return cell
    }
}
