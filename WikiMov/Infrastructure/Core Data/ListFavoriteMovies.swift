// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import CoreData

@objc(ListFavoriteMovies)
class ListFavoriteMovies: NSManagedObject {
  @NSManaged var id: Int64
  @NSManaged var title: String
  @NSManaged var overview: String
  @NSManaged var releaseDate: String
  @NSManaged var backdropPath: String
  @NSManaged var posterPath: String
  @NSManaged var isFavorite: Bool
  
  func toLocal() -> LocalMovie {
    return LocalMovie(id: Int(id), title: title, backdropPath: backdropPath, posterPath: posterPath, releaseDate: releaseDate, overview: overview, isFavorite: isFavorite)
  }
  
  static func find(in context: NSManagedObjectContext) throws -> [ListFavoriteMovies] {
    let request = NSFetchRequest<ListFavoriteMovies>(entityName: ListFavoriteMovies.entity().name!)
    request.returnsObjectsAsFaults = false
    
    return try context.fetch(request)
  }
}
