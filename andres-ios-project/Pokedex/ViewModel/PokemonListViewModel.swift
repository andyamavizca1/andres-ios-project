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

       private let disposeBag = DisposeBag()

       func loadPokemons() {
           PokemonService.shared.fetchPokemons()
               .subscribe(
                   onNext: { [weak self] fetchedPokemons in
                       self?.pokemons.onNext(fetchedPokemons)
                   },
                   onError: { error in
                       print("Error: \(error)")
                   }
               )
               .disposed(by: disposeBag)
       }
}
