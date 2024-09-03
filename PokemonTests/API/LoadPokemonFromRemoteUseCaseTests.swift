//
//  LoadPokemonFromRemoteUseCaseTests.swift
//  PokemonTests
//
//  Created by Liam on 2024/9/3.
//

import XCTest
import Pokemon

final class LoadPokemonFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestsDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.unexpectedError), when: {
            client.complete(with: anyError())
        })
    }
    
    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, sample in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                client.complete(withStatusCode: sample, data: anyData(), at: index)
            })
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
    
    private func expect(
        _ sut: RemotePokemonLoader,
        toCompleteWith expectedResult: Result<String, RemotePokemonLoader.Error>,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)

            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)

            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func anyURL() -> URL {
        URL(string: "https://any-url.com")!
    }
    
    private func anyData() -> Data {
        Data("any".utf8)
    }
    
    private func anyError() -> Error {
        NSError(domain: "any error", code: 0)
    }

}
