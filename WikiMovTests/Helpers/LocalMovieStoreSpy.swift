// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import WikiMov
import Foundation

func uniqueMachineData() -> LocalMovie {
  return LocalMovie(id: randomNumber(6), title: "A title", backdropPath: "/\(randomNumber(10))", posterPath: "\(randomNumber(10))", releaseDate: "2021-05-20", overview: "An overview", isFavorite: true)
}

func randomNumber(_ digits: Int) -> Int {
  let min = Int(pow(Double(10), Double(digits-1))) - 1
  let max = Int(pow(Double(10), Double(digits))) - 1
  return Int.random(in: min...max)
}

func anyNSError() -> NSError {
  return NSError(domain: "Any Error", code: 0)
}

final class LocalMovieStoreSpy: LocalMovieStore {
  
  enum ReceivedMessage: Equatable {
    case retrieve
    case insert(LocalMovie)
    case delete(LocalMovie)
  }
  
  private(set) var insertionCompletions = [InsertionCompletion]()
  private(set) var retrievalCompletions = [RetrievalCompletion]()
  private(set) var removalCompletion = [RemovalCompletion]()
  
  private(set) var receivedMessages = [ReceivedMessage]()
  
  func insert(_ data: LocalMovie, completion: @escaping InsertionCompletion) {
    receivedMessages.append(.insert(data))
    insertionCompletions.append(completion)
  }
  
  func completeInsertion(with error: Error, at index: Int = 0) {
    insertionCompletions[index](error)
  }
  
  func completeInsertionSuccessfully(at index: Int = 0) {
    insertionCompletions[index](nil)
  }
  
  func retrieve(completion: @escaping (RetrieveCacheDataResult) -> Void) {
    self.receivedMessages.append(.retrieve)
    self.retrievalCompletions.append(completion)
  }
  
  func completeRetrieval(with error: Error, at index: Int = 0) {
    self.retrievalCompletions[index](.failure(error))
  }
  
  func completeRetrieval(with data: [LocalMovie], at index: Int = 0) {
    self.retrievalCompletions[index](.found(data))
  }
  
  func completeRetrievalWithEmptyCache(at index: Int = 0) {
    self.retrievalCompletions[index](.empty)
  }
  
  func remove(_ data: LocalMovie, completion: @escaping RemovalCompletion) {
    self.removalCompletion.append(completion)
    self.receivedMessages.append(.delete(data))
  }
  
  func completeDeletion(with error: Error, at index: Int = 0) {
    self.removalCompletion[index](error)
  }
  
  func completeDeletionSuccessfully(at index: Int = 0) {
    self.removalCompletion[index](nil)
  }
}

