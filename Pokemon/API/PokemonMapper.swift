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
        let height: Int
        let weight: Int
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
    
    public static func map(data: Data) -> Result<Pokemon, RemotePokemonLoader.Error> {
        guard let remoteItem = try? JSONDecoder().decode(RemotePokemon.self, from: data) else {
            return .failure(RemotePokemonLoader.Error.invalidData)
        }
        
        return .success(remoteItem.pokemon)
    }
}
