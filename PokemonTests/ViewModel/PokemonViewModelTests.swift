//
//  PokemonViewModelTests.swift
//  PokemonTests
//
//  Created by Liam on 2024/9/3.
//

import XCTest
import Pokemon

final class PokemonViewModelTests: XCTestCase {
    
    func test_init_statusLoading() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.status, .loading)
    }
    
    // MARK: - Helper
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> PokemonViewModel {
        let loaderSpy = PokemonLoaderSpy()
        let sut = PokemonViewModel(pokemonLoader: loaderSpy)
        trackForMemoryLeaks(sut)
        return sut
    }
    
    private class PokemonLoaderSpy: PokemonLoader {
        
        func load(completion: @escaping (PokemonLoader.Result) -> Void) {
            
        }
    }
}

