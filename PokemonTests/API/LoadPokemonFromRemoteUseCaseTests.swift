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
    
    func test_load_deliversPokemonOn200Response() {
        let (sut, client) = makeSUT()
        let (model, json) = makePokemon()
        let data = makeData(json)
        
        expect(sut, toCompleteWith: .success(model), when: {
            client.complete(withStatusCode: 200, data: data)
        })
    }
    
    // Publisher
    
    func test_loadPublisher_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        let exp = expectation(description: "Wait for completion")
        
        let cancellable = sut.loadPublisher()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    XCTAssertEqual(error, .unexpectedError)
                }
                
                exp.fulfill()
            } receiveValue: { _ in
                XCTFail("Expected failure")
            }
        
        client.complete(with: anyError())

        wait(for: [exp], timeout: 1.0)
        cancellable.cancel()
    }
    
    func test_loadPublisher_deliversPokemonOn200Response() {
        let (sut, client) = makeSUT()
        let (model, json) = makePokemon()
        let data = makeData(json)
        
        let exp = expectation(description: "Wait for completion")
        
        let cancellable = sut.loadPublisher()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    XCTFail("Expected succeeds")
                }
                
                exp.fulfill()
            } receiveValue: { pokemon in
                XCTAssertEqual(pokemon, model)
            }
        
        client.complete(withStatusCode: 200, data: data)

        wait(for: [exp], timeout: 1.0)
        cancellable.cancel()
    }
    
    // MARK: - Helper
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: PokemonLoader, client: HTTPClientSpy) {
        let url = anyURL()
        let client = HTTPClientSpy()
        let loader = RemotePokemonLoader(url: url, client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (loader, client)
    }
    
    private func expect(
        _ sut: PokemonLoader,
        toCompleteWith expectedResult: PokemonLoader.Result,
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
}
