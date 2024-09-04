//
//  PokemonViewModelTests.swift
//  PokemonTests
//
//  Created by Liam on 2024/9/3.
//

import XCTest
@testable import Pokemon

final class PokemonViewModelTests: XCTestCase {
    
    func test_init_statusLoading() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.status, .loading)
    }
    
    func test_load_failureOnError() {
        let (sut, loaderSpy) = makeSUT()
        
        sut.load()
        
        loaderSpy.complete(with: .unexpectedError)
        
        RunLoop.main.run(until: .now + 0.1)
        XCTAssertEqual(sut.status, .error(.unexpectedError))
    }
    
    func test_load_successfullyGotPokemon() {
        let (sut, loaderSpy) = makeSUT()
        let pokemon = Pokemon(name: "any", height: 10, weight: 10, id: 2, type: "any type", spritesImage: "https://any-url.com")
        
        sut.load()
        
        loaderSpy.complete(with: pokemon)
        
        RunLoop.main.run(until: .now + 0.1)
        XCTAssertEqual(sut.status, .done(pokemon))
    }
    
    // MARK: - Helper
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: PokemonViewModel, loaderSpy: PokemonLoaderSpy) {
        let loaderSpy = PokemonLoaderSpy()
        let sut = PokemonViewModel(pokemonLoader: loaderSpy)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(loaderSpy)
        return (sut, loaderSpy)
    }
    
    private class PokemonLoaderSpy: PokemonLoader {
        
        private var messages = [(PokemonLoader.Result) -> Void]()
        
        func load(completion: @escaping (PokemonLoader.Result) -> Void) {
            messages.append(completion)
        }
        
        func complete(with error: RemotePokemonLoader.Error, at index: Int = 0, file: StaticString = #file, line: UInt = #line) {
            guard messages.count > index else {
                return XCTFail("Can't complete request never made", file: file, line: line)
            }
            
            messages[index](.failure(error))
        }
        
        func complete(with pokemon: Pokemon, at index: Int = 0, file: StaticString = #file, line: UInt = #line) {
            guard messages.count > index else {
                return XCTFail("Can't complete request never made", file: file, line: line)
            }

            messages[index](.success(pokemon))
        }
    }
}

