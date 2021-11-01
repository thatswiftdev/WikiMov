// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class RemoteImageView: UIImageView {
  
  private lazy var components: URLComponents = {
    let components = URLComponents(string: "https://image.tmdb.org/t/p/w500/")!
    return components
  }()
  
  var imageURL: URL?
  
  func setImage(from path: String, contentMode mode: UIView.ContentMode = .scaleToFill) {
    
    contentMode = mode
    
    components.path.append(contentsOf: path)
    
    guard let url = components.url else { return }
    
    imageURL = url
    
    if let imageFromCache = imageCache.object(forKey: url as AnyObject) {
      self.image = imageFromCache as? UIImage
      return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard
        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        let data = data, error == nil,
        let imageToCache = UIImage(data: data)
      else { return }
      DispatchQueue.main.async() {
        if self.imageURL == url {
          self.image = imageToCache
        }
        imageCache.setObject(imageToCache, forKey: url as AnyObject)
      }
    }.resume()
  }
}
