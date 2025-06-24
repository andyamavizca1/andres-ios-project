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
    let pokemons = BehaviorRelay<[Pokemon]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishSubject<String>()

    private let disposeBag = DisposeBag()
    private let pokemonService: PokemonService
    
    private var offset = 0
    private let limit = 20
    private var isFetching = false
    private var canLoadMore = true
    
    init(pokemonService: PokemonService = PokemonService.shared) {
        self.pokemonService = pokemonService
    }
    
    func initialLoad() {
          offset = 0
          canLoadMore = true
          pokemons.accept([])
            loadMore()
      }

    func loadMore() {
        guard !isFetching, canLoadMore else { return }
        
        isFetching = true
       
        if offset == 0 {
            isLoading.accept(true)
        }

        pokemonService.fetchPokemonList(limit: limit, offset: offset)
            .subscribe(
                onNext: { [weak self] response in
                    guard let self = self else { return }

                    let currentPokemons = self.pokemons.value
                    self.pokemons.accept(currentPokemons + response.results)
                    
                    self.offset += self.limit
                    self.canLoadMore = response.next != nil
                    
                    self.isLoading.accept(false)
                    self.isFetching = false
                },
                onError: { [weak self] err in
                    self?.error.onNext("Error: \(err.localizedDescription)")
                    self?.isLoading.accept(false)
                    self?.isFetching = false
                }
            )
            .disposed(by: disposeBag)
    }
}
