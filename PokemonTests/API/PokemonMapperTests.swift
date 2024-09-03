//
//  PokemonMapperTests.swift
//  PokemonTests
//
//  Created by Liam on 2024/9/3.
//

import XCTest
import Pokemon

final class PokemonMapperTests: XCTestCase {
    
    func test_map_deliversInvalidDataErrorOnNon200Response() {
        let samples = [199, 201, 300, 400, 500]
        
        samples.forEach { sample in
            let result = PokemonMapper.map(data: anyData(), from: HTTPURLResponse(statusCode: sample))
            
            XCTAssertEqual(result, .failure(.invalidData))
        }
    }
    
    func test_map_deliversInvalidDataErrorOnEmptyJSONWith200Response() {
        let data = makeData([:])
        
        let pokemon = PokemonMapper.map(data: data, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(pokemon, .failure(.invalidData))
    }
    
    func test_map_deliversInvalidDataErrorOnInvalidJSONWith200Response() {
        let data = Data("Invalid json".utf8)
        
        let pokemon = PokemonMapper.map(data: data, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(pokemon, .failure(.invalidData))
    }
    
    func test_map_deliversPokemonOnValidJSONWith200Response() {
        let (model, json) = makePokemon()
        let data = makeData(json)
        
        let pokemon = PokemonMapper.map(data: data, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(pokemon, .success(model))
    }
    
    func test_map_deliversPokemonOnTypeEmptyWith200Response() {
        let (model, json) = makePokemon(type: nil)
        let data = makeData(json)
        
        let pokemon = PokemonMapper.map(data: data, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(pokemon, .success(model))
    }
    
    
    // MARK: - Helper
    
    private func makeData(_ json: [String: Any]) -> Data {
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func makePokemon(
        name: String = "pikachu",
        height: Int = 4,
        weight: Int = 60,
        id: Int = 25,
        type: String? = "electric",
        spritesImage: String = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/25.png"
    ) -> (model: Pokemon, json: [String: Any]) {
        var json: [String: Any] = [
            "name": "pikachu",
            "height": 4,
            "weight": 60,
            "id": 25,
            "sprites": [
                "other": [
                    "home": [
                        "front_default": spritesImage
                    ]
                ]
            ]
        ]
        
        if let type = type {
            json["types"] = [
                [
                    "type": [
                        "name": type
                    ]
                ]
            ]
        } else {
            json["types"] = []
        }
        
        
        let model = Pokemon(name: name, height: height, weight: weight, id: id, type: type ?? "", spritesImage: spritesImage)
        
        return (model, json.compactMapValues { $0 })
    }
}
