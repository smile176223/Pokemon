//
//  PokemonViewModel.swift
//  Pokemon
//
//  Created by Liam on 2024/9/3.
//

import Foundation
import Combine

public final class PokemonViewModel: ObservableObject {
    
    public enum Status: Equatable {
        case loading
        case done(Pokemon)
    }
    
    @Published public var status: Status = .loading
    
    public init() {}
    
}
