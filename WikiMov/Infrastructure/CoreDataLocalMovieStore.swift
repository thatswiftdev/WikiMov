// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import CoreData

public final class CoreDataLocalMovieStore: LocalMovieStore {
  
  private static let modelName = "LocalMovieStore"
  private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataLocalMovieStore.self))
  
  private let container: NSPersistentContainer
  private let context: NSManagedObjectContext
  
  enum StoreError: Error {
    case modelNotFound
    case failedToLoadPersistenceStore(Error)
  }
  
  public init(storeURL: URL) throws {
    guard let model = CoreDataLocalMovieStore.model else {
      throw StoreError.modelNotFound
    }
    
    do {
      container = try NSPersistentContainer.load(name: CoreDataLocalMovieStore.modelName, model: model, url: storeURL)
      context = container.newBackgroundContext()
    } catch {
      throw StoreError.failedToLoadPersistenceStore(error)
    }
  }
  
  public func insert(_ data: LocalMovie, completion: @escaping InsertionCompletion) {
    perform { context in
      do {
        let managed = ListFavoriteMovies(context: context)
        managed.id = Int64(data.id)
        managed.title = data.title
        managed.overview = data.overview
        managed.backdropPath = data.backdropPath
        managed.posterPath = data.posterPath
        managed.releaseDate = data.releaseDate
        managed.isFavorite = true
        
        try context.save()
        completion(nil)
      } catch {
        completion(error)
      }
    }
  }
  
  public func retrieve(completion: @escaping RetrievalCompletion) {
    perform { context in
      do {
        
        let cache = try ListFavoriteMovies.find(in: context)
        if cache.isEmpty {
          completion(.empty)
        } else {
          completion(.found(cache.machines))
        }
      } catch {
        completion(.failure(error))
      }
    }
  }
  
  public func remove(_ data: LocalMovie, completion: @escaping RemovalCompletion) {
    perform { context in
      do {
        
        let cache = try ListFavoriteMovies.find(in: context)
        
        if let deletedData = cache.filter({ $0.id == data.id }).first {
          context.delete(deletedData)
          if context.hasChanges {
            try context.save()
          }
        }
        completion(nil)
        
      } catch {
        completion(error)
      }
    }
  }
  
  private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
    let context = self.context
    context.perform { action(context) }
  }
}

private extension NSPersistentContainer {
  static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
    
    let description = NSPersistentStoreDescription(url: url)
    let container = NSPersistentContainer(name: name, managedObjectModel: model)
    container.persistentStoreDescriptions = [description]
    
    var loadError: Swift.Error?
    container.loadPersistentStores { loadError = $1 }
    try loadError.map { throw $0 }
    
    return container
  }
}
private extension NSManagedObjectModel {
  static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
    return bundle
      .url(forResource: name, withExtension: "momd")
      .flatMap { NSManagedObjectModel(contentsOf: $0) }
  }
}

private extension Array where Element: ListFavoriteMovies {
  var machines: [LocalMovie] {
    return map { $0.toLocal() }
  }
}

