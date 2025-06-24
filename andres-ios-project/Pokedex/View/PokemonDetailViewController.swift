//
//  PokemonDetailViewController.swift
//  andres-ios-project
//
//  Created by andres.amavizca on 23/06/25.
//

import UIKit
import RxSwift

class PokemonDetailViewController: UIViewController {

    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    var viewModel: PokemonDetailViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard viewModel != nil else {
              fatalError("Error: ViewModel does not exist.")
          }

          setupBindings()
          viewModel.loadPokemonDetail()
    }
    
    
    private func setupBindings() {
        viewModel.pokemonDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { detail in
                self.nameLabel.text = detail.name
                self.abilitiesLabel.text = detail.abilities
                    .map { $0.ability.name }
                    .joined(separator: ", ")

                self.typesLabel.text = detail.types
                    .map { $0.type.name }
                    .joined(separator: ", ")

                self.loadImage(from: detail.sprites.front_default)
            })
            .disposed(by: disposeBag)
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
