//
//  PokeListViewController.swift
//  andres-ios-project
//
//  Created by andres.amavizca on 23/06/25.
//

import UIKit
import RxSwift

class PokeListViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel = PokemonListViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Pokélist"
        
        setupBindings()
        viewModel.loadPokemons()
        
        tableView.register(UINib(nibName: "PokeCellTableViewCell", bundle: nil), forCellReuseIdentifier: "PokeCellTableViewCell")
        
        tableView.rx.modelSelected(Pokemon.self)
            .subscribe(onNext: { [weak self] pokemon in
                self?.showPokemonDetail(for: pokemon)
            })
            .disposed(by: disposeBag)

    }
    
    private func setupBindings() {
        viewModel.isLoading
               .observe(on: MainScheduler.instance)
               .bind(to: activityIndicator.rx.isAnimating)
               .disposed(by: disposeBag)
        
        viewModel.pokemons
            .bind(to: tableView.rx.items(cellIdentifier: "PokeCellTableViewCell", cellType: PokeCellTableViewCell.self)) { (row, pokemon, cell) in
                   cell.nameLabel.text = pokemon.name.capitalized

               }
               .disposed(by: disposeBag)
        
        viewModel.error
              .observe(on: MainScheduler.instance)
              .subscribe(onNext: { [weak self] error in
                  let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "OK", style: .default))
                  self?.present(alert, animated: true)
              })
              .disposed(by: disposeBag)

    }
    
    
    private func showPokemonDetail(for pokemon: Pokemon) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "PokemonDetailViewController") as? PokemonDetailViewController else {
            fatalError("Error creating PokemonDetailViewController")
        }

        detailVC.viewModel = PokemonDetailViewModel(pokemon: pokemon)
        
        navigationController?.pushViewController(detailVC, animated: true)

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

}
