//
//  PokemonDetailViewModel.swift
//  andres-ios-project
//
//  Created by andres.amavizca on 23/06/25.
//

import Foundation
import RxSwift
import RxCocoa

class PokemonDetailViewModel {
    
    let pokemon: Pokemon
    
    let pokemonDetail = PublishSubject<PokemonDetail>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishSubject<String>()
    

    private let disposeBag = DisposeBag()
    
    private let pokemonService: PokemonService
    
    init(pokemon: Pokemon, pokemonService: PokemonService = PokemonService.shared) {
        self.pokemon = pokemon
        self.pokemonService = pokemonService
    }


    func loadPokemonDetail() {
        isLoading.accept(true)

        pokemonService.fetchPokemon(urlString: pokemon.url)
            .subscribe(
                onNext: { [weak self] fetchedPokemonDetail in
                    self?.pokemonDetail.onNext(fetchedPokemonDetail)
                    self?.isLoading.accept(false)
                },
                onError: { [weak self] err in
                    self?.error.onNext("Error: \(err.localizedDescription)")
                    self?.isLoading.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }
}
