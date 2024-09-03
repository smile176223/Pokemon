//
//  PokemonViewModel.swift
//  Pokemon
//
//  Created by Liam on 2024/9/3.
//

import Foundation
import Combine

struct BaseURL {
    static let url: URL = URL(string: "https://pokeapi.co/api/v2/pokemon")!
}

public final class PokemonViewModel: ObservableObject {
    
    public enum Status: Equatable {
        case loading
        case done(Pokemon)
        case error(RemotePokemonLoader.Error)
    }
    
    @Published public var status: Status = .loading
    private var cancellables = Set<AnyCancellable>()
    private let pokemonLoader: PokemonLoader
    
    public init(pokemonLoader: PokemonLoader) {
        self.pokemonLoader = pokemonLoader
    }
    
    func load() {
        pokemonLoader.loadPublisher()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self?.status = .error(error)
                }
            } receiveValue: {  [weak self] pokemon in
                self?.status = .done(pokemon)
            }
            .store(in: &cancellables)
    }
}
