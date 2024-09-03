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
        statusView()
            .onAppear(perform: viewModel.load)
    }
    
    @ViewBuilder
    private func statusView() -> some View {
        switch viewModel.status {
        case .loading:
            ProgressView()
            
        case let .done(pokemon):
            pokemonView(pokemon)
            
        case let .error(error):
            Text("Oh no, got error: \(error)")
        }
    }
    
    @ViewBuilder
    private func pokemonView(_ pokemon: Pokemon) -> some View {
        VStack {
            AsyncImage(url: URL(string: pokemon.spritesImage)) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                case let .failure(error):
                    Color.gray
                    
                default:
                    ProgressView()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.lightGray, lineWidth: 4)
            )
            
            Spacer()
        }
        .padding(.all, 12)
    }
}

#Preview {
    PokemonView()
}
