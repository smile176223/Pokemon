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
            VStack(spacing: 12) {
                pokemonImageView(pokemon)
                
                pokemonInfoView(pokemon)
            }
            .padding(.all, 12)
            
        case let .error(error):
            Text("Oh no, got error: \(error)")
        }
    }
    
    @ViewBuilder
    private func pokemonImageView(_ pokemon: Pokemon) -> some View {
        AsyncImage(url: URL(string: pokemon.spritesImage)) { phase in
            switch phase {
            case let .success(image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            case .failure:
                Color.clear
                
            default:
                ProgressView()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.lightGray, lineWidth: 4)
        )
    }
    
    @ViewBuilder
    private func pokemonInfoView(_ pokemon: Pokemon) -> some View {
        HStack(spacing: 12) {
            Color.lightGray
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(pokemon.displayName)
                            .themeTextStyle()
                        Text(pokemon.displayHeight)
                            .themeTextStyle()
                        Text(pokemon.displayWeight)
                            .themeTextStyle()
                        Text(pokemon.displayId)
                            .themeTextStyle()
                    }
                    .padding(.all, 12)
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Color.clear
                .overlay(alignment: .topLeading) {
                    GeometryReader { proxy in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(pokemon.displayTypeTitle)
                                .themeTextStyle()
                            
                            Text(pokemon.type)
                                .themeTextStyle()
                                .frame(width: proxy.size.width - 24)
                                .background {
                                    Color.lightGray
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                        .padding(.all, 12)
                    }
                }
        }
    }
}

#Preview {
    PokemonView()
}
