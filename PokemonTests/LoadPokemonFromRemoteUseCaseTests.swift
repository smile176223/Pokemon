//
//  LoadPokemonFromRemoteUseCaseTests.swift
//  PokemonTests
//
//  Created by Liam on 2024/9/3.
//

import XCTest

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    func get(from url: URL, completion: @escaping (Result) -> Void)
}

public final class RemotePokemonLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case unexpectedError
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result<String, Error>) -> Void) {
        client.get(from: url) { result in
            completion(.failure(Error.unexpectedError))
        }
    }
}

class HTTPClientSpy: HTTPClient {
    private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()

    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    func get(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) {
        messages.append((url, completion))
    }
    
    func complete(with error: Error, at index: Int = 0, file: StaticString = #file, line: UInt = #line) {
        guard messages.count > index else {
            return XCTFail("Can't complete request never made", file: file, line: line)
        }
        
        messages[index].completion(.failure(error))
    }
}

final class LoadPokemonFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestsDataFromURL() {
        let url = anyURL()
        let client = HTTPClientSpy()
        let loader = RemotePokemonLoader(url: url, client: client)
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_deliversErrorOnClientError() {
        let url = anyURL()
        let client = HTTPClientSpy()
        let loader = RemotePokemonLoader(url: url, client: client)
        
        let exp = expectation(description: "Wait for completion")
        loader.load { receivedResult in
            switch receivedResult {
            case let .success(item):
                XCTFail("Should get error")
                
            case let .failure(error):
                XCTAssertEqual(error, RemotePokemonLoader.Error.unexpectedError)
            }
            
            exp.fulfill()
        }
        
        client.complete(with:  NSError(domain: "Test", code: 0))
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helper
    
    private func anyURL() -> URL {
        URL(string: "https://any-url.com")!
    }

}
