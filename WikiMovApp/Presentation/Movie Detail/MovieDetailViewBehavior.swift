// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

protocol MovieDetailViewBehavior {
  func configureView(with viewModel: MovieViewModel)
  func show(isLoading: Bool)
}
