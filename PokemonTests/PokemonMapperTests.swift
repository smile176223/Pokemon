//
//  PokemonMapperTests.swift
//  PokemonTests
//
//  Created by Liam on 2024/9/3.
//

import XCTest

public struct Pokemon: Hashable {
    public let name: String
    public let height: Int
    public let weight: Int
    public let id: Int
    public let type: String
    public let spritesImage: String
    
    public init(name: String, height: Int, weight: Int, id: Int, type: String, spritesImage: String) {
        self.name = name
        self.height = height
        self.weight = weight
        self.id = id
        self.type = type
        self.spritesImage = spritesImage
    }
}

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

final class PokemonMapperTests: XCTestCase {
    
    func test_map_deliversInvalidDataErrorOnEmptyJSON() {
        let data = makeData([:])
        
        let pokemon = PokemonMapper.map(data: data)
        
        XCTAssertEqual(pokemon, .failure(.invalidData))
    }
    
    func test_map_deliversInvalidDataErrorOnInvalidJSON() {
        let data = Data("Invalid json".utf8)
        
        let pokemon = PokemonMapper.map(data: data)
        
        XCTAssertEqual(pokemon, .failure(.invalidData))
    }
    
    func test_map_deliversPokemonOnValidJSON() {
        let json: [String: Any] = [
            "name": "pikachu",
            "height": 4,
            "weight": 60,
            "id": 25,
            "types": [
                [
                    "type": [
                        "name": "electric"
                    ]
                ]
            ],
            "sprites": [
                "other": [
                    "home": [
                        "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/25.png"
                    ]
                ]
            ]
        ].compactMapValues { $0 }
        let data = makeData(json)
        
        let pokemon = PokemonMapper.map(data: data)
        
        XCTAssertEqual(pokemon, .success(Pokemon(name: "pikachu", height: 4, weight: 60, id: 25, type: "electric", spritesImage: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/25.png")))
    }
    
    
    // MARK: - Helper
    
    private func makeData(_ json: [String: Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
