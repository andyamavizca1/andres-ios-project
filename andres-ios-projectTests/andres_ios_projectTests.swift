//
//  andres_ios_projectTests.swift
//  andres-ios-projectTests
//
//  Created by andres.amavizca on 23/06/25.
//

import XCTest
import RxSwift
@testable import andres_ios_project

final class PokemonViewModelTests: XCTestCase {

    var mockService: MockPokemonService!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockService = MockPokemonService()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        mockService = nil
        disposeBag = nil
        super.tearDown()
    }

    func testListViewModel_LoadMore_AppendsToList() {
        let expectation = self.expectation(description: "Load more pokemons to the list")
        
        let initialPokemon = [Pokemon(name: "pika123", url: "123")]
        let initialResponse = PokemonListResponse(next: "123", results: initialPokemon)
        mockService.pokemonListResult = .success(initialResponse)
        let viewModel = PokemonListViewModel(pokemonService: mockService)
        
        viewModel.initialLoad()
        
        let morePokemon = [Pokemon(name: "pika234", url: "234")]
        let moreResponse = PokemonListResponse(next: nil, results: morePokemon)
        mockService.pokemonListResult = .success(moreResponse)

        viewModel.pokemons
            .subscribe(onNext: { pokemons in
                if pokemons.count == 2 {
                    XCTAssertEqual(pokemons.last?.name, "pika234")
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)
            
        viewModel.loadMore()
        
        waitForExpectations(timeout: 1.0)
    }

    func testDetailViewModel_LoadDetail_Success() {
        let expectation = self.expectation(description: "Fetched pokemon details successfully")
        let mockDetail = PokemonDetail(name: "pika123",
                                       sprites: Sprites(front_default: "sprite_url"),
                                       types: [],
                                       abilities: [])
        mockService.pokemonDetailResult = .success(mockDetail)
        
        let pokemon = Pokemon(name: "pika123", url: "123")
        let viewModel = PokemonDetailViewModel(pokemon: pokemon, pokemonService: mockService)

        viewModel.pokemonDetail
            .subscribe(onNext: { detail in
                XCTAssertEqual(detail.name, "pika123")
                XCTAssertEqual(detail.sprites.front_default, "sprite_url")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.loadPokemonDetail()
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testAbilitiesViewModel_LoadAbility_Success() {
        let expectation = self.expectation(description: "Fetched ability details successfully")
        let effectEntry = EffectEntry(effect: "effect123", language: Language(name: "en"))
        let mockResponse = AbilityApiResponse(name: "123", effect_entries: [effectEntry])
        mockService.abilityDetailResult = .success(mockResponse)
        
        let ability = PokemonAbility(name: "123", url: "effect_url")
        let viewModel = PokemonAbilitiesViewModel(ability: ability, pokemonService: mockService)
        
        viewModel.abilityDetail
            .subscribe(onNext: { abilityDetail in
                XCTAssertEqual(abilityDetail.name, "123")
                XCTAssertEqual(abilityDetail.effect, "effect123")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        viewModel.loadAbilityDetails()
        
        waitForExpectations(timeout: 1.0)
    }
}
