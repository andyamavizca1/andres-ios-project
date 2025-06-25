//
//  PokemonDetailViewController.swift
//  andres-ios-project
//
//  Created by andres.amavizca on 23/06/25.
//

import UIKit
import RxSwift

class PokemonDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    @IBOutlet weak var abilitiesTableView: UITableView!
    
    @IBOutlet weak var typesTableView: UITableView!
    
    var viewModel: PokemonDetailViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details"

        guard viewModel != nil else {
              fatalError("Error: ViewModel does not exist.")
          }
        
          setupTableViews()
          setupBindings()
          viewModel.loadPokemonDetail()
    }
    
    private func setupTableViews() {
         abilitiesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "AbilityCell")
         typesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TypeCell")
     }
    
    private func setupBindings() {
        let pokemonDetailStream = viewModel.pokemonDetail
            .observe(on: MainScheduler.instance)
            .share(replay: 1)

        pokemonDetailStream
            .map { $0.name.capitalized }
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        let abilitiesStream = pokemonDetailStream
            .map { $0.abilities }

        abilitiesStream
            .bind(to: abilitiesTableView.rx.items(cellIdentifier: "AbilityCell")) { (row, abilitiesObject, cell) in
                cell.textLabel?.text = abilitiesObject.ability.name.capitalized
            }
            .disposed(by: disposeBag)

        pokemonDetailStream
            .map { $0.types.map { $0.type } }
            .bind(to: typesTableView.rx.items(cellIdentifier: "TypeCell")) { (row, pokemonType, cell) in
                cell.textLabel?.text = pokemonType.name.capitalized
            }
            .disposed(by: disposeBag)
        
        pokemonDetailStream
            .map { $0.sprites.front_default }
            .subscribe(onNext: { [weak self] imageUrlString in
                self?.loadImage(from: imageUrlString)
            })
            .disposed(by: disposeBag)
        
        abilitiesTableView.rx.modelSelected(Abilities.self)
            .subscribe(onNext: { [weak self] abilitiesObject in
                self?.showPokemonAbilities(for: abilitiesObject.ability)
            })
            .disposed(by: disposeBag)
    }

    private func showPokemonAbilities(for ability: PokemonAbility) {
        guard let abilitiesVC = storyboard?.instantiateViewController(withIdentifier: "PokemonAbilitiesViewController") as? PokemonAbilitiesViewController else {
            fatalError("Error creating PokemonAbilitiesViewController")
        }
        
        abilitiesVC.viewModel = PokemonAbilitiesViewModel(ability: ability)
        
        navigationController?.pushViewController(abilitiesVC, animated: true)

        if let selectedIndexPath = abilitiesTableView.indexPathForSelectedRow {
            abilitiesTableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }


    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.pokemonImageView.image = image
                }
            } else {
                print("Error getting image data")
            }
        }.resume()
    }


    
}
