import Foundation

struct PokemonListResults: Codable {
    let results: [PokemonListResult]
}

struct PokemonListResult: Codable {
    let name: String
    let url: String
}

struct PokemonResult: Codable {
    let id: Int
    let name: String
    let types: [PokemonTypeEntry]
    let sprites: PokemonSprite
}

struct PokemonType: Codable {
    let name: String
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonSprite: Codable {
    let front_default: String
}

struct PokemonSpeciesEntry: Codable {
    let flavor_text_entries: [PokemonFlavorEntry]
}

struct PokemonFlavorEntry: Codable {
    let flavor_text: String
    let language: PokemonFlavorLanguage
    let version: PokemonFlavorVersion
}

struct PokemonFlavorLanguage: Codable {
    let name: String
    let url: String
}

struct PokemonFlavorVersion: Codable {
    let name: String
    let url: String
}

struct Pokedex {
    var caught = [String: Bool]()
}
