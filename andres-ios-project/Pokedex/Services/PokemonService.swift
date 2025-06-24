//
//  PokemonService.swift
//  andres-ios-project
//
//  Created by andres.amavizca on 23/06/25.
//
import Foundation
import RxSwift
import RxCocoa

enum PokemonServiceError: Error {
    case invalidURL
    case decodingError(Error)
    case networkError(Error)
}

class PokemonService {
    static let shared = PokemonService()
    private let baseURL = "https://pokeapi.co/api/v2"

    private init() {}

    func fetchPokemonList(limit: Int, offset: Int) -> Observable<PokemonListResponse> {
        let urlString = "\(baseURL)/pokemon/?limit=\(limit)&offset=\(offset)"
        guard let url = URL(string: urlString) else {
            return Observable.error(PokemonServiceError.invalidURL)
        }
        
        return URLSession.shared.rx.data(request: URLRequest(url: url)).map { data in
            do {
                let decoder = JSONDecoder()
                let pokemonResponse = try decoder.decode(PokemonListResponse.self, from: data)
                return pokemonResponse
            } catch {
                throw PokemonServiceError.decodingError(error)
            }
        }
    }
    
    func fetchPokemon(urlString: String) -> Observable<PokemonDetail> {
        guard let url = URL(string: urlString) else {
            return Observable.error(PokemonServiceError.invalidURL)
        }
        
        return URLSession.shared.rx.data(request: URLRequest(url: url)).map { data in
            do {
                let decoder = JSONDecoder()
                let pokemonResponse = try decoder.decode(PokemonDetail.self, from: data)
                return pokemonResponse
            } catch {
                print("Error: \(error)")
                throw PokemonServiceError.decodingError(error)
            }
        }
    }
}
