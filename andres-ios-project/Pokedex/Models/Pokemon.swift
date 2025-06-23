//
//  Pokemon.swift
//  andres-ios-project
//
//  Created by andres.amavizca on 23/06/25.
//

struct PokemonListResponse: Codable {
    let results: [Pokemon]
}

struct Pokemon: Codable {
    let name: String
    let url: String
}
