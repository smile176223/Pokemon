//
//  PokemonEndpoint.swift
//  Pokemon
//
//  Created by Liam on 2024/9/3.
//

import Foundation

public enum PokemonEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = baseURL.path + "/pikachu"
        return components.url!
    }
}
