import Foundation

struct RemotePokemonDetails: Codable {
    let name: String
    let weight: Int
    let height: Int
    let types: [RemotePokemonType]
    let sprites: RemotePokemonSprites?
}

struct RemotePokemonType: Codable {
    let slot: Int
    let type: RemotePokemonTypeResource
}

struct RemotePokemonTypeResource: Codable {
    let name: String
}

struct RemotePokemonSprites: Codable {
    let frontDefault: URL?
}
