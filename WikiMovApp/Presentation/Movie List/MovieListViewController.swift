// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit
import WikiMov

class MovieListViewController: SharedView, Alertable {
  
  var presenter: MovieListPresenter! {
    didSet { load(endpoint: self.category) }
  }
  
  private var category: MovieEndpoint = .topRated
  
  private lazy var titleLabel = UILabel.make {
    $0.textColor = Constants.Color.black
    $0.text = Constants.App.title
    $0.font = .systemFont(ofSize: 16, weight: .semibold)
  }
  
  private lazy var categoryButton = UIButton.make {
    $0.height(40)
    $0.horizontalPadding(to: view)
    $0.bottom(to: view, of: .bottom(true), 0)
    $0.setTitle("Choose Category", for: .normal)
    $0.setTitleColor(Constants.Color.white, for: .normal)
    $0.backgroundColor = Constants.Color.pink
    $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
    $0.addTarget(self, action: #selector(selectCategory), for: .touchUpInside)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    configureSubviews()
    configureBarButton()
    configureCallback()
  }
  
  // MARK: - Helpers
  private func load(endpoint: Endpoint) {
    self.show(isLoading: true)
    self.presenter.loadMovies(from: endpoint)
    self.presenter.dataSource.observe(on: self) { [weak self] dataSource in
      guard let self = self, let dataSource = dataSource else { return }
      self.tableView.dataSourceDelegate(dataSource).reloads()
    }
  }
  
  private func configureCallback() {
    self.scrollView.refreshCallback = { [weak self] in
      guard let self = self else { return }
      self.load(endpoint: self.category)
    }
  }
  
  private func configureViews() {
    tableViewHeight = tableView.zeroHeightConstraint
    tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
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
      self.category = .upcoming
      self.load(endpoint: MovieEndpoint.upcoming)
    } popular: {
      self.category = .popular
      self.load(endpoint: MovieEndpoint.popular)
    } topRated: {
      self.category = .topRated
      self.load(endpoint: MovieEndpoint.topRated)
    } nowPlaying: {
      self.category = .nowPlaying
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
