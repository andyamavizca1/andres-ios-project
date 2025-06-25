//
//  PokemonAbilitiesViewModel.swift
//  andres-ios-project
//
//  Created by andres.amavizca on 24/06/25.
//

import Foundation
import RxSwift
import RxCocoa

class PokemonAbilitiesViewModel {
    
    let ability: PokemonAbility
    
    let abilityDetail = PublishSubject<AbilityDetail>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishSubject<String>()
    

    private let disposeBag = DisposeBag()
    
    private let pokemonService: PokemonService
    
    init(ability: PokemonAbility, pokemonService: PokemonService = PokemonService.shared) {
        self.ability = ability
        self.pokemonService = pokemonService
    }

    func loadAbilityDetails() {
        pokemonService.fetchAbility(urlString: ability.url)
            .map { apiResponse -> AbilityDetail in
                let englishEffect = apiResponse.effect_entries
                    .first { $0.language.name == "en" }?
                    .effect ?? "No English description found."
                
                return AbilityDetail(name: apiResponse.name, effect: englishEffect)
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] cleanAbilityDetail in
                self?.abilityDetail.onNext(cleanAbilityDetail)
            }, onError: { [weak self] err in
                self?.isLoading.accept(false)
                self?.error.onNext("Error fetching ability: \(err.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
