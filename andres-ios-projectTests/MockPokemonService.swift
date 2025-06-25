//
//  MockPokemonService.swift
//  andres-ios-projectTests
//
//  Created by andres.amavizca on 24/06/25.
//

import Foundation
import RxSwift
@testable import andres_ios_project

class MockPokemonService: PokemonService {
    
    override init() {
        super.init()
    }

    var pokemonListResult: Result<PokemonListResponse, PokemonServiceError>?
    var pokemonDetailResult: Result<PokemonDetail, PokemonServiceError>?
    var abilityDetailResult: Result<AbilityApiResponse, PokemonServiceError>?

    override func fetchPokemonList(limit: Int, offset: Int) -> Observable<PokemonListResponse> {
        return resolve(result: pokemonListResult)
    }
    
    override func fetchPokemon(urlString: String) -> Observable<PokemonDetail> {
        return resolve(result: pokemonDetailResult)
    }
    
    override func fetchAbility(urlString: String) -> Observable<AbilityApiResponse> {
        return resolve(result: abilityDetailResult)
    }

    private func resolve<T>(result: Result<T, PokemonServiceError>?) -> Observable<T> {
        guard let result = result else {
            return Observable.error(PokemonServiceError.networkError(
                NSError(domain: "MockError", code: 0, userInfo: [NSLocalizedDescriptionKey: "error"])
            ))
        }

        switch result {
        case .success(let value):
            return Observable.just(value)
        case .failure(let error):
            return Observable.error(error)
        }
    }
}
