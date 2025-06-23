//
//  PokeListViewController.swift
//  andres-ios-project
//
//  Created by andres.amavizca on 23/06/25.
//

import UIKit
import RxSwift

class PokeListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = PokemonListViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Pokédex"
        
        setupBindings()
        viewModel.loadPokemons()
    }
    
    private func setupBindings() {
        viewModel.pokemons.subscribe(onNext: {pokemonArray in
            print("Fetched: \(pokemonArray)")
        })
        .disposed(by: disposeBag)
    }
}
