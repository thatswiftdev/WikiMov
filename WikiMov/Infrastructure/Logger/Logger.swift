// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import Foundation

public protocol Logger {
  func log(_ response: HTTPURLResponse)
}

public final class DefaultNetworkLogger: Logger {
  
  public init() {}
  
  public func log(_ response: HTTPURLResponse) {
    guard let url = response.url else { return }
    
    print("[+] URL: \(url)")
    print("[+] STATUS: \(response.statusCode)")
  }
}
