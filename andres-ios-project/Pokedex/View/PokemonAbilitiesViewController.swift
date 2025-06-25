//
//  PokemonAbilitiesViewController.swift
//  andres-ios-project
//
//  Created by andres.amavizca on 24/06/25.
//

import UIKit
import RxSwift

class PokemonAbilitiesViewController: UIViewController {

    @IBOutlet weak var abilityName: UILabel!
    @IBOutlet weak var abilityDescription: UITextView!
    var viewModel: PokemonAbilitiesViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard viewModel != nil else {
              fatalError("Error: ViewModel does not exist.")
          }
        
          setupBindings()
          viewModel.loadAbilityDetails()
    }

    

    private func setupBindings() {
        let pokemonAbilityStream = viewModel.abilityDetail
            .observe(on: MainScheduler.instance)
        
        pokemonAbilityStream
            .map { $0.name.capitalized }
            .bind(to: abilityName.rx.text)
            .disposed(by: disposeBag)
        
        pokemonAbilityStream
            .map { $0.effect.capitalized }
            .bind(to: abilityDescription.rx.text)
            .disposed(by: disposeBag)
    }

}
