// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

enum DateFormat: String {
  case serverDate = "yyyy-MM-dd"
  case dayMonthYear = "dd MMMM yyyy"
}

extension String {
  func toDate(with format: DateFormat) -> Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = format.rawValue
    return formatter.date(from: self)
  }
  
  func formatDate(from format: DateFormat, to expectedFormat: DateFormat) -> String {
    guard let date = toDate(with: format) else { return self }
    return date.toString(with: expectedFormat)
  }
}

extension Date {
  func toString(with format: DateFormat) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = format.rawValue
    return formatter.string(from: self)
  }
}
