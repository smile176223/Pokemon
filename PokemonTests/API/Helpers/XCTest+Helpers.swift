//
//  XCTest+Helpers.swift
//  PokemonTests
//
//  Created by Liam on 2024/9/3.
//

import Foundation
import Pokemon

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

func makePokemon(
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

func makeData(_ json: [String: Any]) -> Data {
    return try! JSONSerialization.data(withJSONObject: json)
}
