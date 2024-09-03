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
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    private static var OK_200: Int { 200 }
    
    public func load(completion: @escaping (Result<String, Error>) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((data, response)):
                guard response.statusCode == Self.OK_200 else {
                    return completion(.failure(.invalidData))
                }
                
            case .failure:
                completion(.failure(.unexpectedError))
            }
        }
    }
}

final class LoadPokemonFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestsDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        let exp = expectation(description: "Wait for completion")
        sut.load { receivedResult in
            switch receivedResult {
            case .success:
                XCTFail("Should get error")
                
            case let .failure(error):
                XCTAssertEqual(error, .unexpectedError)
            }
            
            exp.fulfill()
        }
        
        client.complete(with: NSError(domain: "Test", code: 0))
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, sample in
            let exp = expectation(description: "Wait for completion")
            sut.load { receivedResult in
                switch receivedResult {
                case .success:
                    XCTFail("Should get error")
                    
                case let .failure(error):
                    XCTAssertEqual(error, .invalidData)
                }
                
                exp.fulfill()
            }
            
            client.complete(withStatusCode: sample, data: anyData(), at: index)
            
            wait(for: [exp], timeout: 1.0)
        }
    }
    
    // MARK: - Helper
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RemotePokemonLoader, client: HTTPClientSpy) {
        let url = anyURL()
        let client = HTTPClientSpy()
        let loader = RemotePokemonLoader(url: url, client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (loader, client)
    }
    
    private func anyURL() -> URL {
        URL(string: "https://any-url.com")!
    }
    
    private func anyData() -> Data {
        Data("any".utf8)
    }

}
