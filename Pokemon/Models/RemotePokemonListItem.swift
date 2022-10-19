//
//  RemotePokemonListItem.swift
//  
//
//  Created by Kevin Reid on 15/10/2022.
//

import Foundation

struct RemotePokemonListItem: Codable {
    let name: String
    let url: URL
    
    var id: String? {
        return url.pathComponents.last
    }
}
