// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit
import WikiMov

class MovieListViewController: UIViewController {
  
  var presenter: MovieListPresenter! {
    didSet { load() }
  }
  
  private var tableViewHeight: NSLayoutConstraint? {
    didSet { tableViewHeight?.activated() }
  }
  
  private lazy var titleLabel = UILabel.make {
    $0.textColor = .black
    $0.text = Constants.App.title
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
  }
  
  private lazy var scrollView = ScrollViewContainer.make {
    $0.edges(to: view, 0, true)
    $0.setBackgroundColor(color: .white)
    $0.setSpacingBetweenItems(to: 5)
  }
  
  private lazy var tableView = UITableView.make {
    $0.dataSource = self
    $0.register(UITableViewCell.self, forCellReuseIdentifier: "MovieList")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.addObserver(self, forKeyPath: UITableView.contentSizeKeyPath, options: .new, context: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureSubviews()
    configureBarButton()
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if let newvalue = change?[.newKey], keyPath == UITableView.contentSizeKeyPath {
      let newsize  = newvalue as! CGSize
      self.updateTableViewContentSize(size: newsize.height)
    }
  }
  
  // MARK: - Helpers
  private func load() {
    self.show(isLoading: true)
    self.presenter.loadMovies(from: MovieEndpoint.popular)
  }
  
  private func configureSubviews() {
    tableViewHeight = tableView.heightAnchor.constraint(equalToConstant: 0)
    view.addSubviews([
      scrollView.addArrangedSubViews([
        tableView
      ])
    ])
  }
  
  private func configureBarButton() {
    makeBarButton(withCustomView: titleLabel, position: .leftBarButton)
    let rightBarButton = makeBarButton(withImage: Constants.Image.favorite, position: .rightBarButton)
    rightBarButton.tintColor = Constants.Color.pink
    rightBarButton.action = #selector(goToFavorites)
  }
  
  private func updateTableViewContentSize(size: CGFloat) {
    DispatchQueue.main.async {
      self.scrollView.layoutIfNeeded()
      self.tableViewHeight?.constant = size
    }
  }

  // MARK: - Events
  @objc private func goToFavorites() {}
}

extension MovieListViewController: MovieListViewBehavior {
  func show(isLoading: Bool) {
    if isLoading {
      self.scrollView.refreshControl?.beginRefreshing()
    } else {
      self.scrollView.refreshControl?.endRefreshing()
    }
  }
}

extension MovieListViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MovieList")
    cell.textLabel?.text = "Title @\(indexPath.row+1)"
    cell.detailTextLabel?.text = "Description @\(indexPath.row+1)"
    return cell
  }
}
