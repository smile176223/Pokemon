//
//  PokemonTests.swift
//  PokemonTests
//
//  Created by Liam on 2024/9/4.
//

import XCTest
import Pokemon

final class PokemonTests: XCTestCase {
    
    func test_displayName() {
        let sut = makeSUT(name: "any")
        
        XCTAssertEqual(sut.displayName, "Name: Any")
    }
    
    func test_displayHeight() {
        let sut = makeSUT(height: 50.5)
        
        XCTAssertEqual(sut.displayHeight, "Height: 5.05m")
    }
    
    func test_displayWeight() {
        let sut = makeSUT(weight: 20.000000)
        
        XCTAssertEqual(sut.displayWeight, "Weight: 2.0kg")
    }
    
    func test_displayId() {
        let sut = makeSUT(id: 20)
        
        XCTAssertEqual(sut.displayId, "ID: #020")
    }
    
    
    // MARK: - Helper
    
    private func makeSUT(
        name: String = "any",
        height: Double = 50.0,
        weight: Double = 20.0,
        id: Int = 20,
        type: String = "any type",
        spritesImage: String = "https://any-url.com"
    ) -> Pokemon {
        Pokemon(name: name, height: height, weight: weight, id: id, type: type, spritesImage: spritesImage)
    }
}

