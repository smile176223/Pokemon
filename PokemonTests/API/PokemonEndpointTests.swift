//
//  PokemonEndpointTests.swift
//  PokemonTests
//
//  Created by Liam on 2024/9/3.
//

import XCTest
import Pokemon

final class PokemonEndpointTests: XCTestCase {
    
    func test_get_endpointURL() {
        let baseURL = URL(string: "https://base-url.com")!
        
        let received = PokemonEndpoint.get.url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/pikachu", "path")
    }
}

