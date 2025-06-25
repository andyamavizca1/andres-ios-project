//
//  Pokemon.swift
//  andres-ios-project
//
//  Created by andres.amavizca on 23/06/25.
//

struct PokemonListResponse: Codable {
    let next: String?
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let name: String
    let url: String
}

struct PokemonDetail: Codable {
    let name: String
    let sprites: Sprites
    let types: [Types]
    let abilities: [Abilities]
}

struct Sprites: Codable {
    let front_default: String
}

struct Types: Codable {
    let type: PokemonType
}

struct Abilities: Codable {
    let ability: PokemonAbility
}

struct PokemonType: Codable {
    let name: String
    let url: String
}

struct PokemonAbility: Codable {
    let name: String
    let url: String
}

struct AbilityApiResponse: Decodable {
    let name: String
    let effect_entries: [EffectEntry]
}

struct EffectEntry: Decodable {
    let effect: String
    let language: Language
}

struct Language: Decodable {
    let name: String
}

struct AbilityDetail: Codable {
    let name: String
    let effect: String
}
