//
//  XCTest+Helpers.swift
//  PokemonTests
//
//  Created by Liam on 2024/9/3.
//

import Foundation

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}

func anyData() -> Data {
    Data("any".utf8)
}

func anyError() -> Error {
    NSError(domain: "any error", code: 0)
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
