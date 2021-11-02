// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import XCTest
import WikiMov

class LoadFavoriteMoviesFromLocalStoreUseCasesTests: XCTestCase {
  
  func test_init_doesNotMessageStoreUponCreation() {
    let (_, store) = makeSUT()
    
    XCTAssertEqual(store.receivedMessages, [])
  }
  
  func test_load_requestsCacheRetrieval() {
    let (sut, store) = makeSUT()
    
    sut.load { _ in }
    
    XCTAssertEqual(store.receivedMessages, [.retrieve])
  }
  
  func test_load_failsOnRetrievalError() {
    let (sut, store) = makeSUT()
    let retrievalError = anyNSError()
   
    expect(sut, toCompleteWith: .failure(retrievalError)) {
      store.completeRetrieval(with: retrievalError)
    }
  }
  
  func test_load_deliversNoDataOnEmptyCache() {
    let (sut, store) = makeSUT()
    
    expect(sut, toCompleteWith: .success([])) {
      store.completeRetrievalWithEmptyCache()
    }
  }
  
  func test_load_deliversDataOnNonEmptyCache() {
    let (sut, store) = makeSUT()
    let data = [uniqueLocalMovie(), uniqueLocalMovie()]
    
    expect(sut, toCompleteWith: .success(data)) {
      store.completeRetrieval(with: data)
    }
  }
  
  func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
    let store = LocalMovieStoreSpy()
    var sut: DefaultLocalMovieLoader? = DefaultLocalMovieLoader(store: store)
    
    var receivedResult = [LoadDataResult]()
    sut?.load { receivedResult.append($0) }
    
    sut = nil
    store.completeRetrievalWithEmptyCache()
    
    XCTAssertTrue(receivedResult.isEmpty)
  }
  
  // MARK: -  Helpers
  private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: DefaultLocalMovieLoader, store: LocalMovieStoreSpy) {
    let store = LocalMovieStoreSpy()
    let sut = DefaultLocalMovieLoader(store: store)
    trackForMemoryLeaks(for: store, file: file, line: line)
    trackForMemoryLeaks(for: sut, file: file, line: line)
    
    return (sut, store)
  }
  
  private func expect(_ sut: DefaultLocalMovieLoader, toCompleteWith expectedResult: LoadDataResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
    
    let exp = expectation(description: "Wait for retrieval completion")
    
    sut.load { receivedResult in
      switch (receivedResult, expectedResult) {
      case let (.success(receivedData), .success(expectedData)):
        XCTAssertEqual(receivedData, expectedData, file: file, line: line)
      case let (.failure(receivedError as NSError?), .failure(expectedError as NSError?)):
        XCTAssertEqual(receivedError, expectedError, file: file, line: line)
      default:
        XCTFail("Expected \(expectedResult), got \(receivedResult) instead.")
      }
      exp.fulfill()
    }
    
    action()
    
    wait(for: [exp], timeout: 1.0)
  }
  
 
}

