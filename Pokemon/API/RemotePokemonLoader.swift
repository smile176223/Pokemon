//
//  RemotePokemonLoader.swift
//  Pokemon
//
//  Created by Liam on 2024/9/3.
//

import Foundation

public final class RemotePokemonLoader: PokemonLoader {
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
    
    public func load(completion: @escaping (PokemonLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .success((data, response)):
                break
                
            case .failure:
                completion(.failure(.unexpectedError))
            }
        }
    }
}
