//
//  PokemonLoader.swift
//  Pokemon
//
//  Created by Liam on 2024/9/3.
//

import Foundation

public protocol PokemonLoader {
    typealias Result = Swift.Result<Pokemon, RemotePokemonLoader.Error>
    
    func load(completion: @escaping (Result) -> Void)
}
