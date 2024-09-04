//
//  PokemonMapper.swift
//  Pokemon
//
//  Created by Liam on 2024/9/3.
//

import Foundation

public struct PokemonMapper {
    
    private struct RemotePokemon: Decodable {
        
        struct PokemonType: Decodable {
            
            struct `Type`: Decodable {
                let name: String
            }
            
            let type: Type
        }
        
        struct Sprites: Decodable {
            
            struct Other: Decodable {
                
                struct Home: Decodable {
                    let front_default: String
                }
                
                let home: Home
            }
            
            let other: Other
        }
        
        let name: String
        let height: Double
        let weight: Double
        let id: Int
        let types: [PokemonType]
        let sprites: Sprites
        
        var pokemon: Pokemon {
            Pokemon(
                name: name,
                height: height,
                weight: weight,
                id: id,
                type: types.first?.type.name ?? "",
                spritesImage: sprites.other.home.front_default
            )
        }
    }
    
    private static var OK_200: Int { 200 }
    
    public static func map(data: Data, from response: HTTPURLResponse) -> PokemonLoader.Result {
        guard response.statusCode == OK_200,
            let remotePokemon = try? JSONDecoder().decode(RemotePokemon.self, from: data) else {
            return .failure(.invalidData)
        }
        
        return .success(remotePokemon.pokemon)
    }
}
