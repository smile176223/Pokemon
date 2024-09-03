//
//  URLSessionHTTPClientTests.swift
//  PokemonTests
//
//  Created by Liam on 2024/9/3.
//

import XCTest
import Pokemon

final class URLSessionHTTPClientTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        
        URLProtocolStub.removeStub()
    }
    
    func test_getFromURL_performsGETRequestWithURL() {
        let url = anyURL()
        let exp = expectation(description: "Wait for request")
        
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        makeSUT().get(from: url) { _ in }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_failsOnRequestError() {
        let requestError = NSError(domain: "Any error", code: 0)
        URLProtocolStub.stub(data: nil, response: nil, error: requestError)
        let exp = expectation(description: "Wait for request")
        
        makeSUT().get(from: anyURL()) { result in
            switch result {
            case .success:
                XCTFail("Should got error")
                
            case let .failure(error as NSError):
                XCTAssertEqual(requestError.domain, error.domain)
                XCTAssertEqual(requestError.code, error.code)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let data = anyData()
        let response = HTTPURLResponse(statusCode: 200)
        URLProtocolStub.stub(data: data, response: response, error: nil)
        let exp = expectation(description: "Wait for request")
        
        makeSUT().get(from: anyURL()) { result in
            switch result {
            case let .success((receivedData, receivedResponse)):
                XCTAssertEqual(data, receivedData)
                XCTAssertEqual(response.url, receivedResponse.url)
                XCTAssertEqual(response.statusCode, receivedResponse.statusCode)
                
            case let .failure(error):
                XCTFail("Expected failure, but got \(error) instead.")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helper
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = URLSessionHTTPClient(session: session)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
