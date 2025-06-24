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
    let types: [TypeElement]
    let abilities: [AbilityElement]
}

struct Sprites: Codable {
    let front_default: String
}

struct TypeElement: Codable {
    let type: Species
}

struct AbilityElement: Codable {
    let ability: Species
}

struct Species: Codable {
    let name: String
}
