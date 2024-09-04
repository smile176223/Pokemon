//
//  PokemonLoader.swift
//  Pokemon
//
//  Created by Liam on 2024/9/3.
//

import Foundation
import Combine

public protocol PokemonLoader {
    typealias Result = Swift.Result<Pokemon, RemotePokemonLoader.Error>
    
    func load(completion: @escaping (Result) -> Void)
}

public extension PokemonLoader {
    typealias Publisher = AnyPublisher<Pokemon, RemotePokemonLoader.Error>
    
    func loadPublisher() -> Publisher {
        Deferred {
            Future { completion in
                self.load(completion: completion)
            }
        }
        .eraseToAnyPublisher()
    }
    
}
