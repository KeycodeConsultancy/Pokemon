//
//  URL+Extensions.swift
//  
//
//  Created by Kevin Reid on 15/10/2022.
//

import Foundation

extension URL {
    static var forAllPokemons: URL {
        URL(string: "https://pokeapi.co/api/v2/pokemon")!
    }
    static func forPokemonId(_ id: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "pokeapi.co"
        components.path = "/api/v2/"
        components.path.append("pokemon/\(id)")
        return components.url
    }
}

extension  RemotePokemonList {
    static var all: Resource<RemotePokemonList> {
        return Resource(url: URL.forAllPokemons)
    }
}

extension RemotePokemonDetails {
    static func byId(_ id: String) -> Resource<RemotePokemonDetails> {
        guard let url = URL.forPokemonId(id) else {
            fatalError("id = \(id) was not found.")
        }
        return Resource(url: url)
    }
}
