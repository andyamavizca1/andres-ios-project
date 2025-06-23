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
    let error = PublishSubject<String>() // Or use `Error` type directly

    private let disposeBag = DisposeBag()

    func loadPokemons() {
        isLoading.accept(true)

        PokemonService.shared.fetchPokemons()
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
