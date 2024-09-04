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
        
        let result = PokemonMapper.map(data: data, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, .failure(.invalidData))
    }
    
    func test_map_deliversInvalidDataErrorOnInvalidJSONWith200Response() {
        let data = Data("Invalid json".utf8)
        
        let result = PokemonMapper.map(data: data, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, .failure(.invalidData))
    }
    
    func test_map_deliversPokemonOnValidJSONWith200Response() {
        let (model, json) = makePokemon()
        let data = makeData(json)
        
        let result = PokemonMapper.map(data: data, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, .success(model))
    }
    
    func test_map_deliversPokemonOnTypeEmptyWith200Response() {
        let (model, json) = makePokemon(type: nil)
        let data = makeData(json)
        
        let result = PokemonMapper.map(data: data, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, .success(model))
    }
}
