//
//  RemotePokemonList.swift
//  
//
//  Created by Kevin Reid on 15/10/2022.
//

import Foundation

struct RemotePokemonList: Codable {
    let results: [RemotePokemonListItem]
    let count: Int
}
