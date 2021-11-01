// Created for WikiMov. By @overheardswift.
// Copyright © 2021. All rights reserved.

import XCTest
import WikiMov

class SaveFavoriteMoviesToLocalStoreUseCasesTests: XCTestCase {
  
  func test_init_doesNotMessageStoreUponCreation() {
    let (_, store) = makeSUT()
    
    XCTAssertEqual(store.receivedMessages, [])
  }
  
  func test_save_messageTheStore() {
    let (sut, store) = makeSUT()
    let data = uniqueMachineData()
    
    sut.save(data) { _ in }
    
    XCTAssertEqual(store.receivedMessages, [.insert(data)])
  }
  
  func test_save_failsOnInsertionError() {
    let (sut, store) = makeSUT()
    let insertionError = anyNSError()
    
    expect(sut, toCompleteWithError: insertionError) {
      store.completeInsertion(with: insertionError)
    }
  }
  
  func test_save_succeedsOnSuccessfulCacheInsertion() {
    let (sut, store) = makeSUT()
    
    expect(sut, toCompleteWithError: nil) {
      store.completeInsertionSuccessfully()
    }
  }
  
  func test_save_doesNotDeliverInsertionErrorAfterSUTInstanceHasBeenDeallocated() {
    let store = LocalMovieStoreSpy()
    var sut: DefaultLocalMovieLoader? = DefaultLocalMovieLoader(store: store)
    
    var receivedResult = [DefaultLocalMovieLoader.SaveResult]()
    
    sut?.save(uniqueMachineData()) { receivedResult.append($0) }
    
    sut = nil
    
    store.completeInsertion(with: anyNSError())
    
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
  
  func expect(_ sut: DefaultLocalMovieLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
    let exp = expectation(description: "Wait for save completion.")
    
    var receivedError: Error?
    
    sut.save(uniqueMachineData()) { error in
      receivedError = error
      exp.fulfill()
    }
    
    action()
    wait(for: [exp], timeout: 1.0)
    
    XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
  }
}

