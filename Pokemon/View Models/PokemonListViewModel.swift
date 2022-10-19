//
//  PokemonListViewModel.swift
//  
//
//  Created by Kevin Reid on 15/10/2022.
//

import Foundation

var pokemonsMaxRecordsCount: Int = 0

final class PokemonListViewModel {
    
    fileprivate var pokemons: [PokemonViewModel] = []
    fileprivate var pokemonDetails: RemotePokemonDetails!
    
    func fetchAllPokemons(offset: Int = 0, limit: Int = 20) async throws -> [PokemonViewModel] {
        do {
            let pokemons = try await Webservice().load(RemotePokemonList.all, offset: offset, limit: limit)
            self.pokemons = pokemons.results.map(PokemonViewModel.init)
            pokemonsMaxRecordsCount = pokemons.count
            
        } catch {
            print(error)
        }
        return self.pokemons
    }
    
    func fetchPokemonDetailsByID(id: String) async throws -> RemotePokemonDetails  {
        do {
            pokemonDetails = try await Webservice().load(RemotePokemonDetails.byId(id))
        } catch {
            print(error)
        }
        return self.pokemonDetails
    }
}

struct PokemonViewModel  {
    
    fileprivate var pokemon: RemotePokemonListItem
    
    var name: String {
        pokemon.name
    }
    
    var id: String? {
        pokemon.id
    }
    
    var count: Int {
        pokemonsMaxRecordsCount
    }
}
