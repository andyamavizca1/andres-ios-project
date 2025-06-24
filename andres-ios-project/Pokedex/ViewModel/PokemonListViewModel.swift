//
//  PokemonListViewModel.swift
//  andres-ios-project
//
//  Created by andres.amavizca on 23/06/25.
//

import Foundation
import RxSwift
import RxCocoa

class PokemonListViewModel {
    let pokemons = PublishSubject<[Pokemon]>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishSubject<String>()

    private let disposeBag = DisposeBag()
    
    private let pokemonService: PokemonService
    
    init(pokemonService: PokemonService = PokemonService.shared) {
     
        self.pokemonService = pokemonService
    }


    func loadPokemons() {
        isLoading.accept(true)

        pokemonService.fetchPokemonList()
            .subscribe(
                onNext: { [weak self] fetchedPokemons in
                    self?.pokemons.onNext(fetchedPokemons)
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
