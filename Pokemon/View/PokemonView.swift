//
//  PokemonViewV.swift
//  Pokemon
//
//  Created by Liam on 2024/9/3.
//

import SwiftUI

struct PokemonView: View {
    
    @ObservedObject var viewModel: PokemonViewModel
    private static let loader = RemotePokemonLoader(
        url: PokemonEndpoint.get.url(baseURL: BaseURL.url),
        client: URLSessionHTTPClient(session: .shared)
    )
    
    init(viewModel: PokemonViewModel = PokemonViewModel(pokemonLoader: loader)) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        pokemonView()
            .onAppear(perform: viewModel.load)
    }
    
    @ViewBuilder
    private func pokemonView() -> some View {
        switch viewModel.status {
        case .loading:
            Text("Loading...")
            
        case let .done(pokemon):
            Text(pokemon.name)
            
        case let .error(error):
            Text("Oh no, got error: \(error)")
        }
    }
}

#Preview {
    PokemonView()
}
