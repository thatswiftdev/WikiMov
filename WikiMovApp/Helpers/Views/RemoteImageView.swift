// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class RemoteImageView: UIImageView {
  
  private lazy var urlString: String = {
    return "https://image.tmdb.org/t/p/w500/"
  }()
  
  var imageURL: URL?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  func setImage(from path: String, contentMode mode: UIView.ContentMode = .scaleToFill) {
    
    contentMode = mode
    image = nil
    
    guard let url = URL(string: urlString+path) else { return }
    
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
