// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit
import WikiMov

class MovieListViewController: SharedView, Alertable {
  
  var presenter: MovieListPresenter! {
    didSet { load() }
  }
  
  private lazy var titleLabel = UILabel.make {
    $0.textColor = .black
    $0.text = Constants.App.title
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
  }
  
  private lazy var categoryButton = UIButton.make {
    $0.height(40)
    $0.horizontalPadding(to: view)
    $0.bottom(to: view, of: .bottom(true), 0)
    $0.setTitle("Choose Category", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = Constants.Color.pink
    $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.addTarget(self, action: #selector(selectCategory), for: .touchUpInside)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    show(isLoading: true)
    configureViews()
    configureSubviews()
    configureBarButton()
  }
  
  // MARK: - Helpers
  private func load(endpoint: Endpoint = MovieEndpoint.nowPlaying) {
    self.presenter.loadMovies(from: endpoint)
    self.presenter.dataSource.observe(on: self) { [weak self] dataSource in
      guard let self = self, let dataSource = dataSource else { return }
      self.tableView.dataSourceDelegate(dataSource).reloads()
    }
  }
  
  private func configureViews() {
    tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
    tableViewHeight = tableView.heightAnchor.constraint(equalToConstant: 0)
    scrollView.top(to: view, of: .top(true), 0).horizontalPadding(to: view)
  }
  
  private func configureSubviews() {
    view.addSubviews([
      scrollView.addArrangedSubViews([tableView]),
      categoryButton
    ]).addCustomConstraints([
      .spacing(from: scrollView, .bottom(false), relation: .equal, to: categoryButton, .top(false))
    ])
  }
  
  private func configureBarButton() {
    makeBarButton(withCustomView: titleLabel, position: .leftBarButton)
    let rightBarButton = makeBarButton(withImage: Constants.Image.favorite, position: .rightBarButton)
    rightBarButton.tintColor = Constants.Color.pink
    rightBarButton.action = #selector(goToFavorites)
  }
  
  // MARK: - Events
  @objc private func goToFavorites() {
    self.presenter.loadFavoriteMovies()
  }
  
  @objc private func selectCategory() {
    showCategoryAlert {
      self.load(endpoint: MovieEndpoint.upcoming)
    } popular: {
      self.load(endpoint: MovieEndpoint.popular)
    } topRated: {
      self.load(endpoint: MovieEndpoint.topRated)
    } nowPlaying: {
      self.load(endpoint: MovieEndpoint.nowPlaying)
    }
  }
}

extension MovieListViewController: MovieListViewBehavior {
  
  var navigation: UINavigationController? {
    return self.navigationController
  }
  
  func show(isLoading: Bool) {
    if isLoading {
      self.scrollView.refreshControl?.beginRefreshing()
    } else {
      self.scrollView.refreshControl?.endRefreshing()
    }
  }
}
