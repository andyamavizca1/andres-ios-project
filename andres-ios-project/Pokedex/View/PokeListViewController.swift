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

        title = "Pokemon App"
        
        setupBindings()
        viewModel.loadPokemons()
        
        tableView.register(UINib(nibName: "PokeCellTableViewCell", bundle: nil), forCellReuseIdentifier: "PokeCellTableViewCell")
    }
    
    private func setupBindings() {
        viewModel.isLoading
               .bind(to: activityIndicator.rx.isAnimating)
               .disposed(by: disposeBag)
        
        viewModel.pokemons
            .bind(to: tableView.rx.items(cellIdentifier: "PokeCellTableViewCell", cellType: PokeCellTableViewCell.self)) { (row, pokemon, cell) in
                   // This closure is called for each cell.
                   // It gives us the row number, the pokemon object for that row, and the cell.
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
}
