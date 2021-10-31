// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation
import XCTest

extension XCTestCase {
  func trackForMemoryLeaks(for instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
      addTeardownBlock { [weak instance] in
          XCTAssertNil(instance, "Instance should have been deallocated. Potental memory leaks.", file: file, line: line)
      }
  }
}
